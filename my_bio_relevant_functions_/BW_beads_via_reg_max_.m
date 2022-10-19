function [ img  ,  BW  , CC ]    =   BW_beads_via_reg_max_( img )

%% Inout Paramaters:

wFiltSize   =   3 ;     % 2 for real Images:
medFiltSize =   3 ;   % 2 For Real Images:

%%
im_original = img ; 
img2    =       imadjust(img) ; 
img2    =       wiener2(img2 , wFiltSize*[1,1]) ;     % figure(1) ; imshow(img) ; 
img2    =       imsharpen(img2 , 'radius' , 1.05 ,...    % figure(2) ; imshow(img2) ; 
                'amount' , 1.6 , 'threshold', 0.7 ) ;       % figure(3) ; imshow(img2) ; 
img2    =       medfilt2(img2 , medFiltSize*[1,1] ) ;    % figure(4) ; imshow(img2) ; 

% Generate Mask:
% Thresh Of 130-150 Seems To Work:
% artificial_img_thresh = 5e3 ;      % figure(1) ; imshow(img) ; 
% BW = img2 > artificial_img_thresh ;  % figure(11); imshowpair(img2 , BW) ; 
% img(~BW) = 0 ;                      % figure(2) ; imshow(img) ; 

% Eliminate everything from the image except for the Islands:
img2    =       imadjust(img2) ; 
BW      =       imbinarize(img2 , 'adaptive' , 'Sensitivity', 0 , ...
                'ForegroundPolarity','bright') ;
% Open BW with Square SE:
% BW      =       imopen(BW , strel('square' , 3)) ; 
BW      =       imfill(BW , 'holes') ; 
img(~BW) = 0 ; 
img = imadjust(img)     ;       % figure(5) ; imshow(img , [] ) ; 


BW      =       imregionalmax(img , 4)  ;      % figure(11) ; imshowpair(img , BW) ; 
BW      =       imfill(BW , "holes")    ; 

CC      =       bwconncomp(BW , 4)  ; 
[x , y] =       cellfun( @(x) ind2sub(CC.ImageSize , x) , ...
                CC.PixelIdxList' , 'UniformOutput',0 ) ; 
CC.centroid  = [ cellfun(@(x) mean(x) , y) , cellfun(@(x) mean(x) , x) ]  ; 

pj_break = 3 ; 
end

function





