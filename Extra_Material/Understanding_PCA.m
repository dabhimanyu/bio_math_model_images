%% PCA Intution And It's Relation To Quadratic Surfaces:

% data
a = 1 ; 
b = 0.4 ; 
x = [ a*randn(1000,1) b*randn(1000,1) ];

% rotation matrix
th = pi/4;
R1 = [ cos(th) -sin(th); sin(th) cos(th) ];

% rotate data to induce correlation
y = x*R1;


% plot the data in a scatter plot
figure(1), clf ; 
set( gca , 'LineWidth' , 2 , 'fontsize' , 22 , 'fontweight' , 'bold'  , 'GridAlpha' , 0.4 ) ;   
subplot(131)
plot(y(:,1),y(:,2),'m.','markersize',17)

% make the plot look nicer
set(gca,'xlim',[-1 1]*max(y(:)),'ylim',[-1 1]*max(y(:)))
xlabel('x-axis'), ylabel('y-axis')
axis square
set( gca , 'LineWidth' , 2 , 'fontsize' , 22 , 'fontweight' , 'bold'  , 'GridAlpha' , 0.4 ) ;  

% PCA via eigendecomposition

% mean-center
y = y - mean(y,1);

% covariance matrix
covmat = y'*y / (length(y)-1);

% eigendecomposition
[evecs,evals] = eig(covmat);


% plot the eigenvectors on the data
hold on
plot([0 evecs(1,1)]*evals(1),[0 evecs(2,1)]*evals(1),'k','linew',3)
plot([0 evecs(1,2)]*evals(end),[0 evecs(2,2)]*evals(end),'k','linew',3)


% show the covariance matrix
subplot(132)
imagesc(covmat), axis square
set(gca,'clim',[-1 1],'xtick',1:2,'ytick',1:2)
xlabel('Channels'), ylabel('Channels')
set( gca , 'LineWidth' , 2 , 'fontsize' , 22 , 'fontweight' , 'bold'  , 'GridAlpha' , 0.4 ) ;  

% compute quadratic form

% weights along each dimension
xi = -2:.1:2;

quadform = zeros(length(xi));
for i=1:length(xi)
    for j=1:length(xi)
        
        % define vector
        x = [xi(i) xi(j)]';
        
        % QF
        quadform(i,j) = x'*covmat*x / (x'*x);
    end
end


% fill in missing point with 0
quadform(~isfinite(quadform)) = 0;

% visualize the quadratic form surface

subplot(133)
surf(xi,xi,quadform'), shading interp
xlabel('W1'), ylabel('W2'), zlabel('energy')
rotate3d on, axis square

% and the eigenvectors
hold on
plot3([0 evecs(1,1)]*2,[0 evecs(2,1)]*2,[1 1]*max(quadform(:)),'k','linew',6)
plot3([0 evecs(1,2)]*2,[0 evecs(2,2)]*2,[1 1]*max(quadform(:)),'m','linew',6)

set( gca , 'LineWidth' , 2 , 'fontsize' , 22 , 'fontweight' , 'bold'  , 'GridAlpha' , 0.4 ) ;  



%% 

% a clear MATLAB workspace is a clear mental workspace
% close all; 
clear, clc

% simulate data with covariance structure

% simulation parameters
N = 1000;     % time points
M =   20;     % channels
nTrials = 50; % number of trials

% time vector (radian units)
t = linspace(0,6*pi,N);


% relationship across channels (imposing covariance)
chanrel = sin(linspace(0,2*pi,M))';

% Adjust The Noise, And Simulate the data:
data    = bsxfun(@times,repmat( sin(t),M,1 ),chanrel) + 1 * randn(M,N);

% Mean-Centre Your Data:
dataM = data - mean(data , 2) ; 

% Compute the Covariance Matrix:
covmat = data * data' / ( N - 1) ; 

% Eigendecompose the Covariance Matrix:
[evecs , evals] = eig(covmat) ; 

% Sort The eigen values: 
[evals , idx]   = sort( diag(evals) , 'descend') ; 

evecs = evecs(: , idx) ; 
evals = diag(evals) ; 

% step 4: compute component time series
r = 2; % two components
comp_time_series = evecs(: , 1:r)' * data ; 


figure(2) ; clf ; 

subplot(2 , 3 , 1) ; 
plot(diag(evals) , '-s' , 'linew' , 2 , 'markersize' , 12) ;
xlabel('Component Number' , 'FontSize' , 22 , 'FontWeight', 'bold')
ylabel('\lambda' , 'FontSize', 22 , 'FontWeight','bold')
set(gca , 'LineWidth' , 2.5 , 'FontSize' , 22 , 'FontWeight' , 'bold' , 'GridAlpha' , 0.4)

subplot(232) ; 
plot(evecs(: , 1:2) , '-s' , 'LineWidth', 2 , 'markersize' , 12) ; 
xlabel('Channel' , 'FontSize', 22 , 'FontWeight','bold') ; 
ylabel('PC Weight' , 'FontSize' , 22 , 'FontWeight','bold') ; 
set(gca , 'LineWidth' , 2.5 , 'FontSize' , 22 , 'fontweight' , 'Bold' , 'gridalpha' , 0.4 ) ; 

subplot(2 , 3 , 4:6)
plot(comp_time_series' , 'LineWidth',1.5)
xlabel('Time' , 'FontSize', 22 , 'FontWeight','bold') ; 
ylabel('Activity' , 'FontSize', 22 , 'FontWeight','bold') ; 
set(gca , 'LineWidth' , 2.5 , 'FontSize' , 22 , 'FontWeight' , 'bold' , 'GridAlpha' , 0.4)

subplot(233) ; 
plot(evecs(: , 1) , '-s' , 'LineWidth', 2 , 'markersize' , 12) ; 
ylabel('Channel Mapping' , 'FontSize', 22 , 'FontWeight','bold') ; 
xlabel('Channel' , 'FontSize' , 22 , 'FontWeight','bold') ; 
set(gca , 'LineWidth' , 2.5 , 'FontSize' , 22 , 'fontweight' , 'Bold' , 'gridalpha' , 0.4 ) ; 


%%



