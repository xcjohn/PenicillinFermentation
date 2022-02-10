%% TODO / Notes


%% Discussion Notes
% The basis for generating historical data:
% 1. initial variables are randomly loaded based on ranges from literature values
%       (can be switched by changing the source flag)

% 2. input variables are given 'real' time-varying values using PRBS

% 3. the switch from batch -> fed-batch mode is done with a threshold on
%       substrate concentration (S=0.3 g/L by default) generated randomly within
%       a range

% 4. the end of a batch is triggered based on a desired final penicillin
%       concentration (P = 1.3 g/L by default). Based on all the randomly
%       generated input/initial variables, this is achieved in different time or
%       not at all with a max simulation time of 450h.

% 5. output variables are given a gaussian noise distribution to represent
%       real measurement noise on sensors

% 6. Set points (pH/Temp) are not changed between historical data.

clear all;
clc;

addpath(genpath('./util/'));        % (import util functions into current Path)
addpath(genpath('./plotting/'));    % (import plotting functions into current Path)

%% Entry Point
fprintf('-- Simulation Entry Point --\n\n');
LoadDefaults;
fprintf('\n-- Simulation loaded --\n');

LoadNoiseConfig;

%% Overwrite Default Values
% variations in initial conditions (i.e. batch-to-batch variations)

% variations in process variable operating ranges (i.e. dynamics)
global source;
source = 1; % 1=[Liu, 2018], 2=[Jiang, 2019], 3=Optimal[combination]
LoadRanges;

LoadSimConfig;

%% Configure Batches
k = 50; %number of batches

%% Run Simulation 
fprintf('Building historical data (batches =%d)\n', k);

for i = 1:k
    fprintf('\t(%d) seeding inputs...',i);
    % generate seed values for initial conditions
    X_init      = GenRandomWithinRange ( X_range );
    S_threshold = GenRandomWithinRange ( S_threshold_range );
    S_init      = GenRandomWithinRange ( S_optimal );
    V_init      = GenRandomWithinRange ( V_optimal );
    CL_init     = GenRandomWithinRange ( CL_optimal);
    pH_init     = GenRandomWithinRange ( pH_optimal );
    H_init      = 10^(-pH_init);
    fprintf('[X-%.2f, S-%.2f @ %.2f, V-%.2f, CL-%.2f, pH-%.2f]...',X_init, S_init, S_threshold, V_init, CL_init, pH_init);
    
    % generate seed values for input variables (overwrite default values)
    F   = GenRandomWithinRange( F_range  );
    fg  = GenRandomWithinRange( fg_range );
    Pw  = GenRandomWithinRange( Pw_range );

    fprintf('PRBS arrays...');
    %variable-input for Substrate Feed
    FArray  = GenSmoothPRBSArray (stopTime, timeDelta,  F, F_delta);
    fprintf('[F, ');

    %variable-input for Agitation Rate
    PwArray = GenSmoothPRBSArray (stopTime, timeDelta, Pw, Pw_delta);
    Pw_ts = timeseries(PwArray(1:end,2),  PwArray(1:end,1) );
    fprintf('Pw, ');

    %variable-input for Aeration Feed
    fgArray = GenSmoothPRBSArray (stopTime, timeDelta, fg, fg_delta);
    fg_ts = timeseries(fgArray(1:end,2),  fgArray(1:end,1) );
    fprintf('Fg, ')
    
    %variable-input for Substrate Temperature
    TfArray = GenSmoothPRBSArray (stopTime, timeDelta, Tf, Tf_delta);
    Tf_ts = timeseries(TfArray(1:end,2), TfArray(1:end,1) );
    fprintf('Tf]...')
    
    fprintf('simulating...');
    results = sim('fermentation', 'StartTime', num2str(startTime), 'StopTime', num2str(stopTime), 'FixedStep', num2str(timeDelta));
    final_penicillin = results.P.Data(end);
    hours = results.P.Time(end);
    fprintf('[done] [%.2f g/L @ %.0f hr]\n',final_penicillin, hours);
    history(i) = results;
end

fprintf('Building historical data complete.\n');
