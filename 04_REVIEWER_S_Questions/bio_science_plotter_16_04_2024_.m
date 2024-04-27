%%
clear ; 
clc ; 
% close all ; 

filepath = ['/Users/abhimanyudubey/' ...
    'Pictures/BIO MATH MODEL/001_Real_Img_via_reg_max_/' ...
    '004_Matlab_Edited_Images_'] ; 

[fileNames , onlyFilenames] = Import_all_files_in_a_folder('.mat' , filepath , ...
    'Skip_0001_*.mat') ; 

% % idx             =   1 : 7 ; 
% % fileNames       =   fileNames(idx) ; 
% % onlyFilenames   =   onlyFilenames(idx) ; 

x_data = cell(numel(fileNames) , 1) ; 
leg    = x_data; 
y_data = x_data ; 

dist_data = table ; 

dist_data.mean          = zeros(numel(fileNames) , 1 ) ; 
dist_data.std           = zeros(numel(fileNames) , 1 ) ;
dist_data.median        = zeros(numel(fileNames) , 1 ) ; 
dist_data.unique_tracks = zeros(numel(fileNames) , 1 ) ; 
dist_data.max_disp      = zeros(numel(fileNames) , 1 ) ; 

i = 1 ;  

temp_var = 1 : length(onlyFilenames) ; 
% temp_var = 1 : 4 ; 

for i = temp_var

    % Load The Files:
    load(fileNames{i})  ; 
    u_tracks = length(unique(T.Particle_ID)) ;
    pj = T.Distance_Pixel  ; % ./ u_tracks ; 

    % Eliminate Zero Distances:
    pj( pj == 0 ) = [] ; 

%     % Average Distance Covered By Each Unique Particle:
%     y = p_dist.mean_dist ; 
%     y(y == 0) = [] ; 
%     x = 1 : length(y) ; 
    
    dist_data.mean(i)           =   mean(pj) ; 
    dist_data.std(i)            =   std(pj) ; 
    dist_data.median(i)         =   median(pj) ; 
    dist_data.unique_tracks(i)  =   u_tracks ; 
    dist_data.max_disp(i)       =   max_disp ; 

    % % % Create Distribution Of Distances:
    [y , x] = histcounts(pj , 300 , 'Normalization','pdf') ; 
    x = (x(1:end-1) + x(2:end)) / 2 ; 

    % Store The Data:
    x_data{i} = x.' ; 
    y_data{i} = y.' ;

    % Create The Legend:
    leg{i} = sprintf(["Max Disp = %3.2f , U-Trk = %4.4i , Mean = %5.5f , " + ...
        "Std = %5.5f , Median = %5.5f" ],...
        dist_data.max_disp(i) , dist_data.unique_tracks(i)  , dist_data.mean(i)  , ...
        dist_data.std(i) , dist_data.median(i) ) ; 
end

% Plot The Data:

clearvars -except T  x_data y_data dist_data leg filepath temp_var; 
    
fig = figure(1)  ; clf; 

for i = temp_var % numel(x_data)
    plot( x_data{i} , y_data{i} , 'LineWidth', 1.5) ; hold on ; 
end

% set(gca , 'xlim' , [1.36 , 1.46]) ; 
xlabel('Distance Covered (Px)') ; 
ylabel("PDF Of Distance Covered") ; 

set(gca , 'FontSize' , 16 , 'FontWeight', 'bold') ; 
title('Distribution Of Distances')

legend(leg , 'location' , 'best' , 'fontsize' , 13.5 , 'NumColumns', 1) ; 

hold off ; 

%% Export The Figure ; 

fig_file_name = '0001_Distribution_Of_Distance_.pdf' ; 
exportgraphics(fig , fullfile(filepath , fig_file_name) , 'ContentType' , ...
               'vector' , 'Resolution' , 300   ) ;  


mat_fig_filename = "Fig_Distribution_File" ; 
savefig(fig , fullfile(filepath , mat_fig_filename)  )  ; 

%%














































