clear all;
clc;
clf;

addpath 'C:\Users\JOrsmond\MATLAB\Projects\masters'\plotting\;
addpath 'C:\Users\JOrsmond\MATLAB\Projects\masters'\dataCommit\;
addpath 'C:\Users\JOrsmond\MATLAB\Projects\masters'\util\;

%1 - get historical generated data set
load ('dataCommit\five_historicalbatches.mat'); % --> history

%2 - align trajectories
s_threshold = 0.3;
timestep = 0.01;
%historySP = AlignBySingularPoint(history, s_threshold, timestep);
%load ('dataCommit\five_historicalbatches_aligned.mat'); %--> historySP
%history_trim = TrimToMin(historySP);
load ('dataCommit\five_historicalbatches_aligned_trimmed.mat'); %--> history_trim
%PlotAllBatches(historySP);

%3 - Unfold data variable-wise
%unfolded = UnfoldBatches(history_trim); --> unfolded
load ('dataCommit\five_historicalbatches_aligned_trimmed_unfolded.mat');

%4 - Standardize unfolded data
[unfolded_std, centers, scales] = StandardizeUnfolded(unfolded);
    %C = centering parameters (each column)
    %S = scaling parameter (i.e. std dev)

%5 - Generate Tables
inputVars = ["CL", "CO2", "S", "T", "V", "pH", "X", "F", "Pw"];
outputVars = ["P"];
[inputTable, outputTable] = SplitTables(unfolded_std, inputVars, outputVars);

%5.1 convert to matrix
inputMatrix = table2array(inputTable);

%6 - Run PCA
[coeff, score, latent, tsquared, explained, mu, PC] = RunPCA( inputMatrix );
PC1 = PC(:,1);
PC2 = PC(:,2);
PC3 = PC(:,3);
PC4 = PC(:,4);
PC5 = PC(:,5);
PC6 = PC(:,6);
PC7 = PC(:,7);

figure(1);
biplot(coeff(:,1:2),'scores',score(:,1:2));
xlabel('PC1');
ylabel('PC2');
title('Score Plot');

figure(2);
plot(explained);
title('Explained Variance');
xlabel('number of PCs');
ylabel('% unexplained');

i95 = find(cumsum(explained)>95,1) %number of components required to explain >95% of variability
i85 = find(cumsum(explained)>85,1)
