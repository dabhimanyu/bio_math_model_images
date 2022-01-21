%% Image Processing Of Bio Images:
%
% The images were sharpened twice in imageJ and then exported in 16 bit
% tiff format. Once the images were Sharpened twice, then it could be
% exported using " File -> Save As -> Image Sequence
% and then select the appropiate options to export the images:

% close all ; 
clc ; 
clear ; 

% Now locate the folder containing all the images and then extract their
% names: We'll use "uigetdir" to locate the import directory:
%       uigetdir
% import_directory = uigetdir     ;     

import_directory    =   '/Users/abhimanyudubey/Pictures/BIO MATH MODEL/export'  ; 

% Now we'll store the names of all the files in this folder in filenames:
[~ , file_names] = Import_all_files_in_a_folder('.tif' , import_directory) ; 

i = 1 ; 

% Now read the file and adjust the contrast :

for i = 1 : 10 % length(file_names)

    img = imadjust(imread(fullfile(import_directory , file_names{i}))) ; 
%     figure(1) ; clf ; imshow(img) ; 
    [img , BW] = bio_watershed_segmentation(img) ; 
%     figure(2) ; clf ; imshow(img) ; 
%     figure(3) ; clf ; imshow(BW)  ; 
%     imwrite(img , fullfile(import_directory , sprintf('Abhimanyu_export_img_%5.5iyModified.tif' , i-1) ) ) ;
    imwrite( BW , fullfile(import_directory , sprintf('Abhimanyu_export_img_%5.5itModified.tif' , i-1) ) ) ;
    
% Locate the centroid:
    CC  =   bwconncomp(BW , 4) ; 
    CC.islandSize = cellfun(@length , CC.PixelIdxList).' ; 
    island_props = regionprops('table' , CC , 'Centroid') ; 
%     figure(1) ; imshow(BW) ; hold on ; 
%     plot(island_props.Centroid(: , 1) , island_props.Centroid(: , 2) , 'm*') ; 
%     exportgraphics(gca ,  ...
%         fullfile(import_directory , sprintf('Abhimanyu_export_img_%5.5ixModified.png' , i-1) ) ,...
%         'ContentType' , 'auto' , 'Resolution' , 300 ) ;
end
%%





