%% New Main Cell Image Processing Code:

% NOTE: Sequence Of Running Codes:
% Main Folder (i.e. "bio_math_model_images") contains only 3 mFiles

% Step 1. 
% First Of all we'll run "Main Cell Image Code". 
% It'll identify the individual cells/beads [ cute little, 
% small islands, as I call them :-) ] in the image, calculate their
% centroid and export this "centroid_data" as a ".mat" File
% Step 2.
% run "main tracking code"
% It'll import the centroid data which were exported earlier in Step 1 and 
% Do the following: 
%     (a) Remove NearBy Particles ( If Toggle is Switched On )
%     (b) Make Tracking Input File, and 
%     (c) Track Your particles:
%     (d) Calculate Pixel Displacement:
%  NOTE: Currently we have switched off the toggle switch for
%  near_by_particle_removal_macro upon Prof. Nikhil's Suggestion
%  Step 3.
% Run bio_science_plotter to do the necessary plotting
% This part of the code frequently changes depending on how results needs
% to be visualized

% Clear Workspace is good for our health :)
clear ; 
% Clear Screen
clc ; 
% Close all figures
close all ; 


% Real Cell Img Directory:
real_cell_img_filepath = ['/Users/' ...
    'abhimanyudubey/Pictures/' ...
    'BIO MATH MODEL/002_NEW_Exp movies/' ...
    '001_FIRST_TRIAL_'] ; 

% Export Directories:

% Path To Export Real Cell Images:
real_cell_img_exp_dir = ['/Users/' ...
    'abhimanyudubey/Pictures/' ...
    'BIO MATH MODEL/002_NEW_Exp movies/' ...
    '001_First_Trial_Export_']; 

% Path To Export Tracking Data:
real_cell_img_tracker_export_dir = ['/Users/' ...
    'abhimanyudubey/Pictures/BIO MATH MODEL/' ...
    '002_NEW_Exp movies/' ...
    '001_First_Trial_zTracking_Export_'] ; 

% I'VE created a single file for beads image, artificial image, and for
% real cell image: Makes it easier for me to keep track of all the changes
% that I made in either one of them via "GIT".

%   1. Code For Processing Artificial Cell Images:
% % 2. Code For Processing Of Beads:
%   3. Code For Processing Real Cell Images:
%      Processing Real Cell Images:

% Clear All Variables Except those  variables which are associated with real cell Images:
clearvars -except -regexp real* ; 
% Import "FileNames" and "FullFileNames" of all the png (or tiff) files in
% the Import Directory
[fileNames , onlyFilenames] = Import_all_files_in_a_folder(...
    '.tif' , real_cell_img_filepath )  ; 
% Clear All Variables Except those  variables which are associated with
% real cell Images and the two variables created above
clearvars -except -regexp real* fileNames  onlyFilenames fileNames; 

% Preallocating Memory For Cell Arrays:

% Assuming that Each Image Contains a Maximum of 500 Centroids. Typically
% this number lies b/t 70 to 150. 
% temp = temporary variable for maximum number of centroids
temp                            =       500 ; 

% Create a cell array which contains temp number of cells
centroid_data                   =       cell( numel(fileNames) , 1)  ; 
mean_intensity_data             =       cell( numel(fileNames) , 1)  ; 

% Fill each cell with a [ temp x 2 ] matrix to store x-y coordinates of
% "temp" number of centroids. initializing each individual cell like this
% helps to parallelize the code subsequently.  
centroid_data                   =       cellfun(@(x) zeros(temp , 2) , ...
                                        centroid_data , 'UniformOutput', 0 ) ; 

mean_intensity_data                  =       cellfun(@(x) zeros(temp , 1) , ...
                                        mean_intensity_data , 'UniformOutput', 0 ) ; 

i = 1  ;

%
% Check If a parallel pool is alrady running:
if isempty(gcp("nocreate"))
    % If Not then Start a Parallel Pool
    parpool ; 
end

% Initialize "i" for quick individual checks of for loop:
% 
%
% Main Parallel For Loop Over all the Image Files starts here:
%
tic 
parfor i = 1 : numel(fileNames)

%%   Read 'i_th' Image

    img                 =   imread(fullfile(real_cell_img_filepath , onlyFilenames{i})) ; 

%   Save A Copy Of Original Image For Quick Comparison  
    im_original         =   img ;    

%   Call the function to do all the relevant image processing and return
%   the following three variables
%       1. img: Final Gray-Image After Image Processing
%       2. BW:  Binarized Image showing the location of centroids
%               identified by the regional maxima algorithm
%       3. CC:  a.k.a connected components, is a structure containg 5 elements. 
%           (1) Connectivity: Connectivity Index used for 
%                               identification of islands
%           (2) ImageSize   : Size Of the Image
%           (3) NumObjects  : Number of islands identified in the image
%           (4) PixelIdxList: Linear Pixel Index List for the pixels of
%                               each island
%           (5) centroid    : X-Y Coordinates of all CC.NumObjects islands 
    [img , BW , CC]     =   cell_Tracking_and_Intensity_Image_Processor_(img) ; 
    
%    Copy The Centroid Data into the variable created earlier:
    centroid_data{i}         =   CC.centroid             ;
    mean_intensity_data{i}   =   CC.I_mean               ; 

%
end
t(1) = toc % t(1) = Total time taken by the loopp to go over all the images

% Export the relevant variables into your HardDisk:
save(fullfile(real_cell_img_exp_dir , '001_Cells_Centroid_Data_') , ...
    "real_cell_img_exp_dir" , "onlyFilenames" , "centroid_data" , ...
    "mean_intensity_data" , "fileNames") ; 

% DONE, Be Happy....!!  :-)

clearvars -except real_cell_img_tracker_export_dir onlyFilenames centroid_data ...
    mean_intensity_data fileNames ; 
%% Export Centroid Data in a Text File:
% % xVal = cellfun(@(x) x(: , 1) , centro)
% % 
% % data2export = table()

%%%%%%%% Figure: DO NOT DELETE ||-_-||  %%%%%%%%%%%
% % i                   =   1 ; 
% % img                 =   imread(fullfile(real_cell_img_filepath , onlyFilenames{i})) ; 
% % [img , BW , CC]     =   cell_Tracking_and_Intensity_Image_Processor_(img) ; 
% % 
% % fig = figure(1) ; % clf ; 
% % imshow(img , []) ; hold on ; 
% % plot(centroid_data{i}(: , 1) , centroid_data{i}(: , 2) , '.r' , 'MarkerSize', 10) ; 
% % hold off ; 

%%
