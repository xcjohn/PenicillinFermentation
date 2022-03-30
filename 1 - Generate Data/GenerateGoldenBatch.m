%% Generate 'Golden batch'
%golden batch is defined as the trajectory with all process/initial
%variables at the optimal/design values. (see source=3)
%we also define a second 'golden batch' as the mean of all trajectories

addpath(genpath('./util/')); % (import util functions into current Path)


fprintf("Generating the 'Golden batch' ");

LoadDefaults; %reset defaults

source = 3; % 1=[Liu, 2018], 2=[Jiang, 2019], 3=Optimal[combination]
LoadRanges;
LoadSimConfig;
    P_threshold = 999;  %[OVERWRITE] (g/L) - trigger end of batch [set arbitrarily high s.t. entire duration is run]
LoadNoiseConfig;

for i = 1:1
    fprintf('\t(%d) seeding inputs...',i);
    % generate seed values for initial conditions
    X_init      = GetAverage ( X_optimal );
    S_threshold = GetAverage ( S_threshold_optimal );
    S_init      = GetAverage ( S_optimal );
    V_init      = GetAverage ( V_optimal );
    CL_init     = GetAverage ( CL_optimal);
    pH_init     = GetAverage ( pH_optimal );
    H_init      = 10^(-pH_init);
    fprintf('[X-%.2f, S-%.2f @ %.2f, V-%.2f, CL-%.2f, pH-%.2f]...',X_init, S_init, S_threshold, V_init, CL_init, pH_init);
    
    % generate seed values for input variables (overwrite default values)
    F   = GetAverage( F_optimal  );
    fg  = GetAverage( fg_optimal );
    Pw  = GetAverage( Pw_optimal );

    fprintf('PRBS arrays...');
    %These remain the same, industrial noise remains. 
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
    golden1 = sim('fermentation', 'StartTime', num2str(startTime), 'StopTime', num2str(stopTime), 'FixedStep', num2str(timeDelta));
    final_penicillin = golden1.P.Data(end);
    hours = golden1.P.Time(end);
    fprintf('[done] [%.2f g/L @ %.0f hr]\n',final_penicillin, hours);
end