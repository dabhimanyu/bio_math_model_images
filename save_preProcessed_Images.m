%%

clc ; 
clear ; 

% Locate The Image Files:
import_directory    =   '/Users/abhimanyudubey/Pictures/BIO MATH MODEL/export copy'     ; 
export_directory    =   '/Users/abhimanyudubey/Pictures/BIO MATH MODEL/Matlab_Export/001__PreProcessed_Images' ; 
[~ , file_names]    =   Import_all_files_in_a_folder('.tif' , import_directory) ;    i = 2   ; 

tic
for i = 1 : numel(file_names)
    img                         =       imadjust(imread(fullfile(import_directory , file_names{i})))    ; 
    [~ , img2]                   =       bio_watershed_segmentation(img)     ; 
    imwrite(img2 , fullfile(export_directory , sprintf('Pre_Processed_Img_%4.4i_.png' , i-1) ) ) 
end
toc

%%