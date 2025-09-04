function [runDir, runId] = build_run_dir(cfg)
    % BUILD_RUN_DIR Create a timestamped run directory under
    % the folder outputs/.
    % [runDir, runId] = build_run_dir(cfg)
    %
    % Output path: <output_root>/<run_id__yyyy_MMM_dd_HH_mm_ss>
    % 
    % 
    % % 
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
    %% 
        
    % Generate timestamp and run ID
    ts = char(datetime('now', 'Format', 'yyyy_MMM_dd_HH_mm_ss'));
    
    % SANITIZE_() Replace non-alphanumeric characters (except _ and -) with underscores
    % by making use of regular expressions
    safeCase = sanitize_(cfg.io.case_id); % 
    runId = sprintf('%s__%s__%s', lower(cfg.io.mode), safeCase, ts);

    % Create run directory
    runDir = fullfile(cfg.io.output_root, runId);
    if ~exist(runDir, 'dir')
        ok = mkdir(runDir);
        assert(ok, 'build_run_dir:IO', 'Failed to create run directory: %s', runDir);
    end
end

function s = sanitize_(txt)
    % SANITIZE_ Replace non-alphanumeric characters (except _ and -) with underscores
    s = regexprep(char(txt), '[^a-zA-Z0-9_-]', '_');
end