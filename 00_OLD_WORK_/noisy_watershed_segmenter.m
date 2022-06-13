function [ img , BW , CC ] = noisy_watershed_segmenter( img , min_size , max_size )

% Binarize The Image and Remove noise:
[img , BW] = noisy_image_preprocessor(img) ; 

% 