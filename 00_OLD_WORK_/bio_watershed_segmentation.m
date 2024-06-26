function [ img  ,  BW  , CC ]    =   bio_watershed_segmentation( img , min_island_size , ...
    max_island_size , watershed_thresh )
%
% This Function carries out the initial segmentation Of the TIRF Microscopy
% images and then applies the watershed segmentation to seperate
% the nearby Connected Components: 
%
% This allows us to segment out the nearby particles and there by eliminate the 
% error in determination of the centroids of the particles. 
% 
% The way this function had been written also makes it a bit robust to the noise 
% in the images. 
%
%   EXAMPLE: DUDE MODIFY THIS #####
%   [ BW_A , A_la ]    =   segmentation_watershed( A_la , watershed_thresh )
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
        
%% Default Inputs: 
if nargin == 1
        min_island_size     =   04  ; 
        max_island_size     =   50  ;
        watershed_thresh    =   01  ; 

elseif nargin == 2
        max_island_size     =   50  ;
        watershed_thresh    =   01  ; 

elseif nargin == 3
        watershed_thresh    =   01  ; 

elseif nargin < 1 || nargin > 4     % Giving a cranky touch to our function :)
    fprintf([' \n\n\t\t At-least 1 and At MAX, 4 Inputs were Allowed  ' ...
        '\n\n\t\t Dumbass ||-_-|| \n\n\t\t ' ...
        'Check your Inputs First, Before Distrubing me . \n\n\n'] ) ; 
    return
end

% NOTE: Use FIGURES() in the range of 50 to 100 :
    I2 = 400 : 510 ; 
    I1 = 350 : 400 ; 

% Binarize the Image:
% 
%         BW            =       imbinarize(img) ; 
%         figure(2) ; clf ; 
%         imshow(BW(I1 , I2)) ; 
% 
% Now Apply Watershed Segmentation:
% Watershed segmentation shall allow us to seperated the two connected segmentations. Now before sending the image 
% for watershed segmentation we need to ensure that there's minimise the amount of noise in the image. 
% Watershed segmentation is very sensitive to the amount of noise in the image. So what we'll do is once we have 
% identified the images, applied a size filter, we'll explicit assign all the reamining pixels zero values. 
%
% This will do two important things for us:
% 1. Reduce the overall noise in the figure. And, 
% 2. Eliminate the redundant data from the images, which will make the algorithm more robust.
% 
% Preprocessing the binarized Mask:
%         SE              =       strel('square' , 2)     ; % Square Structuring element
%         BW              =       imopen(BW , SE )        ; % Morphologocal Opening Operation, will remove protrosions in the segmented islands
%         figure(3) ; clf ; 
%         imshow(BW(I1 , I2)) ; 
%         
%         BW              =       imfill(BW ,  'holes')   ; % Filling or Morphological closing will fill any hole inside the island
%         BW              =       imclearborder(BW)       ; % Remove Border Pixels, or else it'll mess with the subsequent steps.


% i.e apply a size filter. 
% %         [img , BW]      =       cell_image_BW_preprocessor(img) ; 

% %     Parameters For Artificial Image:    
% % % % % cell_image_BW_preprocessor(img , 1 , 0.57 , 3)

        [img , BW]      =       cell_image_BW_preprocessor(img , 1 , 0.6 , 3) ;
% % 
% %         % %         figure(51) ; clf ; 
% %         imshow(img , []) ; 
% %         imshow(img(I1 , I2) , [])
% %         title('\fontsize{20}Image After Removal Of Noise')
% %         figure(52) ; clf ; 
% %         imshow(BW , []) ; 
% %         imshow(BW(I1 , I2) , []) ; 
% %         title('\fontsize{20}BW Corresponding to Figure 51')

        CC              =       bwconncomp(BW , 4) ; 
        CC.islandSize   =       cellfun(@numel , CC.PixelIdxList)' ; 

% % % % Visualizing island size distribution:
% %         [y , x]         =       histcounts(CC.islandSize , 'Normalization','cdf')          ; 
% %         x               =       ( x(1:end-1) + x(2:end) ) / 2      ;
% %         m = mean(CC.islandSize) ; s = std(CC.islandSize) ; 
% %         figure(99) ; clf ; % histogram( CC.islandSize , 'Normalization','probability')          ; 
% %         plot(x , y , '-or' , 'linew' , 2.2 , 'markersize' , 12) ; 
% %         title('Particle Size Distribution (CDF)') ; 
% %         xlabel('Particle Size (Area in Pixels)') ; 
% %         leg = { "Mean = " + num2str(m) + newline + "Std. Deviation = " + ...
% %             num2str(s) + newline + "Std = "+ num2str(s/m*100) + "% of mean. " } ; 
% %         legend(leg , 'location' , 'east') ; 
% %         set(gca , 'LineWidth' , 2.5 , 'FontSize' , 22 , ...
% %             'FontWeight' , 'bold' , 'GridAlpha' , 0.4 ) ; 

%% Remove all particles which are bigger than the specified limits: 

% Determine the erroneous Islands:
        faltu_islands   =       find( (CC.islandSize < min_island_size) | (CC.islandSize > max_island_size) ) ; 

% Remove these islands from the Binarized Mask and update CC accordingly:         
        for i = 1 : length(faltu_islands)
            BW( CC.PixelIdxList{ faltu_islands(i) } )   =   false   ; 
        end

% Modify The Original Image Accordingly: 
        img(~BW)        =       0 ;
        d               =       bwdist(~BW) ;   % Calculating the distance matrix from the 
% %         %%%% Visualize Distance Matrix:
% %         figure(53) ; clf ;
% %         imshow(d , [] ) ; 
% %         imshow(d(I1 , I2)) ; 
% %         imshow(d(I1 , I2) , [] ) ; 
% %         title('\fontsize{20} Distance Matrix (D)')

        d               =       imcomplement(d) ; 

% % %         %%%% Visualize the complement of distance matrix:
% % %         figure(54) ; clf ; 
% % %         imshow(d() , [] ) ;
% % %         imshow(d(I1 , I2) , [] ) ;
% % %         title('\fontsize{20} Complement Of Distance Matrix (D)')
% % % 
% % %         figure(55) ; clf ; surf(d)  ; 
% % %         figure(56) ; clf ; surf(d(I1 , I2))  ; shading interp ; 
% % %         colorbar(gca , "south"); 
% % %         title('\fontsize{20} Ridges And Valleys In Distance Matrix (D)')

if nargin == 4
        d               =       imhmin(d , watershed_thresh) ; % Images had Very less amount of noise once they were sharpened twice in ImageJ
end        
        particleSep     =       watershed(d) ; % NOTE that particleSep is a labelMatrix
        particleSep(~BW) = 0 ; 

%% Modify the Initial Segmentation Mask:

        BW              =       particleSep > 0 ;    % Binarizing Label Matrix
        img(~BW)        =       0  ;  
        img             =       reshape(img , size(img , 1) , [] )  ; 

% %         % Visualise Images After Watershed Segmentation: 
% %         figure(57) ; clf ; 
% %         imshow(img , []) ; 
% %         imshow(img(I1 , I2) , []) ; 
% %         title('\fontsize{20}Segmented Image Using Watershed Transformation')
% %         figure(58) ; clf ; 
% %         imshow(BW , []) ; 
% %         imshow(BW(I1 , I2) , []) ; 
% %         title('\fontsize{20} BW After Watershed Segmentation')
%% Calculating Size Of Islands:

        CC              =       bwconncomp(BW ,  4) ; 
        CC.islandSize   =       cellfun( @(x) numel(x) , CC.PixelIdxList )' ; 

%% Calculating the Coordinates Of the Centroid:

% Convert Linear Indicies to X-Y Subscripts:
[x , y] = cellfun( @(x) ind2sub(CC.ImageSize , x) , CC.PixelIdxList' , 'UniformOutput',0 ) ; 

% Find mean of each cell and concatenate the results:
CC.centroid = [ cellfun(@(x) mean(x) , y) , cellfun(@(x) mean(x) , x) ]  ; 

%% Calculate The Average Intensity Of each Island: 

% Original Images are uint16, convert them to uint8:
img_uint8 = uint8(img) ; 

% Now Index into this image, find the Intensity Values of all the pixels
% that belong to an insland, and then find it's mean: 
CC.avgIslandIntensity = cellfun( @(x) mean(img_uint8(x))  , CC.PixelIdxList' ) ; 

%% DONE : Be Happy :-)


end
