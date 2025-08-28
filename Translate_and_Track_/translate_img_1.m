close all ; 
clear ; 
clc ; 

% Turn on video file toggle in case you want to 
video_file_toggle = false ; 
% % 9053 FilePath:
% filepath = ['/Users/abhimanyudubey' ...
%     '/Pictures/BIO MATH MODEL/001_Real_Img_via_' ...
%     'reg_max_/006_Raw_Img_From_9053_Video_'] ; 

% CRITICAL: Kindly check the filepaths carefully before running the code
% In my experience, these are the most common mistake that people do while 
% running these codes

% filepath = fullfile(['/Users/abhimanyudubey/Pictures/BIO MATH MODEL/' ...
%     '001_Real_Img_via_reg_max_/008_Translate_and_' ...
%     'Track_/009_Images_For_5_New_Movie']) ; 

filepath = fullfile(['/Users/abhimanyudubey/MATLAB-Drive/CRAP/' ...
    'bio_math_model_images/Translate_and_Track_/' ...
    '001_Input_sample_images_to_test_tracking_algo_']) ; 

% Output Directory:
output_dir = fullfile(['/Users/abhimanyudubey/MATLAB-Drive/CRAP/' ...
    'bio_math_model_images/Translate_and_Track_/' ...
    'OutPut_Directory_For_Translated_Images_']) ; 

% Get all filenames:
[input_filenames , onlyFilenames] = ...
    Import_all_files_in_a_folder('.png' , filepath) ; 

% Extract filepath , filenames , and file extension :

% We'll be making use of the first file here for our purposes and use it
% it for creating translated images. 
img_num = 1 ; 
img = imread(input_filenames{img_num}) ;  % imshow(img , [])
[~ , iName , iext] = fileparts(input_filenames{img_num}) ; clear img_num  ; 

% Decide The Distance Moved: dx and dy tells it the amount of translation
% in x and y directions respectively. Both distances are in pixels
% CRITICAL: Avoid giving it less than one pixel values or else you'll get
% into the realm of "subpixel uncertainities" for the lack of better word.

% amount of translation in x and y directions (in Pixels):
% In case you need real distance travelled, multiply these pixel values
% with an appropiate calibration factor with like a factor in microns per
% pixel, to get real distance travelled. It depends on your imaging system.
dx = 1.5 ; dy = 1.5 ; 

% Evaluating L2 Norm (Eucledian Norm), which gives us the amount of
% distance travelled as per these given values:
dist_moved = sqrt(dx^2 + dy^2) ; 

% Decide The Number Of Images In the Series:
num_of_images = 100 ; 

% initializing i to check the individual loop iterations:
i = 1 ; 

%  NOTE: You can test a part of the code by butting them in between these
%  "%%" double "percentage" sign and then pressing "control + enter" or 
%  "Command+enter" to run just that part of the code in matlab. For example
%  here I was testing the code by splitting it into two parts. First part
%  initializes the variables and the second part just tests the working of
%  the code. The double "%%" sign within the contents of the loop tests if
%  each intividual iteration is working correctly or not. Loop variable "i"
%  was initialized above so that I don't get any error when I press
%  "control enter" to test an individual iteration of the code. 

%%

% Translate the Images and Export Them:
for i = 1 : num_of_images

    %%
    dist_moved = 1 * sqrt(dx^2 + dy^2) ; 
    t_img = imtranslate(img , i .* [dx , dy] , 'nearest' , FillValues=0) ; 
    fName = sprintf('%s_dx_%2.2f_dy_%2.2f_distance_%4.4f_ImgNum_%4.4i_%s' , ...
        iName , dx , dy , dist_moved , i , iext) ;
    imwrite(t_img , fullfile(output_dir , fName)) ; 

    %%
end


% Create a VideoFile:

if video_file_toggle
    % Construct a VideoWriter object, which creates a 
    % Motion-JPEG AVI file by default.
    vid_file_name = sprintf('Cell_Video_dx_%3.2f_dy_%3.2f_distance_%4.2f_.avi' , dx, dy , dist_moved) ; 
    outputVideo = VideoWriter(fullfile(output_dir , vid_file_name))  ; 
    %     sprintf('Cells_Translation_video_DistTranslated_%4.4f.avi' , dist_moved) ) ) ;
    
    % Adjust Video Frames per second
    outputVideo.FrameRate = 10 ;
    
    % Create Video Object Constructor:
    open(outputVideo) ; 
    
    
    % Extract The Image File Names:
    imgFileNames = Import_all_files_in_a_folder('.png' , output_dir) ; 
    
    % Loop through the image sequence, 
    % load each image, and 
    % then write it to the video.
    
    for i = 1 : length(imgFileNames)
        img = rescale(double(imread(imgFileNames{i})) ); 
        writeVideo(outputVideo , img) ; 
    end
    
    % Destruct Video Object:
    close(outputVideo)

end

%%


















