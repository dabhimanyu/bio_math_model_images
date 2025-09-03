function cfg = load_config(configPath)
% LOAD_CONFIG Read and validate a strict JSON configuration file
% cfg = load_config(configPath)
%
% Validates required fields, allowed enums, and creates output_root if needed.

% Read and parse JSON file
%
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
    raw = fileread(configPath);
    try
        cfg = jsondecode(raw);
    catch ME
        error('load_config:JSON', ...
            'Failed to parse JSON. Ensure strict JSON (no comments/trailing commas).\n%s', ...
            ME.message);
    end

    % Validate required io fields
    mustHave(cfg, 'io');
    mustHave(cfg.io, 'mode');
    mustHave(cfg.io, 'input_root');
    mustHave(cfg.io, 'file_glob');
    mustHave(cfg.io, 'output_root');
    mustHave(cfg.io, 'case_id');

    % Validate io.mode enum
    validModes = {'beads', 'synthetic', 'tirf'};
    assert(any(strcmpi(cfg.io.mode, validModes)), 'load_config:Mode', ...
        'Invalid io.mode="%s". Allowed: %s', cfg.io.mode, strjoin(validModes, ', '));

    % Normalize and validate paths
    cfg.io.input_root = char(cfg.io.input_root);
    cfg.io.output_root = char(cfg.io.output_root);
    assert(isfolder(cfg.io.input_root), 'load_config:InputRoot', ...
        'input_root not found: %s', cfg.io.input_root);
    if ~isfolder(cfg.io.output_root)
        mkdir(cfg.io.output_root);
    end

    % Set defaults for optional sections
    cfg = ensureDefaults_(cfg);
end

function mustHave(s, field)
    % MUSTHAVE Assert that a field exists in a structure
    assert(isfield(s, field), 'load_config:MissingField', ...
        'Missing required field: %s', field);
end


function cfg = ensureDefaults_(cfg)
    % ENSUREDEFAULTS_ Set default values for optional configuration sections

    % Preprocess section
    if ~isfield(cfg, 'preprocess') || ~isstruct(cfg.preprocess)
        cfg.preprocess = struct( ...
            'apply', true, ...
            'wiener', struct('apply', true, 'nhood', 3), ...
            'median', struct('apply', false, 'size', 3), ...
            'sharpen', struct('apply', false, 'amount', 0.6, 'radius', 1));
    end

    % Mask section
    if ~isfield(cfg, 'mask') || ~isstruct(cfg.mask)
        cfg.mask = struct( ...
            'method', 'global_otsu', ...
            'block', struct('size', 64, 'overlap', 8), ...
            'bradley', struct('window', 41, 't', 0.15), ...
            'morph', struct('close', 2, 'dilate', 1, 'open', 1));
    end

    % Validate mask.method enum
    validMask = {'global_otsu', 'block_otsu', 'bradley_adaptive'};
    assert(any(strcmpi(cfg.mask.method, validMask)), 'load_config:MaskMethod', ...
        'Invalid mask.method="%s". Allowed: %s', cfg.mask.method, strjoin(validMask, ', '));

    % Detect section
    if ~isfield(cfg, 'detect') || ~isstruct(cfg.detect)
        cfg.detect = struct( ...
            'min_area', 3, ...
            'max_area', 200, ...
            'min_intensity', 0, ...
            'subpixel', struct('method', 'gaussian', 'patch', 5));
    end

    % Track section
    if ~isfield(cfg, 'track') || ~isstruct(cfg.track)
        cfg.track = struct( ...
            'apply', false, ...
            'max_link_distance', 5, ...
            'gap_closing', 0);
    end

    % Write section
    if ~isfield(cfg, 'write') || ~isstruct(cfg.write)
        cfg.write = struct( ...
            'csv', true, ...
            'mat', struct('centroids', true, 'tracking', false), ...
            'overlays', true);
    end

    % Run section
    if ~isfield(cfg, 'run') || ~isstruct(cfg.run)
        cfg.run = struct('seed', 1234);
    end
end