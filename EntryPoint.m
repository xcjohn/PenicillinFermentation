clear all;
clc;
addpath(genpath('./util/'));        % (import util functions into current Path)
addpath(genpath('./plotting/'));    % (import plotting functions into current Path)
addpath(genpath('./1 - Generate Data/'));
addpath(genpath('./2 - Preprocess Data/'));
addpath(genpath('./3 - Clustering/'));


%1. Generate Historical Data ('history' - array of SimulationOutput)
GenerateHistoricalBatches; %set k=... in file.

%2. Generate Golden Batch ('golden1' - SimualationOutput at optimal cond.)
GenerateGoldenBatch; 

%3. Plot All
load ('dataCommit\goldenBatch.mat');
load ('dataCommit\historicalBatches.mat');
%PlotAllBatches(history);

%4. Find optimal DTW Sync. Window Period
ignoredProps = ["tout", "SimulationMetadata", "ErrorMessage", "errorStorePH", "errorStoreTemp", "phStore", "tempStore"];
[w, d] = FindOptimalDTWParams(history, golden1, 1,5, 0.5, 0.01, 'S');


%4.2. Resample to reduce data sizes
history = ResampleHistory(history, 10); %sim resolution = 0.01h, resample to 0.1h
golden1 = ResampleHistory(golden1, 10);

%5. Synchronize Trajectories with calculated optimal window period
history_sync = SyncDatasetByPython(history, golden1,w, 'S', ignoredProps); %based on S=substrate conc.
%PlotAllBatches(history_sync);


%[history_sync, golden_sync] = SyncDataset(history, golden1, ignoredProps, w);
