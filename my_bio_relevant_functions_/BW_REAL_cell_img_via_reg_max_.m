function [ img  ,  BW  , CC ]    =   BW_REAL_cell_img_via_reg_max_(img)
%% Input Parameters:

wFiltSize       =   4 ; 
medFiltSize     =   2 ; 

im_original = img ; 
% img = rescale(img) ; 

img2    =   wiener2(img , wFiltSize*[1,1]) ; 
BW_mask =   img2 >18500 ;  %  imshowpair(imadjust(im_original) , BW_mask)
BW_mask =   imclose(BW_mask , strel('disk' , 100) ) ; 
BW_mask =   imopen( BW_mask , strel('disk' , 4  ) ) ; 

img(~BW_mask)  = 0 ; 
img2 = img ; 

% Now Applying Filters On the Remaining Part Of the Image
img2 = wiener2(img2 , wFiltSize*[1,1] ) ; 
img2 = imsharpen(img2 , 'radius' , ...
    1.05 , 'amount' , 1.6 , 'Threshold' , 0.7) ;
img2 = medfilt2(img2 , medFiltSize*[1,1] ) ; 

BW = imregionalmax( rescale(img2) , 4) ; 
%  im_fused = imfuse(img2 , BW) ; 
%  figure ; imshow(im_fused , [] )

CC      =       bwconncomp(BW , 4)  ; 
[x , y] =       cellfun( @(x) ind2sub(CC.ImageSize , x) , ...
                CC.PixelIdxList' , 'UniformOutput',0 ) ; 
CC.centroid  =  uint8( [ cellfun(@(x) mean(x) , y) , cellfun(@(x) mean(x) , x) ] )  ; 

img = img2 ; 

CC.centroid = subpixel_2d_gauss(CC.centroid , img2 ) ; 

pj_break = 2 ; 
end


function [ xy_vector , intensity_vec ] = ...
    subpixel_2d_gauss(centroid_xy , par_img)
%%
% 2D Subpixel estimator based on, 
% H. Nobach and M. Honkanen (2005)
% Two-dimensional Gaussian regression for sub-pixel displacement
% estimation in particle image velocimetry or particle position
% estimation in particle tracking velocimetry
% Experiments in Fluids (2005) 38: 511-515

%% Simple 2-D Gaussian Subpixel Estimator:
par_img = double(par_img) ; 

% Low Pass Gaussian Filtered Image:
par_img = imgaussfilt(par_img , 1.0 , 'FilterSize', 3) ; 

x = double( centroid_xy(: , 1) ) ; 
y = double( centroid_xy(: , 2) ) ; 
[nrows , ncols] = size(par_img) ; 

% Linear Indicies of the XY Coordinate:
ip      =   sub2ind(size(par_img) , x , y ) ; 
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

% Normalise The Deltas By their Norm:
deltax = deltax ./ (deltax'*deltax)^0.5 ; 
deltay = deltay ./ (deltay'*deltay)^0.5 ; 

SubpixelX = x + deltax;
Subpixely = y + deltay;

%% Calculate Intensities At These SubPixel Points:

% FINISH ME....!!

%%

xy_vector = [SubpixelX , Subpixely] ; 
pj_break = 'break_point' ; 



end












































































