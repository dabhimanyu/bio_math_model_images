%% Plot The Results Of Tracker Function

% close all ; 
clear ; 
clc ; 
load('Relevant_Bio_Math_Tracking_Data.mat') ; 
load('Tracker_Output.mat') ; 
import_directory    =   '/Users/abhimanyudubey/Pictures/BIO MATH MODEL/Matlab_Export/001__PreProcessed_Images' ;  
export_directory    =   '/Users/abhimanyudubey/Pictures/BIO MATH MODEL/Matlab_Export/002__Tracking_Images'     ;
[~ , file_names] = Import_all_files_in_a_folder('.png' , import_directory) ;    i = 2   ; 

pj = 1 : 1 : 100 ; 

for i = 1 : numel(file_names)
    img = imadjust( uint8(imread(fullfile(import_directory , file_names{i})) ) ); 
    xyt_data = tracking_output( tracking_output(: , 3) == i , [1 , 2 , 4] ) ; 

    particle_idx_img = insertText(img , xyt_data(pj , 1:2) , xyt_data(pj , end) ...
        , 'AnchorPoint','Center' , 'FontSize', 10 , 'textcolor' , 'red' , ...
        'BoxOpacity', 0.2) ;
    particle_idx_img = imresize(particle_idx_img , 2.5) ; 
    imwrite(particle_idx_img , fullfile(export_directory , sprintf('Image__Number__%4.4i_.png' , i-1) ) )
end
%%


























