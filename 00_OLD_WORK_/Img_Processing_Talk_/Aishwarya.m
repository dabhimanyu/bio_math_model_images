%% Centroid Detection:

% Clear Workspace is good for our health :)
clear ; 
% Clear Screen
clc ; 
% Close all figures
close all ; 

% Import Directories:

% Path For Beads Image:
beads_filepath = ['/Users/abhimanyudubey/Pictures' ...
    '/BIO MATH MODEL/0009_0016_beads_images_256X256'] ; 

% Path For artificially Generated Images:
artificial_Img_FilePath = ['/Users/abhimanyudubey/' ...
    'Pictures/BIO MATH MODEL/gray_0_pt_720_median_filter_added_'] ; 


% Path For Artificially Created movie to check the working of Tracker:
real_cell_img_filepath = ['/Users/abhimanyudubey/' ...
    'Pictures/BIO MATH MODEL/001_Real_Img_via_' ...
    'reg_max_/008_Translate_and_Track_'] ; 

% Export Directories:

% Path to Store Artificially generated Images:
artificial_img_exp_dir = ...
    ['/Users/abhimanyudubey/Pictures/BIO MATH MODEL/gray_0_pt_' ...
    '720_median_filter_added_/Artificial_Img_Export_'] ; 

% Path To Export Beads:
beads_img_exp_dir = ['/Users/abhimanyudubey/' ...
    'Pictures/BIO MATH MODEL/0009_0016_beads_' ...
    'images_256X256/Beads_Result_Export'] ; 

% Path To Export Real Cell Images:
real_cell_img_exp_dir = ['/Users/abhimanyudubey/Pictures/BIO ' ...
    'MATH MODEL/001_Real_Img_via_reg_max_/004_' ...
    'Matlab_Edited_Images_'] ; 

% Path To Export Tracking Data:
real_cell_img_tracker_export_dir = ['/Users/abhimanyudubey/' ...
    'Pictures/BIO MATH MODEL/001_Real_Img_via_reg_' ...
    'max_/005_Matlab_Tracker_Export_'] ; 

clearvars -except -regexp real* ; 

[fileNames , onlyFilenames] = Import_all_files_in_a_folder(...
    '.tif' , real_cell_img_filepath )  ; 


%% Visualize The Centroids:

i = 1 ; 
img1 = imread(fullfile(real_cell_img_filepath , onlyFilenames{i})) ; 
figure(1) ; imshow(imresize(img1 , 4) , []) ; 

[img , BW , CC] = BW_REAL_cell_img_via_reg_max_(img1) ; 
figure(2) ; imshow(imresize(img , 4) , []) ; 

im_overlay = imoverlay(img1 , BW , 'red')  ; 
xIdx = 35:119 ; 
yIdx = 67:171 ; 

I1 = imadjust(imresize(img1(xIdx , yIdx) , 8 )) ; 
I2 = imresize( im_overlay(xIdx , yIdx) , 8 ) ; 
close all ; 
figure(1) ; clf ; 
imshowpair( I1 , I2 , 'montage') ; 

%%

clearvars -except -regexp real* fileNames  onlyFilenames fileNames; 

temp                            =       500 ; 

% Create a cell array which contains temp number of cells
centroid_data                   =       cell( numel(fileNames) , 1)  ; 
mean_intensity_data                  =       cell( numel(fileNames) , 1)  ; 

% Fill each cell with a [ temp x 2 ] matrix to store x-y coordinates of
% "temp" number of centroids. initializing each individual cell like this
% helps to parallelize the code subsequently.  
centroid_data                   =       cellfun(@(x) zeros(temp , 2) , ...
                                        centroid_data , 'UniformOutput', 0 ) ; 

mean_intensity_data                  =       cellfun(@(x) zeros(temp , 1) , ...
                                        mean_intensity_data , 'UniformOutput', 0 ) ; 

% Check If a parallel pool is alrady running:
if isempty(gcp("nocreate"))
    % If Not then Start a Parallel Pool
    parpool ; 
end


% Initialize "i" for quick individual checks of for loop:
i = 1  ; 

tic 
parfor i = 1 : numel(fileNames)

%   Read 'i_th' Image
    img                 =   imread(fullfile(real_cell_img_filepath , onlyFilenames{i})) ; 

%   Save A Copy Of Original Image For Quick Comparison  
    im_original         =   img ;    

    [img , BW , CC]     =   BW_REAL_cell_img_via_reg_max_(img) ; 
    
%    Copy The Centroid Data into the variable created earlier:
    centroid_data{i}         =   CC.centroid             ;
    mean_intensity_data{i}   =   CC.I_mean               ; 
end
t(1) = toc % t(1) = Total time taken by the loopp to go over all the images


% DONE, Be Happy....!!  :-)

%% Tracking:

% Create An Input File for the tracker, and send it through the tracker
max_disp                     =      4.9   ; 
num_of_frames_2_skip         =      1     ;

tic
tracking_output              =      track( make_tracking_input_file( ...
                                    centroid_data , mean_intensity_data ) , max_disp * 1 ) ; 

% Calculate Delta_X (dx) and Delta_Y (dy) from the tracking output
[ xyuvt_data , T , p_dist]   =      calculate_dx_and_dy_from_tracking_output_002(...
    tracking_output , num_of_frames_2_skip) ; 
t(2) = toc
%%



















