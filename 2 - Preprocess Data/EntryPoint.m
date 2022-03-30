clear all;
clc;

%1 - get historical generated data set
load ('..\dataCommit\five_historicalbatches.mat'); % --> history

%2 - align trajectories
%load ('..\dataCommit\five_historicalbatches_aligned.mat'); %--> historySP
load ('..\dataCommit\five_historicalbatches_aligned_trimmed.mat'); %--> history_trim

%3 - Unfold data variable-wise
%unfolded = UnfoldBatches(history_trim); --> unfolded
load ('..\dataCommit\five_historicalbatches_aligned_trimmed_unfolded.mat');

%4 - Standardize unfolded data
[unfolded_std, centers, scales] = StandardizeUnfolded(unfolded);
    %C = centering parameters (each column)
    %S = scaling parameter (i.e. std dev)

%5 - Generate Tables
inputVars = ["CL", "CO2", "S", "T", "V", "pH", "X", "F", "Pw"];
outputVars = ["P"];
[inputTable, outputTable] = SplitTables(unfolded_std, inputVars, outputVars);