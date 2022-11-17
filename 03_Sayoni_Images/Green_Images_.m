%%

clear ; 
clc ; 
close all ; 

% Set A:
filepath_A = ['/Users/abhimanyudubey/' ...
    'Pictures/z_Image_Processing_Talk_/' ...
    'Sayoni_MATLAB IP samples/Green fluorescence/SetA'] ; 

filepath_B = ['/Users/abhimanyudubey/' ...
    'Pictures/z_Image_Processing_Talk_/' ...
    'Sayoni_MATLAB IP samples/' ...
    'Green fluorescence/SetB'] ; 

[~ , onlyFilenames_A] = Import_all_files_in_a_folder('tif' , filepath_A) ; 
[~ , onlyFilenames_B] = Import_all_files_in_a_folder('tif' , filepath_B) ; 


















