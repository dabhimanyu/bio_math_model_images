%%
% parameters:
clear ; clc ; 

fused_img_dir = '/Users/abhimanyudubey/Pictures/BIO MATH MODEL/Real_Images_Export/Fused_Img' ; 
export_dir =   '/Users/abhimanyudubey/Pictures/BIO MATH MODEL/Real_Images_Export/Noise_Removal';
filepath    =   '/Users/abhimanyudubey/Pictures/BIO MATH MODEL/Real_Images_Export' ; 
filenames   =   Import_all_files_in_a_folder('.tif' , filepath) ; 
filei       =   1 ; 

bw_sensitivity = 0.05 ; 
opening_radius = 1    ;

%% Preallocating:

islandSize  =  cell(length(filenames), 1) ; 
islandSize  =  cellfun(@(x) zeros(200 , 1) , islandSize , 'UniformOutput',false) ; 

%%

% Check If a parallel pool is alrady running:
if isempty(gcp("nocreate"))
    % If Not then Start a Parallel Pool
    parpool ; 
end

parfor filei = 1 : length(filenames)
    %%
    img     =   imadjust( imread(filenames{filei}) ) ; 
    img2    =   double(img) ; 
    % se = 2 * [1 , 1] ; 
    % img2 = wiener2(img , se) ;
    % figure(5) ; imshow(img2) ; 

    BW      =   imbinarize(img, 'adaptive', 'Sensitivity', ...
                bw_sensitivity, 'ForegroundPolarity', 'bright');
    
    % Open mask with disk
    radius = 1; decomposition = 0;
    se = strel('disk', opening_radius, decomposition);
    BW = imopen(BW, se);
    % figure(4) ; imshow(img) ; 
 
    % Clear borders
    BW = imclearborder(BW);
    
    % Fill holes
    BW = imfill(BW, 'holes');
    
    % Remove Noise From RAW Image:
    img(~BW) = 0 ;  % figure(6) ; imshow(img)

%     fusedImg = imfused(img2 , BW) ; 
    % Export The Images:
%     imwrite(img , fullfile( export_dir ,sprintf('Real_Img_%4.4i.png' ,filei) ))
%     imwrite(img , fullfile( export_dir ,sprintf('Fused_Img_%4.4i.png',filei) ))
    
    CC = bwconncomp(BW , 4) ; 
    CC.islandSize = cellfun(@length , CC.PixelIdxList)' ; 
    islandSize{filei} = CC.islandSize ; 

    %%
end

%%

clearvars -except islandSize CC; 



%%




