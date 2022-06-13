%% Understanding Dimensionality Reduction Using EEG Data:

%  set(0 , 'defaultfigurewindowstyle' , 'docked')
%  set(groot,'DefaultFigureColormap',jet)

% close all; 
clear, clc

%% Using Simulated EEG data

% mat file containing EEG, leadfield and channel locations
load emptyEEG

% index of dipole to simulate activity in
diploc = 109;


% plot brain dipoles
figure(1), clf, subplot(121)
plot3(lf.GridLoc(:,1), lf.GridLoc(:,2), lf.GridLoc(:,3), 'bo','markerfacecolor','y')
hold on
plot3(lf.GridLoc(diploc,1), lf.GridLoc(diploc,2), lf.GridLoc(diploc,3), 'rs','markerfacecolor','k','markersize',10)
rotate3d on, axis square
title('Brain dipole locations')
set( gca , 'LineWidth' , 2.5 , 'fontsize' , 22 , 'fontweight' , 'bold'  , 'GridAlpha' , 0.4 )

% Each dipole can be projected onto the scalp using the forward model. 
% The code below shows this projection from one dipole.
subplot(122)
topoplotIndie(-lf.Gain(:,1,diploc), EEG.chanlocs,'numcontour',0,'electrodes','numbers','shading','interp');
title('Signal dipole projection')
set( gca , 'LineWidth' , 2.5 , 'fontsize' , 22 , 'fontweight' , 'bold'  , 'GridAlpha' , 0.4 )

% number of time points and time vector
N = 1000;
EEG.times = (0:N-1)/EEG.srate;


% Random data in all 2004 brain dipoles
dipole_data = randn(length(lf.Gain),N);

% add signal to one dipole
dipole_data(diploc,:) = 15*sin(2*pi*10*EEG.times);

% project data from all dipoles to scalp electrodes
EEG.data = squeeze(lf.Gain(:,1,:))*dipole_data;


%Visualise Simulated Data:
figure(2) ; clf ; 
plot(EEG.times , dipole_data , 'LineWidth',1.7) ; 
xlabel('Times') ; 
ylabel('Signal Strength') ; 
title([ 'Input Signal To all ' , num2str(length(lf.Gain)) , ' Brain Dipoles'] ) ; 
set(gca , 'LineWidth' , 2.5 , 'FontSize' , 22 , 'FontWeight' , 'bold' , 'GridAlpha' , 0.4)

% Now Apply PCA On This Simulated Data:

% compute PCA

% mean-center data
data = EEG.data - mean(EEG.data,2);

% covariance matrix
covd = data*data'/size(EEG.data,2);

% % % If Intersted In Visualizing Covariance Matrix:
% figure(3) ; 
% imagesc(covd) ; 

% eigendecomposition
[evecs,evals] = eig( covd );

% sort according to eigenvalues
[evals,sidx] = sort(diag(evals),'descend'); % Sort Index
evecs = evecs(:,sidx);
evals = 100*evals/sum(evals);

% principal component time series
pc_timeseries = evecs(:,1)'*EEG.data;


% Now Let's plot results and compare with ground truth

figure(4), clf

% eigenspectrum
subplot(231)
plot(evals(1:20),'ko-','markerfacecolor','w','linew',2 , 'markersize' , 12)
title('Eigenspectrum'), axis square
ylabel('Percent variance'), xlabel('Component number')
set(gca , 'LineWidth' , 2.5 , 'FontSize' , 20 , 'FontWeight' , 'bold' , 'GridAlpha' , 0.4)

% topographical map of first eigenvector
subplot(232)
topoplotIndie(evecs(:,1),EEG.chanlocs,'numcontour',0,'shading','interp');
title('PC topomap')
set(gca , 'LineWidth' , 2.5 , 'FontSize' , 20 , 'FontWeight' , 'bold' , 'GridAlpha' , 0.4)

% topographical map of dipole (ground truth)
subplot(233)
topoplotIndie(-lf.Gain(:,1,diploc), EEG.chanlocs,'numcontour',0,'shading','interp');
title('Ground truth topomap')
set(gca , 'LineWidth' , 2.5 , 'FontSize' , 20 , 'FontWeight' , 'bold' , 'GridAlpha' , 0.4)

% plot time series
subplot(212)
plot(EEG.times,pc_timeseries, ...
     EEG.times,EEG.data(31,:), ...
     EEG.times,-dipole_data(diploc,:)*100 ,'linew',2 )
legend({'PC';'Chan';'Dipole'})
xlabel('Time (s)')
set(gca , 'LineWidth' , 2 , 'FontSize' , 20 , 'FontWeight' , 'bold' , 'GridAlpha' , 0.4)

%% Using Real EEG Data: 

% This data is also there in EEG Data_Structure:
% # Of channels/EEG electrodes: 64
% # of Trials: 99
% # of Time Sampled Time Points: 640
% # Sampling Frwquency: 256 hz

%  close all; 

clear, clc

% load data

load sampleEEGdata.mat
EEG.data = double( EEG.data );

% compute PCA on ERP
% ERP -> Bole To -> Event Related Potential:

% comptue the ERP Of Trial Averaged Data: ( To keep things simple here )
erp = mean(EEG.data,3);

% mean-centre and get covar
data = erp - mean(erp,2);
covd = data*data'/(EEG.pnts-1);
% figure ; imagesc(covd) ; 

% eig
[evecs,evals] = eig( covd );

% sort according to eigenvalues
[evals,sidx] = sort(diag(evals),'descend');
evecs = evecs(:,sidx);
evals = 100*evals/sum(evals);

% principal component time series
pc_timeseries = evecs(:,1)'*erp;

% plot results and compare with electrode

figure(5), clf

% eigenspectrum
subplot(221)
plot(evals(1:20),'ko-','markerfacecolor','w','linew',2)
title('Eigenspectrum'), axis square
ylabel('Percent variance'), xlabel('Component number')
set(gca , 'LineWidth' , 2 , 'FontSize' , 20 , 'FontWeight' , 'bold' , 'GridAlpha' , 0.4)

% topographical map of first eigenvector
subplot(222)
topoplotIndie(evecs(:,1),EEG.chanlocs,'numcontour',0,'shading','interp','electrodes','numbers');
title('PC topomap')
set(gca , 'LineWidth' , 2 , 'FontSize' , 20 , 'FontWeight' , 'bold' , 'GridAlpha' , 0.4)

% plot time series
subplot(212)
plot(EEG.times,pc_timeseries, ...
     EEG.times,mean(erp([19 32 20],:),1)*5 ,'linew',2 )
legend({'PC';'Chans'})
xlabel('Time (s)')
set(gca , 'LineWidth' , 2 , 'FontSize' , 20 , 'FontWeight' , 'bold' , 'GridAlpha' , 0.4)












