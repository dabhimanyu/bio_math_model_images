function [sortedCentroids] = remove_nearBy_islands_4BEADS(centroid_data , ...
                                                max_pixel_displacement , percent_of_max_pixel_displacement )
% 
% This Function finds and removes the particles whos's  centres lies in 
% close proximity of each other. 
%
% Specifically it removes the particles who's centroids lie within a radius
% of maximum permissible percentage, ( Third Input To the Function ) 
% of the maximum displacement ( Second Input To the Function )
% 
% INPUTS:   
%   FIRST INPUT:     A 2-D matrix Which contains X-Y Coordinates of the
%                    particle's centroid. 
%
%   SECOND INPUT:    A 1-D Array Of Corresponding Particle Displacement
%
%   Third Input:     Maximum Permissible Displacemnt Of the particles. This
%   (OPTIONAL)       will be same as the maximum Displacemnt given for the
%                    Tracking Macro. It's Default Value will be 45.
%
%   Fourth Input:    Till What Percentage Of the Maximum Displacement 
%   (OPTIONAL)       particles needs to be removed. Default will be 105% 
%                    Percent.
%
%
%   OUTPUT:
%   sortedCentroids : The output will be the centroids of the particles
%                     after the near by particles has been removed. 
%                     The output will be sorted in the ascending 
%                     order of the X-Coordinates. 
%
%
%   EXAMPLE:
%   sortedCentroids = near_by_particle_remover(x , 50 , 105 ) ; 
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
    max_pixel_displacement                   =       002      ;   % 45 Pixels
    percent_of_max_pixel_displacement        =       105      ;   % 105% Of Max Particle Displacement
elseif nargin == 2
    percent_of_max_pixel_displacement        =       105      ;   % 105% Of Max Particle Displacement
elseif nargin < 1 || nargin > 3
    fprintf(' \n\n\t\t At-least 1 and At MAX, 3 Inputs Allowed  \n\n\t\t Dumbass ||-_-|| \n\n\t\t Check your Inputs First, Before calling me. \n\n\n' ) ; 
    return
end

%% Core Functionality Starts Here:

d                               =       ceil( 0.01 * percent_of_max_pixel_displacement *  max_pixel_displacement ) ; 

[~ , idx]                       =       sort(centroid_data(: , 1)) ; 
centroid_data                   =       centroid_data(idx , :)     ;
i                               =       0                          ;

while true
    i = i + 1   ;
    % End the loop If I is greater than the length of the matrix:
    if i > length( centroid_data(: , 1) )
        break
    end
    % [ xIdx , yIdx ]
    % Scan The Near By Coordinates:
    xIdx    =   ( (centroid_data(: , 1) >= centroid_data(i , 1) - d) & ( centroid_data(: , 1) <= centroid_data(i , 1) + d ) ) ;
    yIdx    =   ( (centroid_data(: , 2) >= centroid_data(i , 2) - d) & ( centroid_data(: , 2) <= centroid_data(i , 2) + d ) ) ;
    idx     =   find( xIdx & yIdx )   ;   
    idx( idx == i ) = [] ;  % You Don't Want The 'I_th' Index
    % Find Euclidean Distances From the Near By Particles:
    distances =  pdist2( centroid_data(idx , :) , centroid_data(i , :)  , 'euclidean')    ;
    % Check If Distances Are Less Than the Given Threshold:
    idx = idx( distances < d ) ; 
    % Remove The Corresponding Coordinates:
    centroid_data(idx , :) = [] ; 
end

% Final Output:
sortedCentroids = centroid_data  ; 

end