%% Validation Of My Image Processing Algo:
% close all
clear ; 
clc ; 

% Construct A Noisy Image For Testing:

center1 = -12;
center2 = -center1;
dist = sqrt(2*(2*center1)^2);
radius = dist/2.1 * 1.1;
lims = [floor(center1-1.1*radius) ceil(center2+1.1*radius)];
[x,y] = meshgrid(lims(1):lims(2));
bw1 = sqrt((x-center1).^2 + (y-center1).^2) <= radius;
bw2 = sqrt((x-center2).^2 + (y-center2).^2) <= radius;
bw  = bw1 | bw2 ;

% % Close mask with disk
% radius = 1;
% decomposition = 0;
% se = strel('disk', radius, decomposition);
% bw = imclose(bw, se);
figure(1) ; clf ; imshow(bw) ; 
bw = rescale(repmat(bw , [10 , 9])) ; 

figure(2) ; clf ; 
imshow( bw , [] )
title('\fontsize{20}Initial Noise Free Image')

% Adding Noise:

% Black Image:
noise_img_black = imadjust(rgb2gray(imread('/Users/abhimanyudubey/Pictures/BIO MATH MODEL/Img_4_Noise/Black_Img.JPG'))) ; 
noise_img_gray  = imadjust(rgb2gray(imread('/Users/abhimanyudubey/Pictures/BIO MATH MODEL/Img_4_Noise/Grey_Img.TIF' ))) ; 

I1 = 50 : (50+size(bw , 1) - 1) ; % Default: 50 : (50+size(bw , 1) - 1) 
I2 = 70 : (70+size(bw , 2) - 1) ; % Default: 70 : (70+size(bw , 2) - 1)
noise_img_black = rescale(noise_img_black(I1 , I2) ); 
noise_img_gray  = rescale(noise_img_gray(I1 , I2) ); 

figure(3) ; clf ; imshow(noise_img_black , []) ; 
title('\fontsize{20}Noisy Image 1')
figure(4) ; clf ; imshow(noise_img_gray  , []) ;
title('\fontsize{20}Noisy Image 2')

% img = uint16( rescale( imadjust( rescale( bw + 2*noise_img_black + 2*noise_img_gray) ) , 0 , 255 ) ) ; 
noise_level_1 = 2 ; 
noise_level_2 = 2 ; 
img = imadjust( rescale( bw + (noise_level_1 * noise_img_black) + (noise_level_2*noise_img_gray) ) ) ; 

figure(5) ; clf ; 
imshow(img , []) ; 
title('\fontsize{20}Image Added With Noise') ; 

%
imwrite(img ,'myImg.tiff' , 'tiff' )

[img2 , BW2] = cell_image_BW_preprocessor(img , 1 , 0.6 , 3) ;  %% Sensitivity = 0.57   

% % % % % cell_image_BW_preprocessor(img , 1 , 0.57 , 3)

figure(6) ; clf ; imshow(img2 , []) ;
title('\fontsize{20}Image AFter Noise Removal')
imwrite(img2 ,'myImg2.tiff' , 'tiff' )

figure(7) ; clf ; imshow(BW2 , []) ;
title('\fontsize{20}BW Image Of Figure(5)') ; 
%
%
CC = bwconncomp(BW2) ; 
CC.islandSize = cellfun( @length , CC.PixelIdxList )' ; 

% Percent Std Deviation In the Measurement Of Particle Size:
% STD is Just 0.7% Of the mean value despite that much noise in the Image:
percent_std = std(CC.islandSize) / mean(CC.islandSize) * 100 
min_size    = min(CC.islandSize) ; 
max_size    = max(CC.islandSize) ; 

clearvars -except img BW2 CC

% Final One Line Processing:

[ img3 , BW3 , CC ] = bio_watershed_segmentation(img , 1800 , 2000  , 1) ; 
figure(10) ; clf ; imshow(img3) ; 
title('\fontsize{20} Final Step: Img After Watershed Segmentation')
imwrite(img3 ,'myImg3.tiff' , 'tiff' )

figure(11) ; clf ; imshow(BW3) ; 
title('\fontsize{20} Seperating Overlapping Particles') ; 

figure(12) ; clf ; imshow(img3) ; hold on ; 
plot(CC.centroid(: , 1) , CC.centroid(: ,2) , '+r' , 'LineWidth', 2.5 , 'MarkerSize',15) ; 
plot(CC.centroid(: , 1) , CC.centroid(: ,2) , 'or' , 'LineWidth', 1.1 , 'MarkerSize',15) ; 
title('\fontsize{20} Final Step: Img After Watershed Segmentation')

imwrite(img3 ,'myImg3.tiff' , 'tiff' )


%%




