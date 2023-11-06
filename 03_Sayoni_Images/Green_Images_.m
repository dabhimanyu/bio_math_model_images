%%

clear ; 
clc ; 
close all ; 

% Set A:
filepath_A = ['/Users/abhimanyudubey/' ...
    'Pictures/z_Image_Processing_Talk_/' ...
    'Sayoni_MATLAB IP samples/Green fluorescence/SetA'] ; 

filepath_B = ['/Users/abhimanyudubey/' ...
    'Pictures/z_Image_Processing_Talk_/' ...
    'Sayoni_MATLAB IP samples/' ...
    'Green fluorescence/SetB'] ; 

filepath_A = ['/Users/abhimanyudubey/' ...
    'Downloads/B_n=1_16th Nov/' ...
    'Green intensity quantification/HG'] ; 

[~ , onlyFilenames_A] = Import_all_files_in_a_folder(...
    'tif' , filepath_A ) ; 
[~ , onlyFilenames_B] = Import_all_files_in_a_folder('tif' , filepath_B) ; 

i = 2 ; 
%
tic

final_statistic = zeros(numel(onlyFilenames_A) , 1) ; 

for i = 1 : numel(onlyFilenames_A)
    wFiltSize   =   4 ; 
    medFiltSize =   6 ; 

    im_original = imread(fullfile(filepath_A , onlyFilenames_A{i})) ; 
    im_original = im_original(: , : , 2) ; 
    img = im_original ; 

    img = imadjust(img) ; 
    img = wiener2(img , wFiltSize*[1 , 1]) ; 
    img = medfilt2(img , medFiltSize * [1,1] ) ; 

    img = imtophat(img , strel('disk' , 50)) ; 

    x1  = 267 : 584 ; 
    x2  = 437 : 1021 ;

    % close all ; imshow(img) ; 
    % close all ; 
    % figure(1) ; imshowpair(im_original(x1,x2) , img(x1,x2)  , 'montage') ; 
    
    img = imadjust(img) ; 
    BW  = imbinarize(img , "adaptive" , 'Sensitivity', ...
            0.5 , 'ForegroundPolarity','bright')  ; 

    BW = imopen(BW  , strel('disk' , 4 )) ; 
    BW = imerode(BW , strel('disk' , 2 )) ; 
    BW = imfill(BW , 'holes') ; 


    % Noise Removal:
    img(~BW) = 0 ; 

    % figure(3) ; imshowpair(im_original(x1,x2) , img(x1,x2)  , 'montage') ; 

    % Distance Transform:
    d =  bwdist(~BW)  ; 

    watershed_thresh = 1 ; 
    d = imhmin(d , watershed_thresh) ; 

    cellSep = watershed(d , 4) ; 
    cellSep(~BW) = 0 ; 

    BW = cellSep > 0 ; 
    img(~BW) = 0  ;

%     close all ; 
%     imshow(img) ; 

    CC = bwconncomp(BW , 4) ; 

    % Size Of the Islands:
    CC.islandSize = cellfun(@length , CC.PixelIdxList).' ; 

    % Intensity Average:
    CC.meanIntensity = zeros(CC.NumObjects , 1) ; 

    for ii = 1 : CC.NumObjects
        CC.meanIntensity(ii) = mean(img(CC.PixelIdxList{ii})) ; 
    end


    w   = CC.islandSize    ;      % Areas as weights:
    I   = CC.meanIntensity ; 
    W_I = ( w.'* I ) / ( sum(w) *  1 ) ;  %CC.NumObjects
    final_statistic(i) = W_I  ; 


end
% % im_overlay = imoverlay(img , BW , 'yellow') ; 
% % close all ; 
% % figure(1) ; imshow(im_overlay) ; 
% % figure(2) ; imshowpair(im_original , img  , 'montage') ; 


t(1) = toc

%%

mean(final_statistic)     
std(final_statistic)






