function [ img  ,  BW  , CC ]    =   BW_artificial_img_via_reg_max_(img)
%%
% Input Parameters:

wFiltSize       =   5   ; 
medFiltSize     =   5   ; 

%%

% % img = wiener2(img , wFiltSize*[1,1] ) ; % figure ; imshow(img , []) ; 
% % img = medfilt2(img , medFiltSize*[1,1] ) ; 

% Generate Mask:
% Thresh Of 130-150 Seems To Work:
artificial_img_thresh = 130 ; % figure(1) ; imshow(img) ; 
BW = img > artificial_img_thresh ; % figure(11); imshow(BW) ; 
img(~BW) = 0 ; % figure(2) ; imshow(img) ; 

% % 
% img = wiener2(img , wFiltSize*[1,1] ) ; % figure(3) ; imshow(img , []) ; 
% img = medfilt2(img , medFiltSize*[1,1] ) ; % figure(4) ; imshow(img , []) ; 
% 
% BW2 = imregionalmax(img , 4) ; % figure ; imshow(BW2) ; 
% Find Connected Components:
CC = bwconncomp(BW , 4) ; 

% Find The Centre Of Mass For All Detected Connected Compinents:
[x , y]      = cellfun( ...
    @(x) ind2sub(CC.ImageSize , x) , ...
    CC.PixelIdxList' , 'UniformOutput',0 ) ; 
CC.centroid  = [ cellfun(@(x) mean(x) , y) , ...
    cellfun(@(x) mean(x) , x) ]  ; 

end



% Improve Initially Generated Mask:
% BW = imopen(BW , strel('disk' , 2 ) ) ; 
% BW = imclose(BW ,strel('disk' , 2 ) ) ; 
% figure ;  imshow(BW)