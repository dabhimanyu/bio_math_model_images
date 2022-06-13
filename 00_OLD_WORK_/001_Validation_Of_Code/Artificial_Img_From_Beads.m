%% Artificial Image From Beads:
clear ; clc ; 
close all ; 

filepath = '/Users/abhimanyudubey/Pictures/BIO MATH MODEL/export copy' ; 
filenames = Import_all_files_in_a_folder('.tif' , filepath) ; 

im_original = imread(filenames{1}) ; 
imshow(imresize(im_original , 4) , [] ) ; 

temp_img = imresize(im_original , 5 , "bicubic") ; 
imshow(temp_img) ; 

% imwrite(temp_img , 'beads_img_00000.tif' , 'tif') ; 

% x = 2104 ;  y = 1918 ; w = 27 ; h = 31
%%
img = temp_img(1918 : 1918+31 , 2104: 2104 + 27) ; 
img = imresize(img , 0.4) ; 
imshow(imadjust(img)) ; 

img = imadjust(rescale(repmat(img , [21 , 21]))) ; 
imshow(img) ; 
% imwrite(img , 'Beads_NoiseLess_Img_1.tif' , 'tif')
%
%
% Adding Noise:

% Black Image:
noise_img_black = imadjust(rgb2gray(imread('/Users/abhimanyudubey/Pictures/BIO MATH MODEL/Img_4_Noise/Black_Img.JPG'))) ; 
noise_img_gray  = imadjust(rgb2gray(imread('/Users/abhimanyudubey/Pictures/BIO MATH MODEL/Img_4_Noise/Grey_Img.TIF' ))) ; 

I1 = 50 : (50+size(img , 1) - 1) ; % Default: 50 : (50+size(bw , 1) - 1) 
I2 = 70 : (70+size(img , 2) - 1) ; % Default: 70 : (70+size(bw , 2) - 1)
noise_img_black = rescale(noise_img_black(I1 , I2) ); 
noise_img_gray  = rescale(noise_img_gray(I1 , I2) ); 

% % figure(3) ; clf ; imshow(noise_img_black , []) ; 
% title('\fontsize{20}Noisy Image 1')
% figure(4) ; clf ; imshow(noise_img_gray  , []) ;
% title('\fontsize{20}Noisy Image 2')

% img = uint16( rescale( imadjust( rescale( bw + 2*noise_img_black + 2*noise_img_gray) ) , 0 , 255 ) ) ; 
noise_level_1 = 0.0 ; 
noise_level_2 = 0.4 ; 
img = imadjust( rescale( img + (noise_level_1 * noise_img_black) + (noise_level_2*noise_img_gray) ) ) ; 

close all ; 
figure(5) ; clf ; 
imshow(img , []) ; 
% imwrite(img , 'Beads_Img_With_Noise.tif' , 'tif')
% title('\fontsize{20}Image Added With Noise') ; 











