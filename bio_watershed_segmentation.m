function [  img  ,  BW ]    =   bio_watershed_segmentation( img , min_island_size , ...
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
%   EXAMPLE: MODIFY THIS #####
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
    fprintf(' \n\n\t\t At-least 1 and At MAX, 4 Inputs were Allowed  \n\n\t\t Dumbass ||-_-|| \n\n\t\t Check your Inputs First, Before calling me. \n\n\n' ) ; 
    return
end


%% Binarize the Image:
% We'll first start by binarizing the images. We shall make use of Otsu's Algorithm for this.
        % Binarize the image:
        BW            =       imbinarize(img) ; 
        
%% Now Apply Watershed Segmentation:
% Watershed segmentation shall allow us to seperated the two connected segmentations. Now before sending the image 
% for watershed segmentation we need to ensure that there's minimise the amount of noise in the image. 
% Watershed segmentation is very sensitive to the amount of noise in the image. So what we'll do is once we have 
% identified the images, applied a size filter, we'll explicit assign all the reamining pixels zero values. 
%
% This will do two important things for us:
% 1. Reduce the overall noise in the figure. And, 
% 2. Eliminate the redundant data from the images, which will make the algorithm more robust.

% Preprocessing the binarized Mask:
        SE              =       strel('square' , 2)     ; % Square Structuring element
        BW              =       imopen(BW , SE )        ; % Morphologocal Opening Operation, will remove protrosions in the segmented islands
        BW              =       imfill(BW ,  'holes')   ; % Filling or Morphological closing will fill any hole inside the island
        BW              =       imclearborder(BW)       ; % Remove Border Pixels, or else it'll mess with the subsequent steps.

%% Remove all particles which are bigger than the specified limits: 
% i.e apply a size filter. 
        
        CC              =       bwconncomp(BW , 4) ; 
        CC.islandSize   =       cellfun(@numel , CC.PixelIdxList)' ; 

% % % % Visualizing island size distribution:
% %         [y , x]         =       histcounts(CC.islandSize , 'Normalization','probability')          ; 
% %         x               =       ( x(1:end-1) + x(2:end) ) / 2      ;
% %         figure(1) ; clf ; % histogram( CC.islandSize , 'Normalization','probability')          ; 
% %         plot(x , y , '-or' , 'linew' , 2)

% Determine the erroneous Islands:
        faltu_islands   =       find( (CC.islandSize < min_island_size) | (CC.islandSize > max_island_size) ) ; 

% Remove these islands from the Binarized Mask:         
        for i = 1 : length(faltu_islands)
            BW( CC.PixelIdxList{ faltu_islands(i) } ) = false ; 
        end

% Modify The Original Image Accordingly: 
        img(~BW)        =       0 ;

        d               =       bwdist(~BW) ;   % Calculating the distance matrix from the 
        d               =       imcomplement(d) ; 
%       d               =       imhmin(d , watershed_thresh) ; % Images had Very less amount of noise once they were sharpened twice in ImageJ
        particleSep     =       watershed(d) ; % NOTE that particleSep is a labelMatrix
        particleSep(~BW) = 0 ; 
        
%% Modify the Initial Segmentation Mask:
        BW              =       particleSep > 0 ;    % Binarizing Label Matrix
        img(~BW)        =       0  ;  
        img             =       reshape(img , size(img , 1) , [] )  ; 
   
%% DONE : Be Happy :-)


end
