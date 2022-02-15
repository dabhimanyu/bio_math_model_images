%% Validation Of My Image Processing Algo:
% close all
clear ; 
clc ; 

% Construct A Noisy Image For Testing:

center1 = -12;
center2 = -center1;
dist = sqrt(2*(2*center1)^2);
radius = dist/2 * 1.1;
lims = [floor(center1-1.1*radius) ceil(center2+1.1*radius)];
[x,y] = meshgrid(lims(1):lims(2));
bw1 = sqrt((x-center1).^2 + (y-center1).^2) <= radius;
bw2 = sqrt((x-center2).^2 + (y-center2).^2) <= radius;
bw  = bw1 | bw2 ;

% Close mask with disk
radius = 2;
decomposition = 0;
se = strel('disk', radius, decomposition);
bw = imclose(bw, se);
bw = rescale(repmat(bw , [10 , 9])) ; 

figure(1) ; clf ; 
imshow( bw , [] )

% Adding Noise:

% Black Image:
noise_img_black = imadjust(rgb2gray(imread('/Users/abhimanyudubey/Pictures/BIO MATH MODEL/Img_4_Noise/Black_Img.JPG'))) ; 
noise_img_gray  = imadjust(rgb2gray(imread('/Users/abhimanyudubey/Pictures/BIO MATH MODEL/Img_4_Noise/Grey_Img.TIF' ))) ; 

I1 = 50 : (50+size(bw , 1) - 1) ; % Default: 50 : (50+size(bw , 1) - 1) 
I2 = 70 : (70+size(bw , 2) - 1) ; % Default: 70 : (70+size(bw , 2) - 1)
noise_img_black = rescale(noise_img_black(I1 , I2) ); 
noise_img_gray  = rescale(noise_img_gray(I1 , I2) ); 

figure(2) ; clf ; imshow(noise_img_black , []) ; 
figure(4) ; clf ; imshow(noise_img_gray  , []) ; 

img = uint16( rescale( imadjust( rescale( bw + 2*noise_img_black + 2*noise_img_gray) ) , 0 , 255 ) ) ; 
figure(3) ; clf ; 
imshow(img , []) ; 

clearvars -except img
%% Now Let's Process This Image:

[ img , BW , CC ] = bio_watershed_segmentation(img)






