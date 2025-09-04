function [runDir, cfg] = run_case(configPath)
%RUN_CASE Top-level entry point for a single case (This is for taking a dry-run).
%   [runDir, cfg] = RUN_CASE(configPath)
%   - Loads strict JSON config
%   - Builds timestamped run directory under outputs/ folder
%   - Writes RUN_INFO.json (provenance + config echo)
%
% Usage:
%   run_case('configs_fullPath/beads_default.json');
%   run_case('configs_fullPath/synthetic_default.json');
%   run_case('configs_fullPath/tirf_default.json');
% 
% 
%  run_case('/Users/abhimanyudubey/MATLAB-Drive/CRAP/bio_math_model_images/TIRFM_v2_protocol/configs/beads_default.json')
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

    if nargin < 1 || ~ischar(configPath)
        error('run_case:BadInput', 'Provide a path to a strict JSON config file.');
    end
    if ~exist(configPath, 'file')
        error('run_case:ConfigNotFound', 'Config file not found: %s', configPath);
    end

    % 1) Load & validate config  <-- THIS INITIALIZES cfg
    cfg = load_config(configPath);

    % 2) Build run directory (timestamped)
    [runDir, runId] = build_run_dir(cfg);

    % 3) (Optional) Enumerate inputs now to catch path/pattern mistakes early
    try
        files = list_input_images(cfg);
        nFiles = numel(files);
    catch ME
        warning('run_case:ListInputsFailed', 'Could not list inputs: %s', ME.message);
        files = {};
        nFiles = NaN;
    end

    % 4) Write RUN_INFO.json (provenance)
    runInfo = struct();
    runInfo.generated_at = [ '__' , char(datetime('now' , 'Format', 'yyyy_MMM_dd_HH_mm_ss')) , '__' ] ;
    runInfo.host = getHostName_();
    runInfo.matlab.version = version;
    runInfo.matlab.release = version('-release');
    runInfo.io = cfg.io; %#ok<STRNU>
    runInfo.mask = cfg.mask;
    runInfo.preprocess = cfg.preprocess;
    runInfo.detect = cfg.detect;
    runInfo.track = cfg.track;
    runInfo.write = cfg.write;
    runInfo.run = cfg.run;
    runInfo.run_id = runId;
    runInfo.input_file_count = nFiles;

    try
        txt = jsonencode(runInfo, 'PrettyPrint', true);
    catch
        txt = jsonencode(runInfo); % fallback for older MATLAB
    end

    outPath = fullfile(runDir, 'RUN_INFO.json');
    fid = fopen(outPath, 'w');  assert(fid>0, 'run_case:IO', 'Cannot open %s for writing.', outPath);
    fwrite(fid, txt, 'char');  fclose(fid);

    % 5) Console summary
    fprintf('[TIRFM] Dry-run complete.\n');
    fprintf('  Mode      : %s\n', cfg.io.mode);
    fprintf('  Case ID   : %s\n', cfg.io.case_id);
    fprintf('  Inputs    : %s (glob: %s)\n', cfg.io.input_root, cfg.io.file_glob);
    fprintf('  Files     : %s\n', num2str(nFiles));
    fprintf('  Run dir   : %s\n', runDir);
    fprintf('  RUN_INFO  : %s\n', outPath);
end

function h = getHostName_()
    try
        if ispc, h = getenv('COMPUTERNAME'); else, h = getenv('HOSTNAME'); end
        if isempty(h), h = 'unknown-host'; end
    catch
        h = 'unknown-host';
    end
end
