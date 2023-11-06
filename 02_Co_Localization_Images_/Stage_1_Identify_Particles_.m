%% Import RGB channels and Identify The Features Of Interest:
% Only Red and Green Channels contains features of Interest:
% Blue channel is empty
clear ; 
close all ; 
clc ; 

rgb_filepath = ['/Users/' ...
    'abhimanyudubey/Pictures' ...
    '/Aishwarya_Senior_Colocalisation_/' ...
    '1790/0_A_RGB'] ; 

[fileNames , onlyFileNames] = ...
    Import_all_files_in_a_folder('.tif' , rgb_filepath) ; 

i = 1 ; 


rgb_original = imread(fullfile(rgb_filepath , onlyFileNames{i})) ; 

% Extract Channels:
r = rgb_original(: , : , 1 ) ; 
g = rgb_original(: , : , 2 ) ; 

% Adjust Contrast:
r = imadjust(r) ; 
g = imadjust(g) ; 

mean(r(:)) 
mean(g(:))
% figure ; imshow(r);  
% figure ; imshow(g) ; 

% Wiener Filter:
wFiltSize_r = 3 ; 
wFiltSize_g = 3 ; 
r = wiener2(r , wFiltSize_r) ; g = wiener2(g , wFiltSize_g) ; 
imshow([r,g] , [])

% Gaussian Filter:
gaussFilt_r = 3 ; 
gaussFilt_g = 3 ; 


pj = 3 ; 






















