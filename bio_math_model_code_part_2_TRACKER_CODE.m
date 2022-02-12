clc ; 
clear ; 

% Locate The Image Files:
saving_toggle       =   false ; 
import_directory    =   '/Users/abhimanyudubey/Pictures/BIO MATH MODEL/export copy'     ; 
export_directory    =   '/Users/abhimanyudubey/Pictures/BIO MATH MODEL/Matlab_Export'   ; 

% Now we'll store the names of all the files in this folder in filenames:
[~ , file_names] = Import_all_files_in_a_folder( ...
                   '.tif' , import_directory) ;    i = 1 ; 

% Preallocating Memory For Dynamic Cell Array:
temp                            =       1500 ; 
islandSize_data                 =       cell( numel(file_names) , 1)  ; 
islandSize_data                 =       cellfun(@(x) zeros(temp , 1) , ...
                                        islandSize_data , 'UniformOutput', 0 ) ;
avgIslandIntensity_data         =       islandSize_data ; 
centroid_data                   =       cell( numel(file_names) , 1)  ; 
centroid_data                   =       cellfun(@(x) zeros(temp , 2) , ...
                                        centroid_data , 'UniformOutput', 0 ) ; 

% Main Parallel For Loop Over all the Image Files starts here:
tic
parfor i = 1 : numel(file_names)
    img                         =       imadjust(imread(fullfile(import_directory , file_names{i})))    ; 
    [~ , ~ , CC]                =       bio_watershed_segmentation(img)     ; 
    islandSize_data{i}          =       CC.islandSize           ; 
    centroid_data{i}            =       CC.centroid             ;
    avgIslandIntensity_data{i}  =       CC.avgIslandIntensity   ;  
end
t(1) = toc

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

clearvars -except islandSize_data centroid_data avgIslandIntensity_data export_directory file_names import_directory

% Now (a) Remove NearBy Particles 
%     (b) Make Tracking Input File, and 
%     (c) Track Your particles:
tic
tracking_output = track( make_tracking_input_file(centroid_data , 2) , 1 ) ; 
t(2) = toc

% Save The Tracking Data:
save(fullfile(export_directory , 'Tracker_Output.mat') , "tracking_output") ; 

%% Done: Be Happy :)








