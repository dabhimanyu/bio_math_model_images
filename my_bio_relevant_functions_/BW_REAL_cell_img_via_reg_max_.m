function [ img  ,  BW  , CC ]    =   BW_REAL_cell_img_via_reg_max_(img)
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

%%
%  Default Kernal Size For Wiener Filter And Median Filter:
% NOTE To Self: Wiener is an edge preserving, adaptive low-pass filter
wFiltSize       =   5 ; 
medFiltSize     =   2 ; 

im_original = img ; 
% img = rescale(img) ; 

% Apply 2-d wiener filter
img2    =   wiener2(img , wFiltSize*[1,1]) ; 

% Do The Thresholding Of the Image: 
BW_mask =   img2 >18500 ;  %  imshowpair(imadjust(im_original) , BW_mask)

% % % Adaptive Blockwise Thresholding:
%  figure ; imshow(BW_mask)
% blockSize =  64*[1,1] ; 
% otsuFun   =  @(blockStruct) imbinarize(blockStruct.data , 'adaptive' , Sensitivity=0.4) ; 
% BW_mask   =  blockproc(img2 , blockSize , otsuFun , BorderSize=[0,0] , PadPartialBlocks=false) ; 
% 
% % % % % % Dilate mask with default
% % % % % radius = 4;
% % % % % decomposition = 0;
% % % % % se = strel('disk', radius, decomposition);
% % % % % BW = imdilate(BW, se);
% % % % % 
% % % % % % Close mask with default
% % % % % radius = 5;
% % % % % decomposition = 0;
% % % % % se = strel('disk', radius, decomposition);
% % % % % BW = imclose(BW, se);
% % % % % 
% % % % % % Open mask with default
% % % % % radius = 5;
% % % % % decomposition = 0;
% % % % % se = strel('disk', radius, decomposition);
% % % % % BW = imopen(BW, se);
% % % % % 
% % % % % % Dilate mask with default
% % % % % radius = 2;
% % % % % decomposition = 0;
% % % % % se = strel('disk', radius, decomposition);
% % % % % BW = imdilate(BW, se);


% Improve The Mask by using morphological opening and closing operations:
BW_mask =   imclose(BW_mask  , strel('disk' , 100) ) ; 
BW_mask =   imdilate(BW_mask , strel('disk' , 014) ) ; 
BW_mask =   imopen( BW_mask  , strel('disk' , 3  ) ) ; 

% Whatever Pixels are not contained in Mask, assign zero Value to them:
% This eliminates Unwanted Pixels and reduces the Image Size Significantly.
img(~BW_mask)  = 0 ; 
img2 = img ; 

% Now Applying Filters On the Remaining Part Of the Image
% First 2-D Wiener, then sharpening, and the finally median filter.
img2 = wiener2(img2   , wFiltSize*[1,1] ) ; 
img2 = imsharpen(img2 , 'radius' , 1.3 , 'amount' , 1.8 , 'Threshold' , 0.9) ;
img2 = medfilt2(img2  , medFiltSize*[1,1] , "symmetric") ; 

% Regional Maxima 
img2     =       imhmax(img2 , 1200, 8)     ; 
% tpj     =       imhmax(img , 10 , 8)     ; 
BW = imregionalmax( rescale(img2) , 4) ; 
%  im_fused = imfuse(img2 , BW) ; 
%  figure ; imshow(im_fused , [] )

% Segment The Image to Identify the islands contained in the image:
% CC = connected components
CC      =       bwconncomp(BW , 4)  ; 

% Calculate the centroids Of All the Islands identified in the previous
% Step:
[y , x] =       cellfun( @(x) ind2sub([CC.ImageSize] , x) , ...
                CC.PixelIdxList' , 'UniformOutput',0 ) ; 

CC.centroid  =  uint8( [ cellfun(@(x) mean(x) , x) , cellfun(@(x) mean(x) , y) ] )  ; 

img = img2 ; 

% Calculate Mean Intensities At the Centroids:
mean_intensity_at_centroid = mean_intensity_calculator(...
    img2 , CC.centroid) ; 


% Apply SubPixel Estimator: 
% Implemented from one of the papers which you have shared with Aishwarya
% Complete Reference To The Paper is written below:
CC.centroid = subpixel_2d_gauss(CC.centroid , img2 ) ; 

CC.I_mean = mean_intensity_at_centroid ; 

pj_break = 2 ; 
end

function [mean_intensity_at_centroid] = mean_intensity_calculator(...
    img , centroid)
    
    % Declaring new variables for quick easy use
    c = centroid ; 
    I = img ; 
    I_mean = zeros(size(c , 1) , 1 ) ; 
    
    for i = 1 : size(c , 1)
        y = c(i , 1) ; 
        x = c(i , 2) ; 
        I_mean(i , 1) = mean( [ I(x-1 , y) , I(x , y) , I(x+1 , y) , ...
                            I(x , y-1) , I(x , y+1) ] ) ; 
    end

    mean_intensity_at_centroid = I_mean ; 
end % end of mean_intensity_calculator



function [ xy_vector , intensity_vec ] = ...
    subpixel_2d_gauss(centroid_xy , par_img)
%% Paper Reference:
% 2D Subpixel estimator based on, 
% H. Nobach and M. Honkanen (2005)
% Two-dimensional Gaussian regression for sub-pixel displacement
% estimation in particle image velocimetry or particle position
% estimation in particle tracking velocimetry
% Experiments in Fluids (2005) 38: 511-515

%% Simple 2-D Gaussian Subpixel Estimator:
par_img = rescale(par_img) ; 

% Low Pass Gaussian Filtered Image:
par_img = imgaussfilt(par_img , 1.0 , 'FilterSize', 3) ; 

x = double( centroid_xy(: , 1) ) ; 
y = double( centroid_xy(: , 2) ) ; 
[nrows , ncols] = size(par_img) ; 

% Linear Indicies of the XY Coordinate:
ip      =   sub2ind(size(par_img) , y , x ) ; 
xmax    =   size(par_img , 1) ; 


% Eliminate erronious coordinates:
xi = ~( (x >= 2) & (y >= 2) & (x <= ncols-1) & (y <= nrows-1 ) )  ; 
x(xi) = [] ; 
y(xi) = [] ; 

c10 = zeros(3 , 3 , numel(x) ) ; 
c01 = c10;
c11 = c10;
c20 = c10;
c02 = c10;

if ( numel(x) ~= 0 )

    for i = -1 : 1
        for j = -1 : 1
		    c10(j+2,i+2, :) = i*log(par_img(ip+xmax*i+j));
			c01(j+2,i+2, :) = j*log(par_img(ip+xmax*i+j));
			c11(j+2,i+2, :) = i*j*log(par_img(ip+xmax*i+j));
			c20(j+2,i+2, :) = (3*i^2-2)*log(par_img(ip+xmax*i+j));
			c02(j+2,i+2, :) = (3*j^2-2)*log(par_img(ip+xmax*i+j));
			%c00(j+2,i+2)=(5-3*i^2-3*j^2)*log(par_img(maxY+j, maxX+i));
        end
    end
end

% Replace Inf By Zero:
c10(isinf(c10)) = 0 ; 
c01(isinf(c01)) = 0 ; 
c11(isinf(c11)) = 0 ; 
c20(isinf(c20)) = 0 ; 
c02(isinf(c02)) = 0 ; 
% c00(isinf(c00)) = 0 ;

% Replace NaN by Zero:
c10(isnan(c10)) = 0 ; 
c01(isnan(c01)) = 0 ; 
c11(isnan(c11)) = 0 ; 
c20(isnan(c20)) = 0 ; 
c02(isnan(c02)) = 0 ; 
% c00(isnan(c00)) = 0 ; 

% Now compute the coefficients:
% as per equations 12-17 of the paper:
c10 = (1/6) * squeeze(sum(sum(c10 , 1) , 2)) ; 
c01 = (1/6) * squeeze(sum(sum(c01 , 1) , 2)) ; 
c11 = (1/4) * squeeze(sum(sum(c11 , 1) , 2)) ; 
c20 = (1/6) * squeeze(sum(sum(c20 , 1) , 2)) ; 
c02 = (1/6) * squeeze(sum(sum(c02 , 1) , 2)) ; 
% c00 = (1/9) * squeeze(sum(sum(c00 , 1) , 2)) ; 

deltax = ((c11.*c01-2*c10.*c02)./(4*c20.*c02-c11.^2)) ;
deltay = ((c11.*c10-2*c01.*c20)./(4*c20.*c02-c11.^2)) ;

% Eliminate NaNs:
deltax(isnan(deltax)) = 0 ; 
deltay(isnan(deltay)) = 0 ; 

% Normalise The Deltas By their Norm 
% so that their values lies b/t (0,1):
deltax = deltax ./ (deltax'*deltax)^0.5 ; 
deltay = deltay ./ (deltay'*deltay)^0.5 ; 

SubpixelX = x + deltax;
Subpixely = y + deltay;

%% Calculate Intensities At These SubPixel Points:

% FINISH ME....!! 
% U Lazy fellow ||-_-||

%%
xy_vector = [SubpixelX , Subpixely] ; 
pj_break = 'break_point' ; 

end





