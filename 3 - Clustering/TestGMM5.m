%% Clean Up
clear all;
clc;
clf;

%% Import Data
[labels, dataset_raw, dataset_std, PC] = ImportDataSet(1);
% print out dataset
figure(1);
scatter(PC(:,1), PC(:,2));
title ("dataset [2D]");
xlabel('PC1');
ylabel('PC2');

figure(2);
scatter3(PC(:,1), PC(:,2), PC(:,3));
title ("dataset [3D]");
xlabel('PC1');
ylabel('PC2');
zlabel('PC3');

%% Fit GMM
k = 4; %as suggested by K-Means/DBScan
X = PC(:,1:2);
options = statset('Display','final');
gm = fitgmdist(X, k, 'CovarianceType', 'diagonal', 'SharedCovariance', false ,'Options',options)

% fitgmdist Fit a Gaussian mixture distribution to data.
%     GM = fitgmdist(X,K) fits a Gaussian mixture distribution with K
%     components to the data in X.  X is an N-by-D matrix.  Rows of X
%     correspond to observations; columns correspond to variables. fitgmdist
%     fits the model by maximum likelihood, using the
%     Expectation-Maximization (EM) algorithm.
%  
%     fitgmdist treats NaNs as missing data.  Rows of X with NaNs are excluded from the fit.

%% Plot Fit Results
idx = cluster(gm,X);
cluster1 = (idx == 1); % |1| for cluster 1 membership
cluster2 = (idx == 2); % |2| for cluster 2 membership
cluster3 = (idx == 3); % |3| for cluster 3 membership
cluster4 = (idx == 4); % |4| for cluster 3 membership
cluster5 = (idx == 5); % |5| for cluster 3 membership
figure(3)
gscatter(X(:,1),X(:,2),idx,'rbgyc','+o');
legend('Cluster 1','Cluster 2','Cluster 3','Cluster 4','Cluster 5');