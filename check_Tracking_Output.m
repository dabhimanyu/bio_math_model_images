%% Plot The Results Of Tracker Function

% close all ; 
clear ; 
clc ; 
load('Relevant_Bio_Math_Tracking_Data.mat') ; 
load('Tracker_Output.mat') ; 
import_directory    =   '/Users/abhimanyudubey/Pictures/BIO MATH MODEL/export copy'     ; 
export_directory    =   '/Users/abhimanyudubey/Pictures/BIO MATH MODEL/Matlab_Export'   ; 
[~ , file_names] = Import_all_files_in_a_folder('.tif' , import_directory) ;    i = 2   ; 


for i = 1 : 20
    img = imadjust(imread(fullfile(import_directory , file_names{i}))) ; 


    xyt_data = tracking_output( tracking_output(: , 3) == i , [1 , 2 , 4] ) ; 
    pj = 1 : 100 ; 
    particle_idx_img = insertText(img , xyt_data(pj , 1:2) , xyt_data(pj , end) ...
        , 'AnchorPoint','Center' , 'FontSize', 12 , 'textcolor' , 'red' , ...
        'BoxOpacity', 0.2) ; 
    fig = figure(3) ; clf ; 
    particle_idx_img = imresize(particle_idx_img , 1.5) ; 
    imshow(particle_idx_img) ; 
    imwrite(particle_idx_img , fullfile(export_directory , sprintf('Image__Number__%4.4i_.png' , i-1) ) )
end
%%

























