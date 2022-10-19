%% Tracking Of Cells:
clear ; 
% close all ; 
clc ; 

% Now (a) Remove NearBy Particles 
%     (b) Make Tracking Input File, and 
%     (c) Track Your particles:
%     (d) Calculate Pixel Displacement:

% Import Centroid Data:
filepath_centroid = ['/Users/abhimanyudubey/Pictures/' ...
    'BIO MATH MODEL/001_Real_Img_via_' ...
    'reg_max_/004_Matlab_Edited_Images_'] ; 

inspection_filepath = ['/Users/abhimanyudubey/' ...
    'Pictures/BIO MATH MODEL/001_Real_Img_via_reg_max_/' ...
    '005_Matlab_Tracker_Inspection_Export_'] ; 

export_tracking_Data =  ['/Users/' ...
    'abhimanyudubey/Pictures/' ...
    'BIO MATH MODEL/001_Real_Img_via_reg_max_' ...
    '/004_Matlab_Edited_Images_'] ; 

[fileNames , ~] = Import_all_files_in_a_folder( ...
    '.mat' , filepath_centroid) ; 
load(fileNames{1}) ; 

% idx = [ 11:20 , 101:110 , 301:320 , 451:460 ] ; 
% centroid_data = centroid_data(idx) ; 

% Skip Certain Number Of Frames:
num_of_frames_2_skip = 1 ; 
centroid_data = centroid_data(1:num_of_frames_2_skip:end) ; 
onlyFilenames = onlyFilenames(1:num_of_frames_2_skip:end) ; 

tic
max_disp                     =      5.1   ; 
tracking_output              =      track( make_tracking_input_file( centroid_data ) , max_disp * 1 ) ; 
[ xyuvt_data , T , p_dist]   =      calculate_dx_and_dy_from_tracking_output_002(...
    tracking_output , num_of_frames_2_skip) ; 
t(2) = toc

% tracking_output(: , 3) = tracking_output(: , 3) + idx(1) - 1 ; 
% [~ , idx] = sort(tracking_output(: , 3)) ; 
% tracking_output = tracking_output(idx , :) ; 
% clear idx ; 

u_tracks = length(unique(tracking_output(: , 4)))


% % % T = table ; 
% % % T.X_Coordinate = tracking_output(: , 1) ; 
% % % T.Y_Coordinate = tracking_output(: , 2) ; 
% % % T.Frame_Number = tracking_output(: , 3) ; 
% % % T.Particle_ID  = tracking_output(: , 4) ; 

% Export Data:

writetable(T , fullfile(export_tracking_Data , sprintf(...
    'Skip_%4.4i_Frames_tracking_output_Max_Disp_%3.2f_Px_%4.4i_Unique_Tracks_.csv' , num_of_frames_2_skip , max_disp, u_tracks ) ) ) ; 

save(fullfile(export_tracking_Data , sprintf(...
    'Skip_%4.4i_Frames_tracking_output_Max_Disp_%3.2f_Px_%4.4i_Unique_Tracks_.mat' , num_of_frames_2_skip , max_disp, u_tracks )) , ...
    "centroid_data" , "onlyFilenames" , "tracking_output" , "xyuvt_data" , "T" , "max_disp" , ...
    'num_of_frames_2_skip' ,"p_dist" , '-mat') ; 


%% Inspecting Tracking Output:

% % raw_img_filepath = ['/Users/abhimanyudubey/Pictures/B' ...
% %     'IO MATH MODEL/001_Real_Img_via_reg_max_/' ...
% %     '002_Raw_Images_From_Video_'] ; 
% % 
% % [fileNames , onlyFilenames] = Import_all_files_in_a_folder( ...
% %     '.tif' , raw_img_filepath) ; 
% % 
% % unique_idx = unique(tracking_output(: , 3)) ; 
% % 
% % for i = 1 : length(unique_idx)
% %     img     =   imread(fileNames{unique_idx(i)}) ; 
% %     idx     =   find(tracking_output(: , 3) == unique_idx(i))  ;
% %     c       =   tracking_output(idx , 1:2) ; 
% %     cell_id =   tracking_output(idx , 4) ; 
% %     numId = 1 : 2 : 40 ; 
% %     insp_img = insertText(img , c(numId , :) , cell_id(numId) , ...
% %         'AnchorPoint' , 'Center' , 'fontsize' , 7 ) ; 
% %     imwrite(insp_img , fullfile(inspection_filepath , ...
% %         onlyFilenames{unique_idx(i)})) ;
% % end
% % 

%%











