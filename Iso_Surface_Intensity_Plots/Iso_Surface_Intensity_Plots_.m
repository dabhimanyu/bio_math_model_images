
% close all ; 
clc ; 
clear ; 

export_tracking_Data =  ['/Users/abhimanyudubey/' ...
    'Pictures/BIO MATH MODEL/' ...
    '002_NEW_Exp movies/' ...
    '002_Iso_Surface_Intensity_Plots_'] ; 

%  Bounding Box Data:
x0       =      74  ; 
y0       =      36  ; 
width    =      83  ;   % In Pixels
height   =      83  ;   % In pixels


fileNames = Import_all_files_in_a_folder('tif' , export_tracking_Data) ; 

i   = 3 ; 
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
fig1 = figure(2) ; surf(chotuImg, EdgeColor="none"); 
colormap jet ; lighting gouraud ; shading interp ; axis on ; grid off ; 
set(gca, 'YGrid', 'off', 'XGrid', 'off' , 'ZGrid' , 'on') ; 
% daspect([1.1 0.5 0.7]) ; 
figure(2) ; hold on ; 
plot3(x , y , z , 'LineStyle','none' , ...
    Marker='o' , MarkerEdgeColor='b' , MarkerFaceColor='y')
% xlabel('X') ; ylabel('Y') ; zlabel('Intensities')
set(gca , 'YDir' , 'reverse' , 'xtick' , [] , 'yTick' , [] ) ; % , 'YLim' , [0,30]) ;
axis tight ; 
% view(-10 , 10) ; %
% camlight ; 
hold off ; 

fig2 = figure(3) ; 
imagesc(chotuImg) ; colormap jet ; 
axis off ;

fig3 = figure(4) ; 
imagesc(chotuImg) ; colormap gray ; 
axis off ; 
%%

[a , b , c] = fileparts(fileNames{i}) ; 
file_name_1 = fullfile(export_tracking_Data , ['a_' , b , '.png' ] ) ; 
file_name_2 = fullfile(export_tracking_Data , ['b_' , b , '.png' ] ) ; 
file_name_3 = fullfile(export_tracking_Data , ['c_' , b , '.png' ] ) ; 
exportgraphics(fig1 , file_name_1 , 'ContentType' , ...
               'image' , 'Resolution' , 300   ) ;  % , 'ContentType' , 'vector'
exportgraphics(fig2 , file_name_2 , 'ContentType' , ...
               'image' , 'Resolution' , 300   ) ; 

exportgraphics(fig3 , file_name_3 , 'ContentType' , ...
               'image' , 'Resolution' , 300   ) ; 
