clear all;
clc;
addpath(genpath('./util/'));        % (import util functions into current Path)
addpath(genpath('./plotting/'));    % (import plotting functions into current Path)
addpath(genpath('./1 - Generate Data/'));
addpath(genpath('./2 - Preprocess Data/'));
addpath(genpath('./3 - Clustering/'));


%1. Generate Historical Data ('history' - array of SimulationOutput)
%GenerateHistoricalBatches; %set k=... in file.
load ('dataCommit\historicalBatches.mat');

%2. Generate Golden Batch ('golden1' - SimualationOutput at optimal cond.)
%GenerateGoldenBatch; 
load ('dataCommit\goldenBatch.mat');

%3. Plot All
%PlotAllBatches(history);

%4. Find optimal DTW Sync. Window Period
%ignoredProps = ["tout", "SimulationMetadata", "ErrorMessage", "errorStorePH", "errorStoreTemp", "phStore", "tempStore"];
%[w, d] = FindOptimalDTWParams(history, golden1, 1,5, 0.5, 0.01, 'S');


%4.2. Resample to reduce data sizes
%timestep = 0.01;
%history = ResampleHistory(history, 10); %sim resolution = 0.01h, resample to 0.1h
%golden1 = ResampleHistory(golden1, 10);
%timestep = 0.1;

%5. Synchronize Trajectories with calculated optimal window period
%history_sync = SyncDatasetByPython(history, golden1,w, 'S', ignoredProps); %based on S=substrate conc.
%5.1 (Alternative) align using Singular Points
%s_threshold = 0.3;
%history_sync = AlignBySingularPoint(history, s_threshold, timestep)
%PlotAllBatches(history_sync);


%[history_sync, golden_sync] = SyncDataset(history, golden1, ignoredProps, w);
