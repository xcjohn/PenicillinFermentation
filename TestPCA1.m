clear all;
clc;

%load('C:\Users\JOrsmond\MATLAB\Projects\masters\data\five_historicalbatches_aligned_trimmed.mat');
load('C:\Users\JOrsmond\MATLAB\Projects\masters\data\five_historicalbatches_aligned_trimmed_unfolded.mat');

[unfoldedSTD, centers, scales, inputTable, outputTable] = RunPCA(unfolded);

inputMatrix = table2array(inputTable);
outputMatrix = table2array(outputTable);

inputVars =  inputTable.Properties.VariableNames;
outputVars = outputTable.Properties.VariableNames;

[coeff, score, latent, tsquared, explained, mu] = pca(  inputMatrix  );

idx = find(cumsum(explained)>80,1) %number of components required to explain >95% of variability
cum_explained = cumsum(explained);

figure(1);
biplot(coeff(:,1:2),'scores',score(:,1:2),'varlabels',inputVars);
figure(2);
plot(explained); hold on;
plot(cum_explained);