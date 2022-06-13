function [img , bw] = noisy_image_preprocessor(img)

% Adjust data to span data range.
img = imadjust(img);

% Threshold image - adaptive threshold
bw = imbinarize(img, 'adaptive', 'Sensitivity', 0.570000, 'ForegroundPolarity', 'bright');

% Open mask with disk
radius = 3; decomposition = 0;
se = strel('disk', radius, decomposition);
bw = imopen(bw, se);

% Close mask with disk
radius = 3; decomposition = 0;
se = strel('disk', radius, decomposition);
bw = imclose(bw, se);

% Create masked image.
img(~bw) = 0;
end

