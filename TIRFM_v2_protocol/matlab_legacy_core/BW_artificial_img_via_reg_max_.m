function [ img  ,  BW  , CC ]    =   BW_artificial_img_via_reg_max_(img)
%%
%%
%
% Input Parameters:
% img: image matrix
% 
% Output Parameters:
%       1. img: Final 16-bit Gray-Image After Image Processing
%       2. BW:  Binarized Image showing the location of centroids
%               identified by the regional maxima algorithm
%       3. CC:  a.k.a connected components, is a structure containg 5 elements. 
%           (1) Connectivity: Connectivity Index used for 
%                               identification of islands
%           (2) ImageSize   : Size Of the Image
%           (3) NumObjects  : Number of islands identified in the image
%           (4) PixelIdxList: Linear Pixel Index List for the pixels of
%                               each island
%           (5) centroid    : X-Y Coordinates of all CC.NumObjects islands 
% 
% 
% WRITTEN BY
%
% Abhimanyu Dubey
% Joint Ph.D. student,
% Prof. V. Kumaran’s Lab
% Department of Chemical Engineering,
% IISc Bangalore, 
% Prof. Manaswita Bose’s Lab,
% Department of Energy Science and Engineering,
% IIT-BOMBAY
% 

%% Default Parameters:

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