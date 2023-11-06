%% Validation Of My Image Processing Algo:
close all
clear ; 
clc ; 

% Construct A Noisy Image For Testing:

center1 = -2.9 ;
center2 = -center1;
dist = sqrt(2*(2*center1)^2);
radius = dist/2.1 * 0.8;
lims = [floor(center1-1.1*radius) ceil(center2+1.1*radius)];
[x,y] = meshgrid(lims(1):lims(2));
bw1 = sqrt((x-center1).^2 + (y-center1).^2) <= radius;
bw2 = sqrt((x-center2).^2 + (y-center2).^2) <= radius;
bw  = bw1 | bw2 ;

% % Close mask with disk
radius = 1;
decomposition = 0;
se = strel('disk', radius, decomposition);
bw = imclose(bw, se);
figure(1) ; clf ; imshow(bw) ; 

bw = rescale(repmat(bw , [17 , 17])) ; 
% 
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

% % DELETE ME LATER:
% bw(end+1 , :) = 0 ; 
% bw(: , end+1) = 0 ;

figure(3) ; clf ; imshow(noise_img_black , []) ; 
title('\fontsize{20}Noisy Image 1')
figure(4) ; clf ; imshow(noise_img_gray  , []) ;
title('\fontsize{20}Noisy Image 2')


%
% img = uint16( rescale( imadjust( rescale( bw + 2*noise_img_black + 2*noise_img_gray) ) , 0 , 255 ) ) ; 

% noise_level_1 = 0.1 ; 
% noise_level_2 = 0.715 ; 

noise_level_1 = 3.5 ; 
noise_level_2 = 1.5 ;
img = imadjust( rescale( bw + (noise_level_1 * noise_img_black) + (noise_level_2*noise_img_gray) ) ) ; 

% img = imresize(img , 4 , 'bicubic') ; 
im_size = size(img) ; 

close all ; 
figure(5) ; clf ; 
imshow(img , []) ; 
title('\fontsize{20}Image Added With Noise') ; 

name = sprintf('Img_GN_%3.3f_.tif' , noise_level_2) ; 
imwrite(img , name , 'tif') ; 
 
%
%
% imwrite(img ,'myImg.tif' , 'tif' )
imwrite(img ,'myImg.png' , 'png' )

[img2 , BW2] = cell_image_BW_preprocessor_4validation(img , 1 , 0.6 , 3) ;  %% Sensitivity = 0.57   

% % % % % cell_image_BW_preprocessor(img , 1 , 0.57 , 3)
% figure(6) ; clf ; imshow(img2 , []) ;
% title('\fontsize{20}Image AFter Noise Removal')
% imwrite(img2 ,'myImg2.tiff' , 'tiff' )
% 
% figure(7) ; clf ; imshow(BW2 , []) ;
% title('\fontsize{20}BW Image Of Figure(5)') ; 


close all ; 
wFiltSize       =   3 ; 
medFiltSize     =   2 ;   %figure ; imshowpair(img , img2 , 'montage')
gauss_std       =   0.9 ; 

img2 = wiener2(img2 , wFiltSize*[1,1] ) ; 
% img2 = imsharpen(img2 , 'radius' , ...
%     1.05 , 'amount' , 1.6 , 'Threshold' , 0.7) ;
img2 = medfilt2(img2 , medFiltSize*[1,1] ) ; 
img2 = imgaussfilt(img2 , gauss_std ) ; 
BW3 = imregionalmax( img2 , 4) ;

CC = bwconncomp(BW3) ; 
CC.islandSize = cellfun( @length , CC.PixelIdxList )' 

figure ; imshowpair(img , img2 , 'montage')
figure ; imshowpair(img , BW3 , 'montage')

% figure(7) ; clf ;  
% calib_for_beads = 0.16 ; % MICRONS PER PIXEL
% %      CC = CC2 ;  % DELETE ME
% CC.islandSize = CC.islandSize * calib_for_beads * 1e3 ; 
% [y , x] = histcounts(CC.islandSize , 25) ; %  , Normalization="count") ; 
% x = ( x(1:end-1) + x(2:end) ) * 0.5 ;
% plot(x , y , 'or-' , 'linew' , 2.5 , 'markersize' , 14)
% leg = ['Mean = ' , num2str(mean(CC.islandSize)) ,' nm' , newline , ...
%     'Std. Deviation = ' , num2str(std(CC.islandSize)) , ' nm' , ...
%     newline , 'Std = ' , num2str(std(CC.islandSize)/mean(CC.islandSize)*100) , '% of Mean', ...
%     newline , 'No. Of Particles = ' , num2str(numel(CC.islandSize))] ; 
% legend(leg , 'location' , 'northeast')
% xlabel('Size Of Particles (Nanometers-(nm))')
% ylabel('Number Of Particles')
% title('Size Distribution Of All 500 Frames')
% axis xy ; axis square ; grid on ; 
% set(gca , 'linew' , 2.5 , 'fontsize' , 20 , 'fontweight' , 'bold')
% exportgraphics(gcf , 'size_dist_2.pdf' , 'Resolution' , 300 , 'ContentType' , 'vector')
% 
% % % % Percent Std Deviation In the Measurement Of Particle Size:
% % % % STD is Just 0.7% Of the mean value despite that much noise in the Image:
% percent_std = std(CC.islandSize) / mean(CC.islandSize) * 100 
% min_size    = min(CC.islandSize) ; 
% max_size    = max(CC.islandSize) ; 
% 
% clearvars -except img BW2 CC

% Final One Line Processing:

% [ img3 , BW3 , CC ] = bio_watershed_segmentation_4validation(img , 1800 , 2000  , 1) ; 

% Convert Linear Indicies to X-Y Subscripts:
[x , y] = cellfun( @(x) ind2sub(CC.ImageSize , x) , CC.PixelIdxList' , 'UniformOutput',0 ) ; 

% Find mean of each cell and concatenate the results:
CC.centroid = [ cellfun(@(x) mean(x) , y) , cellfun(@(x) mean(x) , x) ]  ; 

% 
% figure(10) ; clf ; imshow(img3) ; 
% title('\fontsize{20} Final Step: Img After Watershed Segmentation')
% imwrite(img3 ,'myImg3.tiff' , 'tiff' )
% 
% figure(11) ; clf ; imshow(BW3) ; 
% title('\fontsize{20} Seperating Overlapping Particles') ; 

close all ; 
figure(12) ; clf ; imshow(img) ; hold on ; 
plot(CC.centroid(: , 1) , CC.centroid(: ,2) , '.r' , 'LineWidth', 2.5 , 'MarkerSize',10) ; 
% plot(CC.centroid(: , 1) , CC.centroid(: ,2) , 'or' , 'LineWidth', 1.1 , 'MarkerSize',15) ;
fig_title = sprintf('Detecting %i Particles, BN = %2.2f , WN = %2.2f' , ...
    CC.NumObjects , noise_level_1 , noise_level_2) ; 
title(fig_title , 'FontSize',20) ; 

imwrite(img2 ,'myImg2.tiff' , 'tiff' )

%%





