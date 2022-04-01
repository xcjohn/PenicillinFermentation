clear all;
clc;
clf;

%% Load Dataset
load('C:\Users\JOrsmond\MATLAB\Projects\masters\data\five_historicalbatches_aligned_trimmed_unfolded.mat'); %unfolded
dataset_raw = unfolded;

inputVars = ["CL", "CO2", "S", "T", "V", "pH", "X", "F", "Pw", "Qrxn"];
outputVars = ["P"];

%% Center and Scale Dataset
[dataset_std, means, stds] = StandardizeUnfolded(dataset_raw);

%% Split Data into Inputs/Outputs
inputTable = table(dataset_std.(inputVars(1)));
outputTable = table(dataset_std.(outputVars(1)));

for i=2:length(inputVars)
    inputTable(1:end,i) = table(dataset_std.(inputVars(i)));
end

inputTable.Properties.VariableNames = inputVars;
outputTable.Properties.VariableNames = outputVars;


%% REDUCE DIMENSIONALITY VIA PCA

dataset_Standardized = table2array(inputTable); %convert table to matrix, compatible input for PCA
[coeff, score, latent, tsquared, explained, mu] = pca( dataset_Standardized  );

cum_explained = cumsum(explained);

min_95 = find(cumsum(explained)>95,1) %number of components required to explain >95% of variability
figure(1);
plot(explained); hold on;
plot(cum_explained);
legend on;
title 'Dataset';
xlabel 'Number of PCs'; 
ylabel 'Explained Var / Cumulative';


figure(2);
biplot(coeff(:,1:2),'scores',score(:,1:2), 'varlabels', inputVars);

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

figure(3);
scatter(PC1, PC2);
title 'Dataset';
xlabel 'PC1'; 
ylabel 'PC2';



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
min_k_index = 4;
k_min = k(1,min_k_index);
[idx2, centroidLocations] = kmeans( [PC1, PC2], k_min, 'Replicates',5 );

figure(4);
plot(k, distances);
title 'Optimal Number of clusters - Elbow Method';
xlabel 'number of clusters, k'; 
ylabel 'total euclidean distance';

figure(5);
gscatter(PC1,PC2,idx2,'bgmc'); hold on;
plot(centroidLocations(:,1),centroidLocations(:,2),'kx');
legend('Cluster 1','Cluster 2','Cluster 3','Cluster 4', 'Centroids')
title 'Data';
xlabel 'PC1'; 
ylabel 'PC2';