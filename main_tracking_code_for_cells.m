%% Tracking Of Cells:
clear ; 
% close all ; 
clc ; 

% Now (a) Remove NearBy Particles 
%     (b) Make Tracking Input File, and 
%     (c) Track Your particles:
%     (d) Calculate Pixel Displacement:

% NOTE to self: STOP BEING LAZY ||-_-|| 
% and create a seperate Input Text file which
% contains all these Import and export directories. Then create a function
% which takes complete file path of the textfile as Input, and returns a
% single structure or class object which contains all this data
% Then repleace all this dump of code with that single function call.


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

% Import Centroid Data For Tracker:
[fileNames , ~] = Import_all_files_in_a_folder( ...
    '.mat' , filepath_centroid) ; 
load(fileNames{1}) ; 

% idx = [ 11:20 , 101:110 , 301:320 , 451:460 ] ; 
% centroid_data = centroid_data(idx) ; 

% Skip Certain Number Of Frames:
% Goal Is To Check If Tracker gives consistent results or not if
% num_of_frames_2_skip are skipped. 1 means no image is being skipped
num_of_frames_2_skip = 1 ; 
centroid_data = centroid_data(1:num_of_frames_2_skip:end) ; 
onlyFilenames = onlyFilenames(1:num_of_frames_2_skip:end) ; 

tic
% Linking Distance For The Tracker
max_disp                     =      5.1   ; 

% Create An Input File for the tracker, and send it through the tracker
tracking_output              =      track( make_tracking_input_file( centroid_data ) , max_disp * 1 ) ; 

% Calculate Delta_X (dx) and Delta_Y (dy) from the tracking output
[ xyuvt_data , T , p_dist]   =      calculate_dx_and_dy_from_tracking_output_002(...
    tracking_output , num_of_frames_2_skip) ; 

% Total Time required to do the tracking the calculate the distances
% covered by the islands:
t(2) = toc

% Sort Tracking Output as Increasing X-Coordinate
% tracking_output(: , 3) = tracking_output(: , 3) + idx(1) - 1 ; 
% [~ , idx] = sort(tracking_output(: , 3)) ; 
% tracking_output = tracking_output(idx , :) ; 
% clear idx ; 

% Number Of Unique Tracks Identified by the tracker:
u_tracks = length(unique(tracking_output(: , 4)))

% Now The Function Itself Returns T:
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

%  Done...!!

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











