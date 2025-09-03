function files = list_input_images(cfg)
    % LIST_INPUT_IMAGES Resolve input image files according to cfg.io.*
    % files = list_input_images(cfg)
    %
    % 
    % This function Supports single-image cases 
    % and stacks via glob pattern in cfg.io.file_glob.
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

    % Extract and normalize input root and glob pattern
    root = char(cfg.io.input_root);
    glob = char(cfg.io.file_glob);

    % List files matching the glob pattern
    d = dir(fullfile(root, glob));
    d = d(~[d.isdir]); % Keep only files, exclude directories

    % Sort files by name (zero-padded names sort numerically)
    [~, idx] = sort({d.name});
    d = d(idx);

    % Construct full file paths
    files = fullfile(root, {d.name});

    % Warn if no files are found
    if isempty(files)
        warning('list_input_images:NoFiles', ...
            'No files matched %s under %s', glob, root);
    end
end