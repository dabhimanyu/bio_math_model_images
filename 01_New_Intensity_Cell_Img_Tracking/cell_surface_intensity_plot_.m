%% Goal Is to generate Surface Intensity Plots for some selected cell Images:
% Why do we want to do this ?
% Reason: Our intensity vs time plot shows a sudden drop in intensities valves 
% for some particles. Such plots will help us to visualize the insinsities
% vales as the height in the surface plots, thereby help us visualize it
% better. :

% Data For 2767:
% Particle Number: 73
% Frame Number: 580-600

%% NOTE: 
% Run "Cell_Tracking_n_Intensity_.m" and
% "intensity_as_a_fcn_of_time" before running this :
% Get Relevent variables from there and then run this:

close all ; clc ; 
clearvars -except real_cell_img_tracker_export_dir onlyFilenames centroid_data ...
    mean_intensity_data fileNames intensity_Matrix ;

export_tracking_Data =  ['/Users/' ...
    'abhimanyudubey/Pictures/' ...
    'BIO MATH MODEL/002_NEW_Exp movies/' ...
    '001_First_Trial_zTracking_Export_'] ; 

%  Bounding Box Data:
width    =      40  ;   % In Pixels
height   =      50  ;   % In pixels
x0       =      161 ; 
y0       =      65  ; 


i   = 580 ; 
img = 255 * rescale( imread(fileNames{i}) ) ;
BW  = imregionalmax(img , 4) ; 
% Correxting for indicies larger than image size:
if ( (y0 + height) > size(img , 1) ) 
    rowi =  y0 : size(img , 1) ; 
else
    rowi =  y0 : y0 + height   ; 
end

if ( (x0 + width) > size(img , 2) ) 
    coli =  x0 : size(img , 2) ; 
else
    coli =  x0 : x0 + width  ;  
end

i = 600 ; 
c = centroid_data{1} ; 
particle_id = 73 ; 
par_intensity = intensity_Matrix(particle_id , :) ; 
[iMin , iMax] = bounds(par_intensity) ; 

img = 255 * rescale( imread(fileNames{i}) ) ;
chotuImg = img(rowi , coli) ;
BWchotu  = BW( rowi , coli) ;

peak_idx = 1 : 3 ; 
[y , x]  = find(BWchotu) ; 
z = chotuImg(BWchotu) ; 
[z , idx] = sort(z , 'descend') ; 

z = z(peak_idx) ; 
y = y(idx(peak_idx)) ; 
x = x(idx(peak_idx)) ;

% Planar Visualization:
% % fig = figure(1) ; imagesc(chotuImg) ; colormap gray ; % or jet
% % axis xy ; 
% % xlabel('X') ; ylabel('Y')
% % hold on ; 
% % plot(c(particle_id , 1) - x0 , c(particle_id , 2) - y0  , 'or' ,...
% %     'LineWidth', 2 , 'MarkerSize', 15) ; 
% % hold off ; 


% 3-D Visual:
fig = figure(2) ; surf(chotuImg, EdgeColor="none"); 
colormap jet ; lighting gouraud ; shading interp ; axis on ; grid off ; 
set(gca, 'YGrid', 'off', 'XGrid', 'off' , 'ZGrid' , 'on') ; 
daspect([1.1 0.5 0.7]) ; 
figure(2) ; hold on ; 
plot3(x , y , z , 'LineStyle','none' , ...
    Marker='o' , MarkerEdgeColor='b' , MarkerFaceColor='y')
% xlabel('X') ; ylabel('Y') ; zlabel('Intensities')
set(gca , 'YDir' , 'reverse' , 'xtick' , [] , 'yTick' , [] , 'YLim' , [0,30]) ;
axis tight ; 
view(-10 , 10) ; %camlight ; 
hold off ; 

%%
pj = sprintf('Surface_Intensity_4_Figure_%5.5i.png' , i) ; 
pdf_file_name = fullfile(export_tracking_Data , pj) ; 
exportgraphics(fig , pdf_file_name , 'ContentType' , ...
               'image' , 'Resolution' , 300   ) ;  % , 'ContentType' , 'vector'
% hold on ; 
% plot3(c(particle_id , 1) , c(particle_id , 2) , img(c(particle_id , 2) , c(particle_id , 1)) , 'ok') ; hold off ; 
% set(gca , 'zlim' , [0 , ceil(iMax)]) ; 








































