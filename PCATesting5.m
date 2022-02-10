clear all;
clc;
clf;

%% Load Dataset
labels = ["Alcohol", "Malic acid", "Ash", "Alcalinity of ash", "Magnesium","Total phenols", "Flavanoids", "Nonflavanoid phenols", "Proanthocyanins", "Color intensity", "Hue", "OD280/OD315", "Proline" ];
ImportKaggleWine; % --> wineclustering (table)
dataset_raw = wineclustering;

%% Center and Scale Dataset
[dataset_Standardized, means, stds] = StandardizeUnfolded(dataset_raw);
dataset_Standardized = table2array(dataset_Standardized);

%% REDUCE DIMENSIONALITY VIA PCA
[coeff, score, latent, tsquared, explained, mu] = pca( dataset_Standardized  );

cum_explained = cumsum(explained);

min_95 = find(cumsum(explained)>95,1) %number of components required to explain >95% of variability
% figure(1);
% plot(explained); hold on;
% plot(cum_explained);
% legend on;
% title 'Dataset';
% xlabel 'Number of PCs'; 
% ylabel 'Explained Var / Cumulative';


% figure(2);
% biplot(coeff(:,1:2),'scores',score(:,1:2), 'varlabels', labels);

PC1 = zeros(length(dataset_Standardized),1);
PC2 = zeros(length(dataset_Standardized),1);
PC3 = zeros(length(dataset_Standardized),1);

num_vars = size(dataset_Standardized);

PC1 = dataset_Standardized(:,1)*coeff(1,1); % V1*a
PC2 = dataset_Standardized(:,1)*coeff(1,2); 
PC3 = dataset_Standardized(:,1)*coeff(1,2); 

for i=2:num_vars(2)
    PC1 = PC1 + dataset_Standardized(:,i)*coeff(i,1);
    PC2 = PC2 + dataset_Standardized(:,i)*coeff(i,2);
    PC3 = PC3 + dataset_Standardized(:,i)*coeff(i,3);
end

% figure(3);
% scatter(PC1, PC2);
% title 'Dataset';
% xlabel 'PC1'; 
% ylabel 'PC2';


%% CLUSTER WITH DBSCAN
%min_points = round( 0.02 * length(PC1), 0 );
min_points = 30;
eps = 0.5;
X = [PC1, PC2];
idx = dbscan(X, eps, min_points ); %idx represents the cluster assigned to each data point
% figure(4);
% gscatter(PC1,PC2,idx,'bgm');

% eps = [0.1 0.2 0.3 0.4 0.6 0.8 1.2 1.5 2];
% for i=1:length(eps)
%     epsilon = eps(1,i);
%     idx = dbscan(X, epsilon, min_points ); %idx represents the cluster assigned to each data point
%     figure(i+3);
%     gscatter(PC1,PC2,idx,'bgmrop');
% end

epsilon_ideal = 1.2;
min_points_ideal = 30;
idx = dbscan(X, epsilon_ideal, min_points_ideal ); %idx represents the cluster assigned to each data point
figure(20);
gscatter(PC1,PC2,idx,'bgmr');

%addpath(genpath('./util/'));
% epsilon_max = 2;
% min_points = 60;
% [RD, CD, order] = optics(X, min_points ); %idx represents the cluster assigned to each data point
% order = order';
% figure(21);
% gscatter(PC1,PC2,order,'bgmr');
