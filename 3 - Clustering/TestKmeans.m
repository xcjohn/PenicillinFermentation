clear all;
clc;
clf;

[labels, dataset_raw, dataset_std, PC] = ImportDataSet(1);


k = [1 2 3 4 5 7 9 11];
distances = zeros(1,length(k));
idxs = zeros(length(dataset_std), length(k) );

for i=1:length(k)
    [idxi, C, sumd, D] = kmeans( PC(:,1:3), k(i), 'Replicates',5 );
    fprintf("iteration %d, avg eucl. distance %d\n", i, mean(sumd));
    distances(1,i) = mean(sumd);
end

%can use maximum curvature point to automatically find 'elbow' or enter
%manually below
min_k_index = 3;
k_min = k(1,min_k_index);
[idx2, centroidLocations] = kmeans( PC(:,1:3), k_min, 'Replicates',5 );


figure(3);
plot(k, distances);
title 'Optimal Number of clusters - Elbow Method';
xlabel 'number of clusters, k'; 
ylabel 'total euclidean distance';

figure(4);
gscatter(PC(:,1:2),idx2,'bgm'); hold on;
plot(centroidLocations(:,1),centroidLocations(:,2),centroidLocations(:,3),'kx');
legend('Cluster 1','Cluster 2','Cluster 3','Centroids')
title 'Wine Data';
xlabel 'PC1'; 
ylabel 'PC2';

%scatter(PC1, PC2); hold on;
%scatter (centroidLocations(:,1), centroidLocations(:,2), 140, 'x');



