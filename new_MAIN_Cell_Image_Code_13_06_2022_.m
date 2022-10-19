%% New Main Cell Image Processing Code:

clear ; 
clc ; 
close all ; 

% Import Directories:
beads_filepath = ['/Users/abhimanyudubey/Pictures' ...
    '/BIO MATH MODEL/0009_0016_beads_images_256X256'] ; 

artificial_Img_FilePath = ['/Users/abhimanyudubey/' ...
    'Pictures/BIO MATH MODEL/gray_0_pt_720_median_filter_added_'] ; 

% %  9069 Path
% real_cell_img_filepath = ['/Users/abhimanyudubey' ...
%     '/Pictures/BIO MATH MODEL/001_Real_Img_' ...
%     'via_reg_max_/002_Raw_Images_From_Video_'] ; 

% % 9053 FilePath:
% real_cell_img_filepath = ['/Users/abhimanyudubey' ...
%     '/Pictures/BIO MATH MODEL/001_Real_Img_via_' ...
%     'reg_max_/006_Raw_Img_From_9053_Video_'] ; 

% % 8 Images from Different Sets shared later on:
% real_cell_img_filepath = ['/Users/abhimanyudubey/' ...
%     'Pictures/BIO MATH MODEL/001_Real_Img_' ...
%     'via_reg_max_/007_8_Img_Shared_later_'] ; 

real_cell_img_filepath = ['/Users/abhimanyudubey/' ...
    'Pictures/BIO MATH MODEL/001_Real_Img_via_' ...
    'reg_max_/008_Translate_and_Track_'] ; 

% Export Directories:
artificial_img_exp_dir = ...
    ['/Users/abhimanyudubey/Pictures/BIO MATH MODEL/gray_0_pt_' ...
    '720_median_filter_added_/Artificial_Img_Export_'] ; 

beads_img_exp_dir = ['/Users/abhimanyudubey/' ...
    'Pictures/BIO MATH MODEL/0009_0016_beads_' ...
    'images_256X256/Beads_Result_Export'] ; 

real_cell_img_exp_dir = ['/Users/abhimanyudubey/Pictures/BIO ' ...
    'MATH MODEL/001_Real_Img_via_reg_max_/004_' ...
    'Matlab_Edited_Images_'] ; 

real_cell_img_tracker_export_dir = ['/Users/abhimanyudubey/' ...
    'Pictures/BIO MATH MODEL/001_Real_Img_via_reg_' ...
    'max_/005_Matlab_Tracker_Export_'] ; 

% Processing Of Artificial Images:

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

% Processing Beads:

% % clearvars -except -regexp beads* ; 
% % [fileNames , onlyFilenames] = Import_all_files_in_a_folder(...
% %     '.tif' , beads_filepath) ; 
% % 
% % for i = 1 : length(onlyFilenames)
% %     img             =   imread(fullfile(beads_filepath , onlyFilenames{i})) ; 
% %     im_original     =   img ; 
% %     [img , BW , CC] =   BW_beads_via_reg_max_(img) ; 
% %     
% %     % % % Plot The Images:
% %     fig = figure(1) ; imshow(im_original) ; hold on ; 
% %     plot(CC.centroid(: , 1) , CC.centroid(: , 2) , '.' ,...
% %         'MarkerSize', 10 , 'Color', 'r') ; hold off ; 
% %     title(sprintf('Showing %i Detected Cells' ,...
% %         CC.NumObjects) , 'FontSize',22)
% %     exportgraphics(fig , ...
% %         fullfile(beads_img_exp_dir , onlyFilenames{i}) ,...
% %         'resolution' , 300 , 'ContentType' , 'image') ; 
% % end
% % 

% Processing Real Cell Images:

clearvars -except -regexp real* ; 
[fileNames , onlyFilenames] = Import_all_files_in_a_folder(...
    '.png' , real_cell_img_filepath )  ; 
clearvars -except -regexp real* fileNames  onlyFilenames ; 

% Preallocating Memory For Dynamic Cell Array:
temp                            =       500 ; 
centroid_data                   =       cell( numel(fileNames) , 1)  ; 
centroid_data                   =       cellfun(@(x) zeros(temp , 2) , ...
                                        centroid_data , 'UniformOutput', 0 ) ; 

% Check If a parallel pool is alrady running:
if isempty(gcp("nocreate"))
    % If Not then Start a Parallel Pool
    parpool ; 
end

i = 1  ; 

% Main Parallel For Loop Over all the Image Files starts here:

tic
parfor i = 1 : numel(fileNames)
    img                 =   imread(fullfile(real_cell_img_filepath , onlyFilenames{i})) ; 
    im_original         =   img ;    
    [img , BW , CC]     =   BW_REAL_cell_img_via_reg_max_(img) ; 
    centroid_data{i}    =   CC.centroid             ;
end
t(1) = toc

save(fullfile(real_cell_img_exp_dir , '002_Cells_Centroid_Data_for_9053') , ...
    "real_cell_img_exp_dir" , "onlyFilenames" , "centroid_data"); 


%% Export Centroid Data in a Text File:
% % xVal = cellfun(@(x) x(: , 1) , centro)
% % 
% % data2export = table()



%%
