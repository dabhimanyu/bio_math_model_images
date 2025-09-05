function C = load_config(config_path)
%LOAD_CONFIG Load and merge a JSON configuration file with defaults.
%   C = LOAD_CONFIG(CONFIG_PATH) reads the JSON file located at
%   CONFIG_PATH, decodes it into a MATLAB struct, and fills in any
%   missing fields using a built-in default template. The returned
%   configuration struct C contains all keys expected by the pipeline,
%   ensuring universality across modes (tirf, beads, synthetic) via
%   enabled flags and null skips for reproducibility in biomedical
%   workflows like TIRF exocytosis detection.
%
%   The loader performs a simple checks on the mandatory
%   configuration fields, notably C.io.mode, and asserts that the mode is
%   one of the permitted values ('tirf','beads','synthetic'). If the
%   configuration fails validation, an error is thrown.
%
%   This helper intentionally avoids reliance on dynamic field names or
%   external dependencies. It will recursively merge nested structs so
%   that user-provided values override defaults while unspecified
%   subfields inherit sensible defaults. Additional keys present in the
%   user configuration but absent from the defaults are preserved.
% 
% 
% CRITICAL:
% 
% This Works Correctly:
% C = load_config('/Users/abhimanyudubey/MATLAB-Drive/CRAP/bio_math_model_images/TIRFM_v2_protocol/configs/beads_default.json')
% 
% THIS DOES NOT WORKS CORRECTLY:
% C = load_config("/Users/abhimanyudubey/MATLAB-Drive/CRAP/bio_math_model_images/TIRFM_v2_protocol/demos/tirf_demo.json")
% 
% WRITTEN BY
%
% Abhimanyu Dubey
% Joint Ph.D. student,
% Prof. V. Kumaran’s Lab
% Department of Chemical Engineering,
% IISc Bangalore, 
% Prof. Manaswita Bose’s Lab,
% Department of Energy Science and Engineering,
% IIT-BOMBAY
% 
%%

% Validate input
if nargin < 1 || ~ischar(config_path)
    error('load_config:InvalidInput', 'A JSON configuration file path must be provided.');
end

% Read and decode the JSON configuration
try
    jsonText = fileread(config_path);
catch ME
    error('load_config:FileReadError', 'Unable to read configuration file: %s', ME.message);
end

try
    userConfig = jsondecode(jsonText);
catch ME
    error('load_config:JSONDecodeError', 'Configuration file is not valid JSON: %s', ME.message);
end

% Build default template configuration
defaultConfig = get_default_config();

% Recursively merge user configuration over defaults
C = merge_structs(defaultConfig, userConfig);

% Sanity check on io.mode
if ~isfield(C, 'io') || ~isfield(C.io, 'mode') || ~ischar(C.io.mode)
    error('load_config:MissingMode', 'Configuration must specify io.mode as a string.');
end

validModes = {'tirf', 'beads', 'synthetic'};
if isempty(strcmpi(C.io.mode, validModes))
    error('load_config:UnknownMode', 'Unknown io.mode "%s". Valid values are: tirf, beads, synthetic.', C.io.mode);
end

end

function cfg = get_default_config()
%GET_DEFAULT_CONFIG Return a struct corresponding to the authoritative
%configuration template used throughout the TIRF pipeline. This
%template matches the updated JSON schema documented in the project plan,
%with split preprocess sections for two-stage masking alignment to legacy
%(e.g., pre-mask Wiener for coarse thresholding, post-mask sharpen/median
%for fine-tuning in tirf mode). It serves as the base for filling in
%missing fields when loading user configuration files, ensuring
%publication-grade reproducibility and flexibility for biologists.

cfg.io = struct(...
    'mode', 'tirf', ...
    'input_path', 'data/tirf/demo', ...
    'file_glob', '*.tif', ...
    'output_root', 'outputs/tirf', ...
    'run_id', 'Run_001', ...
    'random_seed', 0);

cfg.pilot = struct(...
    'enabled', true, ...
    'num_frames', 2, ...
    'exit_after', false);

% Pre-mask preprocess defaults: Typically minimal (e.g., Wiener only for tirf coarse mask)
cfg.pre_mask_preprocess = struct(...
    'enabled', true, ...
    'wiener',  struct('enabled', true, 'window', 5), ...
    'median',  struct('enabled', true, 'window', 2, 'padding', 'symmetric'), ...
    'sharpen', struct('enabled', true, 'radius', 1.05, 'amount', 1.6, 'threshold', 0.7));

% Masking defaults: Added manual mode for legacy thresholds (e.g., >18500 for tirf, >130 for synthetic);
% morphology now has enabled flag for selective skipping (e.g., false for synthetic)
morphology = struct('enabled', true, 'se_type', 'disk', 'close_radius', 100, 'dilate_radius', 5, 'open_radius', 4);

global_otsu = struct('enabled', true);
manual = struct('enabled', false, 'threshold', []);
block_otsu = struct('enabled', false, 'block_size', 64, 'border_size', 8, 'use_parallel', true);
bradley   = struct('enabled', false, 'window_size', 63, 'sensitivity', 0.30);

cfg.masking = struct(...
    'enabled', true, ...
    'mode', 'global_otsu', ...
    'global_otsu', global_otsu, ...
    'manual', manual, ...
    'block_otsu', block_otsu, ...
    'bradley_adaptive', bradley, ...
    'morphology', morphology);

% Post-mask preprocess defaults: Full filters (e.g., Wiener/sharpen/median for tirf fine-tuning)
cfg.post_mask_preprocess = struct(...
    'enabled', true, ...
    'wiener',  struct('enabled', true, 'window', 5), ...
    'median',  struct('enabled', true, 'window', 2, 'padding', 'symmetric'), ...
    'sharpen', struct('enabled', true, 'radius', 1.05, 'amount', 1.6, 'threshold', 0.7));

% New H-max suppression: Enabled for tirf legacy (h=1200, conn=8); disabled otherwise
cfg.hmax_suppression = struct(...
    'enabled', true, ...
    'h_value', 1200, ...
    'connectivity', 8);

% Regional max: Added rescale_before for tirf legacy rescale(img)
cfg.regional_max = struct('enabled', true, 'connectivity', 4, 'rescale_before', true);

cfg.components   = struct('enabled', true, 'connectivity', 4);

cfg.subpixel = struct('enabled', true, 'method', '2d_gaussian');

cfg.tracking = struct(...
    'enabled', true, ...
    'max_disp', 4.9, ...
    'skip_frames', 1, ...
    'remove_nearby_particles', struct('enabled', false, 'percent_of_max_pixel_displacement', 105), ...
    'carry_intensity', true, ...
    'export_csv', true, ...
    'export_mat', false);

cfg.intensity = struct('enabled', true, 'estimator', 'mean_5px_cross', 'normalize_per_track', true);

cfg.outputs = struct(...
    'export_centroids_mat', true, ...
    'export_detection_csv', true, ...
    'export_figures', true, ...
    'save_intermediates', false);

end

function out = merge_structs(def, usr)
%MERGE_STRUCTS Recursively merge two structs.
%   OUT = MERGE_STRUCTS(DEF, USR) returns a struct OUT where fields
%   present in USR override those in DEF, while fields absent in USR
%   inherit values from DEF. Nested structs are processed recursively.

out = def;
defFields = fieldnames(def);
usrFields = fieldnames(usr);

% Override or merge existing fields
for i = 1:numel(defFields)
    field = defFields{i};
    if isfield(usr, field)
        if isstruct(def.(field)) && isstruct(usr.(field))
            % Recursive merge for nested structs
            out.(field) = merge_structs(def.(field), usr.(field));
        else
            % Override scalar or non-struct values
            out.(field) = usr.(field);
        end
    else
        % Use default value from def
        out.(field) = def.(field);
    end
end

% Append any extra fields present only in usr
extraFields = setdiff(usrFields, defFields);
for i = 1:numel(extraFields)
    field = extraFields{i};
    out.(field) = usr.(field);
end

end