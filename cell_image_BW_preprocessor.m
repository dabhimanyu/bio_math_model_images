function [img , BW] = cell_image_BW_preprocessor(img , adaptive_thresh_toggle , BW_sensitivity  , opening_radius , closing_radius)
%
%   %% DUDE you need to write this function's documentation and help here.
%   I know it's a drag, but it'll help out other people who'll use your
%   code. :-)
%
% NOTE: Code will use rectangular opening with a structure element of
%       dimension = [2 2]. In case trid element is provided, and it's a
%       single element vector, then and only then a circular opening would
%       be used with the size of the structuring element which was
%       provided. Otherwise once again rectangular opening would be used.
% NOTE: Using Figures from 100 to 150
%% Default Arguments:
if nargin == 1
    adaptive_thresh_toggle  =       false    ;
    BW_sensitivity          =       0.000000 ; 
    rect_opening_toggle     =       true     ; 
    opening_radius          =       [2 , 2]        ; % In Pixels
    closing_radius          =       1        ; % In Pixels

elseif nargin == 2
    rect_opening_toggle     =       true     ;
    opening_radius          =       [2 ,2]        ; % In Pixels
    closing_radius          =       1        ; % In Pixels

elseif nargin == 3
        if length(opening_radius)   ==  1    
            rect_opening_toggle     =   false ; 
        elseif length(opening_radius) == 2
            rect_opening_toggle     =   true ; 
        else 
            fprintf('\n\n\n\t\t Wrong Input: length(opening_radius) can be either 1 or 2.\n\n\n') ; 
            return
        end
    closing_radius      =       1        ; % In Pixels

elseif (nargin < 1) || (nargin > 4)
    fprintf([' \n\n\t\t At-least One, and At-MAX, Four Inputs are Allowed.  \n\n\t\t Dumbass ||-_-|| \n\n\t\t Check your Inputs First \n\n\t\t' ...
        ' Before distrubing me from my sleep. \n\n\n'] ) ; 
    return
end

    I2 = 400 : 510 ; 
    I1 = 350 : 400 ; 

% Adjust data to span data range.
img = imadjust(img);

if ~logical(adaptive_thresh_toggle)
    % Use Global Binarization If Adaptive Thresh is False:
    BW = imbinarize(img) ; 
else
    % Threshold image - Adaptive Threshold
    BW = imbinarize(img, 'adaptive', 'Sensitivity', ...
         BW_sensitivity , 'ForegroundPolarity', 'bright');
end
% % 
% % figure(100) ; clf ; imshow(BW(I1 , I2) , []) ; 
% % title('\fontsize{20}Step 1: Thresholded Image') ; 

% Use Disk Opening if length(opening_radius) = 1
% Use Rectangular Opening if length(opening_radius) = 2
% Open mask with rectangle
if rect_opening_toggle
    dimensions = opening_radius;
    se = strel('rectangle', dimensions);
    BW = imopen(BW, se);
elseif ~rect_opening_toggle
    decomposition = 0; % For Parallelization: 
    se = strel('disk', opening_radius, decomposition);
    BW = imopen(BW, se);
end

% % figure(101) ; clf ; imshow(BW(I1 , I2) , []) ; 
% % title('\fontsize{20}Step 2: Morphological Opening') ; 

% Clear border pixels:
BW = imclearborder(BW);

% Fill Holes Using Morphological Reconstruction:
%  Soille, P., Morphological Image Analysis: Principles 
%   and Applications, Springer-Verlag, 1999, pp. 173–174.
BW = imfill(BW , 'holes') ; 

% % figure(102) ; clf ; imshow(BW(I1 , I2) , []) ; 
% % title('\fontsize{20}Step 3: Filling Of Holes In The Mask') ; 
% % Close mask with disk
% closing_radius = 1;
% decomposition = 0;
% se = strel('disk', closing_radius, decomposition);
% BW = imclose(BW, se);
pj = closing_radius ; % For breakpoint
% Create masked image.
img(~BW) = 0;
end

