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
filepath_centroid = ['/Users/' ...
    'abhimanyudubey/' ...
    'Pictures/BIO MATH MODEL/' ...
    '002_NEW_Exp movies/' ...
    '001_First_Trial_Export_'] ; 

inspection_filepath = ['/Users/' ...
    'abhimanyudubey/Pictures/' ...
    'BIO MATH MODEL/' ...
    '002_NEW_Exp movies/001_zInspection_'] ; 

export_tracking_Data =  ['/Users/' ...
    'abhimanyudubey/Pictures/' ...
    'BIO MATH MODEL/002_NEW_Exp movies/' ...
    '001_First_Trial_zTracking_Export_'] ; 

% Import Centroid Data For Tracker:
[fileNames , ~] = Import_all_files_in_a_folder( ...
    '.mat' , filepath_centroid) ; 
load(fileNames{1}) ; 

c = floor( centroid_data{1} ) ; 

% Create a cell array which contains temp number of cells
temp = 500 ; 
mean_intensity_data             =       cell( numel(fileNames) , 1)  ; 
mean_intensity_data             =       cellfun(@(x) zeros(temp , 1) , ...
                                        mean_intensity_data , 'UniformOutput', 0 ) ;

intensity_Matrix                =       zeros(length(c(: , 1)) ,...
                                              length(fileNames) ) ; 

i = 1 ; 
%
tic

parfor i = 1 : length(fileNames)

    img                     =       imread(fileNames{i}) ;   % imshow(imresize(img , 8))
    I                       =       mean_intensity_calculator_2(img , c) / (65535) ;  % c -> Floor of centroid data
    mean_intensity_data{i}  =       I ; 
    intensity_Matrix(: , i) =       I ; 
end

t(1) = toc

% Scale Intensities B/t 0-255
intensity_Matrix = (intensity_Matrix * 255 ) ; 

%% Ploting Intensity as a function of time:
clearvars -except intensity_Matrix export_tracking_Data

close all ;
i = 73 ;  
fig = figure(1) ; clf ; 
t = tiledlayout(2,1 , 'TileSpacing','compact' , Padding='compact') ; 
nexttile
data = intensity_Matrix( i , :).' ; 
data_smooth = smoothdata(data , 'gaussian' , 5) ; 
plot( data , '-k' , LineWidth=1.5) ; % , 'LineWidth', 2) ; hold on ; 
Title_1 = sprintf('Particle %2i, Intensities vs Time Plot', i) ; 
title(Title_1 , 'FontSize',14) ; 
% set(gca , 'Ylim' , [0,105]) ; 

nexttile ; 
plot(data_smooth , '-r' , LineWidth=1.5) ; 
Title_1 = sprintf('Particle %2i, Moving Gaussian Filtered Intensities', i) ; 
title(Title_1 , 'FontSize',14) ; 
% set(gca , 'Ylim' , [0,105]) ; 

%%
for i = 1 : numel(intensity_Matrix(:,1))

    data = intensity_Matrix( i , :).' ; 
    data_smooth = smoothdata(data , 'gaussian' , 5) ;

    % Change YData For RAW Intensities:
    t.Children(2).Children.YData = data ; 

    % Change YData For Smoothed Intensities:
    t.Children(1).Children.YData = data_smooth ;

    % Change Title For RAW Intensities:
    t.Children(2).Title.String = ...
        sprintf('Particle %2i, Intensities vs Time Plot', i) ; 

    % Change Title For Smoothed Intensities:
    t.Children(1).Title.String = ...
        sprintf('Particle %2i, Moving Gaussian Filtered Intensities', i) ;

    % Generate FileName:
    pj = sprintf('%3.3i_Intensity_vs_time_plot_for_Particle_Number_%3.3i.pdf' , i,i ) ; 
    pdf_file_name = fullfile(export_tracking_Data , pj) ; 

    % Export PDF:
    exportgraphics(fig , pdf_file_name , 'ContentType' , ...
               'vector' , 'Resolution' , 1200   ) ;  % , 'ContentType' , 'vector'

end

writematrix(intensity_Matrix , 'mean_Intensity_Data_Matrix.csv') ; 
%% Print Particle-Id On Particle Image:

% % img = imread(fileNames{1}) ; 
% % par_idx = 1 : size(c , 1) ; 
% % idx = 71:73 ; 
% % close all ; figure(1) ; clf ; 
% % img_with_text = insertText(img , c(idx , :) , par_idx(idx) , ...
% %     'AnchorPoint' , 'Center' , 'fontsize' , 8 , 'BoxOpacity',0 , ...
% %     'TextColor','red') ;
% % 
% % img_with_text = imresize(img_with_text , 10) ; 
% % imshow(img_with_text) ; 
% % 
% % imwrite(img_with_text , 'img_08' , 'png')

%%
















