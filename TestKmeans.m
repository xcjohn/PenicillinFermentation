clear all;
clc;
clf;

%https://www.kaggle.com/harrywang/wine-dataset-for-clustering
%https://medium.com/swlh/k-means-clustering-on-high-dimensional-data-d2151e1a4240
%13 variables (chemical qualities) of several wines in 3 different wine types
% % The attributes are:
% % 
% % Alcohol
% % Malic acid
% % Ash
% % Alcalinity of ash
% % Magnesium
% % Total phenols
% % Flavanoids
% % Nonflavanoid phenols
% % Proanthocyanins
% % Color intensity
% % Hue
% % OD280/OD315 of diluted wines
% % Proline

labels = ["Alcohol", "Malic acid", "Ash", "Alcalinity of ash", "Magnesium","Total phenols", "Flavanoids", "Nonflavanoid phenols", "Proanthocyanins", "Color intensity", "Hue", "OD280/OD315", "Proline" ];
ImportKaggleWine; % --> wineclustering (table)
dataset_raw = wineclustering;

%GOAL - perform K-means clustering to determine the number of types of
%wine, check if we approach the actual result (3 types)

%% STEP 1 - CENTER AND SCALE DATA 
[dataset_Standardized, centers, scales] = StandardizeUnfolded(dataset_raw);

%% STEP 2 - REDUCE DIMENSIONALITY VIA PCA

dataset_Standardized = table2array(dataset_Standardized); %convert table to matrix, compatible input for PCA
[coeff, score, latent, tsquared, explained, mu] = pca( dataset_Standardized   );


cum_explained = cumsum(explained);

min_components_95 = find(cumsum(explained)>95,1) %number of components required to explain >95% of variability
figure(1);
plot(explained); hold on;
plot(cum_explained);
legend on;
title 'Wine Data';
xlabel 'Number of PCs'; 
ylabel 'Explained Var / Cumulative';


figure(2);
biplot(coeff(:,1:2),'scores',score(:,1:2), 'varlabels', labels);

PC1 = zeros(length(dataset_Standardized),1);
PC2 = zeros(length(dataset_Standardized),1);
PC3 = zeros(length(dataset_Standardized),1);

num_vars = size(dataset_Standardized);

PC1 = dataset_Standardized(:,1)*coeff(1,1); % V1*a
PC2 = dataset_Standardized(:,1)*coeff(1,2); % V1*a
PC3 = dataset_Standardized(:,1)*coeff(1,2); % V1*a


for i=2:num_vars(2)
    PC1 = PC1 + dataset_Standardized(:,i)*coeff(i,1);
    PC2 = PC2 + dataset_Standardized(:,i)*coeff(i,2);
    PC3 = PC3 + dataset_Standardized(:,i)*coeff(i,3);
end

PC2=PC2.*-1;

k = [1 2 3 4 5 7 9 11];
distances = zeros(1,length(k));
idxs = zeros(length(dataset_Standardized), length(k) );

for i=1:length(k)
    [idxi, C, sumd, D] = kmeans( [PC1, PC2], k(i), 'Replicates',5 );
    fprintf("iteration %d, avg eucl. distance %d\n", i, mean(sumd));
    distances(1,i) = mean(sumd);
end

%can use maximum curvature point to automatically find 'elbow' or enter
%manually below
min_k_index = 3;
k_min = k(1,min_k_index);
[idx2, centroidLocations] = kmeans( [PC1, PC2], k_min, 'Replicates',5 );


figure(3);
plot(k, distances);
title 'Optimal Number of clusters - Elbow Method';
xlabel 'number of clusters, k'; 
ylabel 'total euclidean distance';

figure(4);
gscatter(PC1,PC2,idx2,'bgm'); hold on;
plot(centroidLocations(:,1),centroidLocations(:,2),'kx');
legend('Cluster 1','Cluster 2','Cluster 3','Centroids')
title 'Wine Data';
xlabel 'PC1'; 
ylabel 'PC2';

%scatter(PC1, PC2); hold on;
%scatter (centroidLocations(:,1), centroidLocations(:,2), 140, 'x');



