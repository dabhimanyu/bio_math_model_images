%% 

clear ; 
close all ; 
clc

filepath = ['/Users/' ...
    'abhimanyudubey/Pictures/' ...
    'z_Image_Processing_Talk_/' ...
    'aditya_upasani/cy5LL37_194pM_NoTCEP_' ...
    '500uM_5_min_peg_20ms_5mW_1000gain_ch1_3'] ; 

% filepath = ['/Users/' ...
%     'abhimanyudubey/' ...
%     'Pictures/z_Image_Processing_Talk_' ...
%     '/aditya_upasani/' ...
%     'cy5LL37_194pM_NoTCEP_500uM_5_min_peg_20ms_5mW_1000gain_ch1_3/' ...
%     'qwq'] ; 


[fileNames , onlyFilenames] = Import_all_files_in_a_folder('.tif' , filepath) ; 

i = 1 ; 
wFiltSize = 4 ; 
medFiltSize = 3 ; 

im_original = imadjust(imread(fullfile(filepath , onlyFilenames{i}))) ; 
% imshow(img , [] ) ; 
% imshowpair(im_original , img , 'montage') ; 

img = wiener2(im_original , wFiltSize*[1,1]) ; 
img = medfilt2(img , medFiltSize * [1,1]) ; 
img = imgaussfilt(img , 1 , "FilterSize", [3,3] ) ; 

figure(1) ; clf ; 
imshowpair(im_original , img , 'montage' ) ; 

% figure(2) ; clf ; 
% surf(img) ; 

BW = imregionalmax(img , 4) ; 
im_overlay = imoverlay(img , BW , 'Green') ; 
figure(3) ; clf ; imshow(im_overlay , []) ; 

% Too much oversegmentation: Let's see what is happening here.
close all ; 
xIdx = 318 : 365 ; 
yIdx = 130 : 197 ; 

figure(1) ; clf ; 
imshow(imresize(im_overlay(xIdx , yIdx , :) , 10)) ; 

% 3-D Visualization:
img_crop = rescale(img(xIdx , yIdx) ) ; 
BW_crop  = BW(xIdx , yIdx ) ; 

figure(2) ; clf ; 
surf(img_crop , EdgeColor="none") ; 
colormap jet ; lighting gouraud ; shading interp ; 
daspect([1.5 1 0.03])

% Find Regional Maxima Peaks:
[y , x] = find(BW_crop) ;

% Find Heights Of Regmax Peaks:
z = img_crop(BW_crop) ; 

figure(2) ; hold on ; 
plot3(x , y , z , 'LineStyle','none' , Marker='o' , MarkerEdgeColor='b' , MarkerFaceColor='y')
xlabel('X') ; ylabel('Y') ; 
set(gca , 'YDir' , 'reverse') ;
view(-35 , 45) ; camlight ; 
hold off ; 

%% Appy h-Maxima Transform: 

% close all ; 

h = 0.34 ; 
A = imhmax(rescale(img) , h) ; 
BW = imregionalmax(A , 4) ; 


img_crop = rescale(A(xIdx , yIdx) ) ; 
BW_crop  = BW(xIdx , yIdx ) ; 




I1 = imresize(im_original(xIdx , yIdx) , 10 ) ; 
I2 = imresize( A(xIdx , yIdx) , 10 ) ; 
figure(1) ; clf ; 
imshowpair( I1 , I2 , 'montage') ; 

figure(3) ; clf ; 
imshowpair(im_original , A , 'montage') ; 

% Pre Process img A once again before applying regMax:

A = wiener2(A , 3*[1,1]) ; 
A = medfilt2(A , 4*[1,1])  ; 
% A = bpass(A , 1 , 4) ; 
% A = imgaussfilt(A , 0.5 , 'FilterSize', [3,3]) ; 

BW = A > 0.3 ; 
% figure(3) ; imshowpair(A , BW) ;

% Keep thresh high so that only bright intensities come and then dilate
% those small areas to get nearby areas too. 
BW = imfill(BW , 'holes') ;  % Uses Morphological reconstruction, 
BW = imdilate(BW , strel('disk' , 3)) ; 
% figure(4) ; imshowpair(A , BW) ;

% Now Burn the mask over Image to eliminate everything else:
A(~BW) = 0 ;  
figure(4) ; imshowpair(rescale(im_original) , A , 'montage') ; 


A_regmax = imregionalmax(A  , 4 ) ; 
A_overlay = imoverlay(A , A_regmax , 'green') ; 

figure(5) ; clf ; 
imshowpair(rescale(im_original) , A_overlay) ;
imshowpair(rescale(im_original) , A_overlay , 'montage') ; 

% 


% 3-D Visualization:
img_crop = rescale(A(xIdx , yIdx) ) ; 
BW_crop  = A_regmax(xIdx , yIdx ) ; 

figure(3) ; clf ; 
surf(img_crop , EdgeColor="none") ; 
colormap jet ; lighting gouraud ; shading interp ; 
daspect([1.5 1 0.03])

% Find Regional Maxima Peaks:
[y , x] = find(BW_crop) ;

% Find Heights Of Regmax Peaks:
z = img_crop(BW_crop) ; 

figure(3) ; hold on ; 
plot3(x , y , z , 'LineStyle','none' , Marker='o' , MarkerEdgeColor='b' , MarkerFaceColor='y')
xlabel('X') ; ylabel('Y') ; 
set(gca , 'YDir' , 'reverse') ;
view(-35 , 45) ; camlight ; 
hold off ; 





