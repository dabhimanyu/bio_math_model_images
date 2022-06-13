%% Processing Real Cell Images:
clear ; 
% close all ; 
clc ; 

filepath = ['/Users/' ...
    'abhimanyudubey/' ...
    'Pictures/BIO MATH MODEL/' ...
    '001_Real_Img_2nd_Iteration_With_Aishwarya_5_May_2022_'] ; 
% % % Beads:
% % filepath = ['/Users/abhimanyudubey/' ...
% %     'Downloads/0009_0016_beads_images_256X256'] ; 

[fileNames , onlyFileNames] = ...
    Import_all_files_in_a_folder('.tif' , filepath) ; 

wFiltSize   = 2 ;     % 2 for real Images:
medFiltSize = 2 ;   % 2 For Real Images:

i = 1  ;

img = imread(fileNames{i}) ;
im_original = img ; 

figure(1) ; imshow(img , []) ; 
% % % % % Create a Circular Mask On the Cell:
% % % % % h = drawellipse(gca) ; 
% % h = drawellipse(gca , ...
% %     'center' , [107 85] , 'SemiAxes' , [67.0075 63.0079] ) ;
% % mask = createMask(h) ; close(1) ; 
% % img(~mask) = uint16(0) ; 

img = wiener2(img , wFiltSize*[1,1] ) ; 
% figure(1) ; imshow(img , [])

BW_4_whole_img = img>07000 ; 
BW_4_whole_img = imclose(BW_4_whole_img, strel('disk', 100)) ;
BW_4_whole_img = imopen(BW_4_whole_img, strel('disk',4)) ;

img = im_original ; 
img(~BW_4_whole_img) = 0 ; 
im_fused = imfuse(imadjust(img) , BW_4_whole_img) ; 
figure(1) ; imshowpair(im_fused , imadjust(im_original) , 'montage') ; 

% Now Applying Filters On the Remaining Part Of the Image
img = wiener2(img , wFiltSize*[1,1] ) ; 
img = imsharpen(img , 'radius' , ...
    1.05 , 'amount' , 1.6 , 'Threshold' , 0.7) ;
img = medfilt2(img , medFiltSize*[1,1] ) ; 

BW = imregionalmax(img , 4) ; 
im_fused = imfuse(img , BW) ; 
% figure(2) ; montage(im_original , img , im_fused)

CC = bwconncomp(BW , 4)  ; 
[x , y]      = cellfun( ...
    @(x) ind2sub(CC.ImageSize , x) , ...
    CC.PixelIdxList' , 'UniformOutput',0 ) ; 
CC.centroid  = [ cellfun(@(x) mean(x) , y) , ...
    cellfun(@(x) mean(x) , x) ]  ; 

% close all ; 
fig = figure(2) ; 
imshow(img , [] ) ; hold on ; 
plot(CC.centroid(:  , 1) , CC.centroid(: , 2) , '+r' , 'LineWidth', 1.8 , ...
    'markersize' , 5) ; hold off ; 
title_ = sprintf('Showing %i particles' , CC.NumObjects) ;  
title(title_ , 'fontsize' , 12) ; 


%%

exportgraphics(fig , 'Img_001_9053.jpg' , 'Resolution',300 , 'ContentType','image') ; 

%%

% img = img(30:120 , 70:160) ; 
% img = imadjust(img) ; 
% img = wiener2(img , wFiltSize*[1,1] ) ; 
% img = imsharpen(img , 'radius' , 1 , 'amount' , 0.8 , 'threshold' , 0.7 ) ; 
BW_4_whole_img = imregionalmax(img , 4) ; 
% img = medfilt2(img , medFiltSize*[1,1] ) ; 

% figure(1) ; imshow(imresize(img , 2) , []) ; 
% figure(2) ; imshowpair(img , BW)


