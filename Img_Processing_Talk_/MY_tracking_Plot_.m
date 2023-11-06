%%
clear ; 
close all ; 
clc ; 

load("movie_2_Px_Data_.mat")

%
fig = figure(1) ; 
% t = tiledlayout(1,2) ; 

% nexttile ; 
% imshow(imresize(img1 , 2)) ; 

% nexttile ; 
imshow(imresize(img2 , 2)) ; 

% t.Padding = 'compact';
% t.TileSpacing = 'tight';
% title(t , 'Translated Images To Test Working Of Tracker' ,...
%     'fontsize' , 14 , 'fontweight' , 'bold') ; 

% ax3 = nexttile([1 2]) ; 
% stem(ax3 , track_Mate_X , track_Mate_Y , '-k' , 'LineWidth', 2) ; 
% hold on ; 
% stem(ax3 , code_X , code_Y , '-r' , 'LineWidth', 2) ; 
% hold off ; 
% set(ax3 , 'Xlim' , [1.5 , 4]  , 'YLim' , [0 , 3]) ; 


%%
pdf_file_name = 'Translated_Images2.pdf' ; 
exportgraphics(fig , pdf_file_name , 'ContentType' , ...
               'vector' , 'Resolution' , 1200   ) ;  % , 'ContentType' , 'vector'



%%
