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

%
% Clear Workspace is good for our health :)
clear ; 
% Clear Screen
clc ; 
% Close all figures
% close all ; 

% Import Directories:

% Path For Beads Image:
beads_filepath = ['/Users/abhimanyudubey/Pictures' ...
    '/BIO MATH MODEL/0009_0016_beads_images_256X256'] ; 

% Path For artificially Generated Images:
artificial_Img_FilePath = ['/Users/abhimanyudubey/' ...
    'Pictures/BIO MATH MODEL/gray_0_pt_720_median_filter_added_'] ; 

% % % 9069 Path 
% % % For "9069" Real Cell Images :

real_cell_img_filepath = ['/Users/abhimanyudubey' ...
    '/Pictures/BIO MATH MODEL/001_Real_Img_' ...
    'via_reg_max_/002_Raw_Images_From_Video_'] ; 

% % 9053 FilePath:
% Path For "9053" Real Cell Images :
% real_cell_img_filepath = ['/Users/abhimanyudubey' ...
%     '/Pictures/BIO MATH MODEL/001_Real_Img_via_' ...
%     'reg_max_/006_Raw_Img_From_9053_Video_'] ; 

% % 8 Images from Different Sets shared later on:
% Path For 8 Images which was later shared with me:
% real_cell_img_filepath = ['/Users/abhimanyudubey/' ...
%     'Pictures/BIO MATH MODEL/001_Real_Img_' ...
%     'via_reg_max_/007_8_Img_Shared_later_'] ; 

% % Path For Artificially Created movie to check the working of Tracker:
% real_cell_img_filepath = ['/Users/abhimanyudubey/' ...
%     'Pictures/BIO MATH MODEL/001_Real_Img_via_' ...
%     'reg_max_/008_Translate_and_Track_'] ; 

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

% I'VE created a single file for beads image, artificial image, and for
% real cell image: Makes it easier for me to keep track of all the changes
% that I made in either one of them via "GIT".

%%   1. Code For Processing Artificial Cell Images:

% % Processing Of Artificial Images:
% % clearvars -except -regexp artificial* ; 
% % % Import The Images:
% % [fileNames , onlyFilenames] = Import_all_files_in_a_folder(...
% %     '.tif' , artificial_Img_FilePath) ; 
% % 
% % i = 1   ;
% % 
% % for i = 1 : length(onlyFilenames)
% %     img = imread(fullfile(artificial_Img_FilePath , onlyFilenames{i})) ; 
% %     im_original = img ; 
% %     [ img  ,  BW  , CC ]    =   ...
% %         BW_artificial_img_via_reg_max_(img) ; 
% % 
% %     % Plot The Images:
% %     fig = figure(1) ; clf ;  imshow(im_original) ; hold on ; 
% %     plot(CC.centroid(: , 1) , CC.centroid(: , 2) , '.' ,...
% %         'MarkerSize', 18 , 'Color', 'r' , 'LineWidth', 2) ; 
% %     hold off ; 
% %     title(sprintf('Showing %i Detected Cells' ,...
% %         CC.NumObjects) , 'FontSize',22)
% %     exportgraphics(fig , ...
% %         fullfile(artificial_img_exp_dir , onlyFilenames{i}) ,...
% %         'resolution' , 300 , 'ContentType' , 'image') ; 
% % end


%% Processing Of Beads:

% % 2. Code For Processing Of Beads:
%%% Processing Beads:

clearvars -except -regexp beads* ; 
[fileNames , onlyFilenames] = Import_all_files_in_a_folder(...
    '.tif' , beads_filepath) ; 
i = 1 ; 

%%
for i = 1 : length(onlyFilenames)

    %%
    img             =   imread(fullfile(beads_filepath , onlyFilenames{i})) ; 
    im_original     =   img ; 
    [img , BW , CC] =   BW_beads_via_reg_max_(img) ; 


%%%%%%%%%% SUPERIMPOSE CENTROID ON IMAGE
    % Plot The Images:
    % NOTE: Keep the amount of padding same both Inside the FcN and outside
    % the function:
    img_padded = padarray(im_original , [3,3] , 0) ; 
    fig = figure(1) ; imshow(img_padded) ; hold on ; 
    plot(CC.centroid(: , 1) , CC.centroid(: , 2) , '.' ,...
        'MarkerSize', 10 , 'Color', 'r') ; hold off ; 
    title(sprintf('Showing %i Detected Cells' ,...
        CC.NumObjects) , 'FontSize',22) ; 
    exportgraphics(fig , ...
        fullfile(beads_img_exp_dir , ['a_' , onlyFilenames{i}]) ,...
        'resolution' , 300 , 'ContentType' , 'image') ; 
    %%
end


%%   3. Code For Processing Real Cell Images:

% Processing Real Cell Images:

% % % % Clear All Variables Except those  variables which are associated with real cell Images:
clearvars -except -regexp real* ; 
% Import "FileNames" and "FullFileNames" of all the png (or tiff) files in
% the Import Directory
[fileNames , onlyFilenames] = Import_all_files_in_a_folder(...
    '.tif' , real_cell_img_filepath )  ; 

if isempty(onlyFilenames)
    [fileNames , onlyFilenames] = Import_all_files_in_a_folder(...
    '.png' , real_cell_img_filepath )  ;
end

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

mean_intensity_data             =       cellfun(@(x) zeros(temp , 1) , ...
                                        mean_intensity_data , 'UniformOutput', 0 ) ; 
%
% Check If a parallel pool is alrady running:
parallel_run_toggle = false ; 

    if ( isempty(gcp("nocreate")) && parallel_run_toggle )
        % If Not then Start a Parallel Pool
        parpool ; 
    end
%%
% Initialize "i" for quick individual checks of for loop:
i = 1  ; 
%
% Main Parallel For Loop Over all the Image Files starts here:

tic 
parfor i = 1 : numel(fileNames)

%   Read 'i_th' Image
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
    [img , BW , CC]     =   BW_REAL_cell_img_via_reg_max_(img) ; 
    
%    Copy The Centroid Data into the variable created earlier:
    centroid_data{i}    =   CC.centroid             ;
    mean_intensity_data{i}   =   CC.I_mean               ; 
end
t(1) = toc % t(1) = Total time taken by the loopp to go over all the images

% Export the relevant variables into your HardDisk:
save(fullfile(real_cell_img_exp_dir , '002_Cells_Centroid_Data_for_9053') , ...
    "real_cell_img_exp_dir" , "onlyFilenames" , "centroid_data" , ...
    "mean_intensity_data" ) ; 

% DONE, Be Happy....!!  :-)

%% Export Centroid Data in a Text File:
% % xVal = cellfun(@(x) x(: , 1) , centro)
% % 
% % data2export = table()

%%
