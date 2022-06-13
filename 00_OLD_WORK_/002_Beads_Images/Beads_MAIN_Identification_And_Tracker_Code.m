clc ; 
clear ; 

% Locate The Image Files:
saving_toggle       =   false ; 
import_directory    =   ['/Users/abhimanyudubey/Downloads/' ...
    '0009_0016_beads_images_256X256/Sharpened_Twice_And_Increased_Brightness']    ; 
export_directory    =   ['/Users/abhimanyudubey/Pictures' ...
    '/BIO MATH MODEL/Matlab_Export']   ; 

% Now we'll store the names of all the files in 
% this folder in filenames:
[~ , file_names] = Import_all_files_in_a_folder( ...
                   '.tif' , import_directory) ;             i = 1 ; 

% file_names = file_names(1:100) ; 

% Preallocating Memory For Dynamic Cell Array:
temp                            =       1500 ; 
islandSize_data                 =       cell( numel(file_names) , 1)  ; 
islandSize_data                 =       cellfun(@(x) zeros(temp , 1) , ...
                                        islandSize_data , 'UniformOutput', 0 ) ;
avgIslandIntensity_data         =       islandSize_data ; 
centroid_data                   =       cell( numel(file_names) , 1)  ; 
centroid_data                   =       cellfun(@(x) zeros(temp , 2) , ...
                                        centroid_data , 'UniformOutput', 0 ) ; 

timing_milisec                  =       zeros(length(file_names) , 1) ; 
num_islands                     =       timing_milisec ; 
% Check If a parallel pool is alrady running:
if isempty(gcp("nocreate"))
    % If Not then Start a Parallel Pool
    parpool ; 
end
 %
% count = [252 , 291 , 383 , 418 , 425 , 379 , 319 , 396 ]
% Main Parallel For Loop Over all the Image Files starts here:
tic
for i = 1 : numel(file_names)
    %%
%     img                         =       imsharpen(imadjust(imread(fullfile(import_directory , file_names{i}))) , ...
%                                         'radius' , 0.7 , 'amount' , 1.7)    ; 
tic
    img                         =      imadjust(imread(fullfile(import_directory , file_names{i}))) ; 
    img                         =       wiener2(img , 3 * [1 , 1]) ; 
    img                         =       imresize(img , 3 , "bicubic") ; 
    img                         =       padarray(img , [3,3] , 0) ; 
 
%     close all ; imshow(img , [] )
% % %  [img , BW] = cell_image_BW_preprocessor_4_BEADS(img , 
% % %      adaptive_thresh_toggle , BW_sensitivity  , opening_radius ) % , closing_radius)
    [img , BW]                  =       cell_image_BW_preprocessor_4_BEADS(img , false , 0.00 , 3 ) ;
    
% %     [ img  ,  BW  , CC ]    =   bio_watershed_segmentation_4_BEADS( img , BW , min_island_size , ...
% %     max_island_size , watershed_thresh )
    [img , ~ , CC]              =       bio_watershed_segmentation_4_BEADS(img , BW , 10 , 900 , 2.0)        ; 
    

% %     clc ; CC
% %     close all ; fig = figure(1) ; 
% %     imshow(img) ; hold on ; 
% %     plot(CC.centroid(: , 1) , CC.centroid(: , 2) , '.r' , 'LineWidth', 2 , 'markersize' , 10) ; hold off ; 
% %     title(sprintf('Showing %d Detected Cells',CC.NumObjects) , 'FontSize', 16)
% % % %     exportgraphics(fig , fullfile(export_directory,file_names{i}) ) ; 
% %     %%

%     islandSize_data{i}          =       CC.islandSize           ; 
%     centroid_data{i}            =       CC.centroid             ;
%     avgIslandIntensity_data{i}  =       CC.avgIslandIntensity   ;  

num_islands(i)                   =       CC.NumObjects ; 
timing_milisec(i)                =       1e3 * toc ;

end
t(1) = toc

clearvars -except num_islands timing_milisec ; 

%%
% Save Variables If Saving Toggle is On or True:
if saving_toggle 
    save(fullfile(export_directory , 'Relevant_Bio_Math_Tracking_Data') , ...
        "avgIslandIntensity_data" , "centroid_data" , "islandSize_data" , ...
        "import_directory" , "file_names") ; 
else
    fprintf(['\n\n\n\t\tYou Have Choosen NOT to Save The Centroid Data. ' ...
        '\n\n\t\tSince The Saving toggle is switched Off (or False).' ...
        '\n\n\t\tYou might want to turn it on (i.e saving_toggle = True) ' ...
        '\n\n\t\tIf you want to save your data in your HardDrive.\n\n\n\n'])
end

clearvars -except islandSize_data centroid_data avgIslandIntensity_data ...
    export_directory file_names import_directory t saving_toggle ; 
%%

% Now (a) Remove NearBy Particles 
%     (b) Make Tracking Input File, and 
%     (c) Track Your particles:
%     (d) Calculate Pixel Displacement:
tic
tracking_output = track( make_tracking_input_file_4BEADS(centroid_data , 1) , 0.1 ) ; 
xyuvt_data = calculate_dx_and_dy_from_tracking_output(tracking_output) ; 
t(2) = toc

% Save The Tracking Data:
% save(fullfile(export_directory , 'Tracker_Output.mat') , "tracking_output") ; 
% save("Tracker_Output.mat" , 'tracking_output') ; 

% Save xyuvt_data:
% save("xyuvtIdx_data.mat" , 'xyuvt_data') ;

% Save Variables If Saving Toggle is On or True:
if saving_toggle 
    % Saving Tracking Data:
    save(fullfile(export_directory , 'Tracker_Output.mat') , "tracking_output") ; 
    save("Tracker_Output.mat" , 'tracking_output') ; 
    
    % Saving XYUVT_DATA
    save(fullfile(export_directory , 'xyuvt_data') , ...
        "xyuvt_data") ; 
    save("xyuvtIdx_data.mat" , 'xyuvt_data') ;
end

disp('Percent Of Zero Pixels Measurements = ')
fprintf('\n') ; 
disp( sum( xyuvt_data(: , 3) == 0 & xyuvt_data(: , 4) == 0 )  / size(xyuvt_data , 1) * 100 ) ; 
clear t saving_toggle; 
%% Done: Be Happy :)



