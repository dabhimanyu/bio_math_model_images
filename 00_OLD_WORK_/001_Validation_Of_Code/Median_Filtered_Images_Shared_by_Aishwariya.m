%% Artificial Image Timing:
close all ; 
clear ; 
clc ; 

filepath = '/Users/abhimanyudubey/Downloads/gray 0.720 median filter added' ; 
[~ , filenames] = Import_all_files_in_a_folder('tif' , filepath) ; 
f_len = length(filenames) ; i = 1 ; 

timing_milisec                  =       zeros(length(filenames) , 1) ; 
num_islands                     =       timing_milisec ; 

for i = 1 : f_len
    tic

    img                          =       imadjust( imread( (fullfile(filepath , filenames{i})) ) )  ;
    img                          =       wiener2(img , 3*[1,1] ) ;
    [img , BW]                   =       cell_image_BW_preprocessor_4_BEADS(img , false , 0.00 , 3 ) ;
    [img , BW , CC]              =       bio_watershed_segmentation_4_BEADS(img , BW , 10 , 900 , 2.0)        ;

num_islands(i)                   =       CC.NumObjects ;
timing_milisec(i)                =       1e3 * toc ;
end




%%