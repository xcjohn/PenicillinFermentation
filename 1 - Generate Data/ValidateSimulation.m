%% Validate Simulation Output by comparing to literature values

clear all;
clc;
LoadDefaults;

addpath(genpath('./util/'));        % (import util functions into current Path)
addpath(genpath('./plotting/'));    % (import plotting functions into current Path)

load ('data\pensimdata.txt'); %original literature
load ('data\PenSimData.mat'); %literature source

%% PRBS Configuration
fg_delta = 0.05;        % (+- L/h)
Pw_delta = 0.6;         % (+- W)
F_delta  = 0.002;       % (+- L/h)
Tf_delta = 0.3;         % (+- K) ~ Defined by Jedd

%% Sensor Noise Guassians
G_O2_mean  = 0.0;       G_O2_std  = 0.00282;
G_CO2_mean = -0.039;    G_CO2_std = 0.062;

global source;
source = 1; % 1=[Liu, 2018], 2=[Jiang, 2019], 3=Optimal[combination]
LoadRanges;

% simulation variables
startTime = 0;      %hours
stopTime  = 400;    %hours
timeDelta = 0.01;   %hr
P_threshold = 99;  %(g/L) - trigger end of batch

% Overwrite defaults to match the literature simulation inputs.

%Process Variables
S_init      = 15;
CL_init     = 1.16;
X_init      = 0.1;
P_init      = 0;
V_init      = 100;
CO2_init    = 0.5;
pH_init     = 5;
H_init      = 10^(-pH_init);
T_init      = 298;
Qrxn_init   = 0;

%Input Variables
fg_range    = [8.6 8.6];
Pw_range    = [30 30];

%Set Points
pH_sp       = 5;
T_sp        = 298;

%Switch-over from batch -> fedbatch mode
S_threshold_range = [0.3 0.3];




%% RUN SIMULATION

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
    history(1) = results;

 
    %% BUILD DATA
    
    time_axis = history(1,1).tout;
    rows = size (time_axis, 1);
    cols = size (history, 2);

    P_matrix    = NaN( rows , cols);
    X_matrix    = NaN( rows , cols);
    pH_matrix   = NaN( rows , cols);
    CL_matrix   = NaN( rows , cols);
    CLmeas_matrix   = NaN (rows, cols);
    CO2_matrix      = NaN( rows , cols);
    CO2meas_matrix  = NaN (rows, cols);
    V_matrix    = NaN( rows , cols);
    S_matrix    = NaN( rows , cols);
    T_matrix    = NaN( rows , cols);
    F_matrix    = NaN( rows , cols);
    Fa_matrix   = NaN( rows , cols);
    Fb_matrix   = NaN( rows , cols);
    Fc_matrix   = NaN( rows , cols);
    H_matrix    = NaN( rows , cols);
    Kla_matrix  = NaN( rows , cols);
    Qrxn_matrix = NaN( rows , cols);
    Pw_matrix   = NaN( rows , cols);
    fg_matrix   = NaN( rows , cols);

    %X(i, j) = row i, column j

    for i=1:cols
        fprintf('loading batch %.0f\n', i);
        P_matrix    (   1:size(history(i).P.data,1) , i)    = history(i).P.data;
        X_matrix    (   1:size(history(i).X.data,1) , i)    = history(i).X.data;
        pH_matrix   (   1:size(history(i).pH.data,1), i)    = history(i).pH.data;
        CL_matrix   (   1:size(history(i).CL.data,1), i)    = history(i).CL.data;
        CO2_matrix  (   1:size(history(i).CO2.data,1), i)   = history(i).CO2.data;
        V_matrix    (   1:size(history(i).V.data,1), i)     = history(i).V.data;
        S_matrix    (   1:size(history(i).S.data,1), i)     = history(i).S.data;
        T_matrix    (   1:size(history(i).T.data,1), i)     = history(i).T.data;
        F_matrix    (   1:size(history(i).F.data,1), i)     = history(i).F.data;
        Fa_matrix   (   1:size(history(i).Fa.data,1), i)    = history(i).Fa.data;
        Fb_matrix   (   1:size(history(i).Fb.data,1), i)    = history(i).Fb.data;
        Fc_matrix   (   1:size(history(i).Fc.data,1), i)    = history(i).Fc.data;
        H_matrix    (   1:size(history(i).H.data,1), i)     = history(i).H.data;
        Kla_matrix  (   1:size(history(i).Kla.data,1), i)   = history(i).Kla.data;
        Qrxn_matrix (   1:size(history(i).Qrxn.data,1), i)  = history(i).Qrxn.data;
        Pw_matrix   (   1:size(history(i).Pw.data,1), i)  = history(i).Pw.data;
        fg_matrix   (   1:size(history(i).fg.data,1), i)  = history(i).fg.data;

        CLmeas_matrix   (   1:size(history(i).CL_measured.data,1), i)    = history(i).CL_measured.data;
        CO2meas_matrix  (   1:size(history(i).CO2_measured.data,1), i)   = history(i).CO2_measured.data;
    end
    
    
    
%% PLOT RESULTS


%%todo: fix CO2meas noise level (its too low)...O2meas level looks normal



figure(1);clf;
subplot(2,2,1)
plot(tStore(1:end-1),uStore(:,4), 'b'); hold on;
plot(time_axis, Fa_matrix, 'g');

ylabel('Acid flowrate (ml/h)')
legend('literature #1', 'jedd', 'original');
subplot(2,2,2)
plot(tStore(1:end-1),uStore(:,5), 'b');hold on;
plot(time_axis, Fb_matrix, 'g');hold on;
plot(pensimdata(1:end, 1), pensimdata(1:end, 16),'r');
ylabel('Base flowrate (ml/h)')
legend('literature #1', 'jedd', 'original');

subplot(2,2,3)
plot(tStore(1:end-1),uStore(:,6), 'b'); hold on;
plot(time_axis, Fc_matrix, 'g'); hold on;
plot(pensimdata(1:end, 1), pensimdata(1:end, 17),'r');
ylabel('Cooling water flowrate (l/h)')
legend('literature #1', 'jedd', 'original');
% subplot(2,2,4)
% plot(tStore(1:end-1),uStore(:,7), 'b'); hold on;
% plot(pensimdata(1:end, 1), pensimdata(1:end, 18),'r');
% ylabel('Hot water flowrate (l/h)')
% legend('literature #1', 'original');

figure(2);clf;
subplot(2,2,1)
plot(tStore(1:end-1),uStore(:,1), 'b'); hold on;
plot(time_axis, fg_matrix, 'g');hold on;
plot(pensimdata(1:end, 1), pensimdata(1:end, 2),'r');
ylabel('Aeration rate (l/h)')
legend('literature #1', 'jedd', 'original');

subplot(2,2,2)
plot(tStore(1:end-1),uStore(:,2), 'b'); hold on;
plot(time_axis, Pw_matrix, 'g');
plot(pensimdata(1:end, 1), pensimdata(1:end, 3),'r');
ylabel('Agitator Power (W)')
legend('literature #1', 'jedd', 'original');

subplot(2,2,3)
plot(tStore(1:end-1),uStore(:,3)); hold on;
plot(time_axis, F_matrix); hold on;
plot(pensimdata(1:end, 1), pensimdata(1:end, 4),'r');
ylabel('Substrate feedrate (l/h)')
legend('literature #1', 'jedd', 'original');

subplot(2,2,4)
plot(tStore(1:end-1),xStore(1:end-1,9), 'b'); hold on;
plot(time_axis, Qrxn_matrix, 'g'); hold on;
plot(pensimdata(1:end, 1), pensimdata(1:end, 14)*1000,'r');
ylabel('Generated heat (kCal)')
legend('literature #1', 'jedd', 'original');

figure(3);clf;
subplot(2,1,1)
plot(tStore(1:end-1),xStore(1:end-1,7), 'b'); hold on;
plot(time_axis, pH_matrix, 'g'); hold on;
plot(pensimdata(1:end, 1), pensimdata(1:end, 12),'r');
ylabel('pH')
legend('literature #1', 'jedd', 'original');

subplot(2,1,2)
plot(tStore(1:end-1),xStore(1:end-1,8), 'b'); hold on;
plot(time_axis, T_matrix,'g'); hold on;
plot(pensimdata(1:end, 1), pensimdata(1:end, 13),'r');
ylabel('Fermentor Temperature (K)')
legend('literature #1', 'jedd', 'original');

figure(4);clf;
subplot(3,2,1)
plot(tStore(1:end-1),xStore(1:end-1,1), 'b'); hold on;
plot(time_axis, S_matrix, 'g'); hold on;
plot(pensimdata(1:end, 1), pensimdata(1:end, 6),'r');
ylabel('Substrate conc. (g/l)')
legend('literature #1', 'jedd', 'original');

subplot(3,2,2)
plot(tStore(1:end-1),xStore(1:end-1,2)/1.16*100, 'b'); hold on;
plot(time_axis, (CLmeas_matrix/1.16*100), 'g'   ); hold on;
plot(pensimdata(1:end, 1), pensimdata(1:end, 7),'r');
ylabel('O_2, % saturation')
legend('literature #1', 'jedd', 'original');
subplot(3,2,3)
plot(tStore(1:end-1),xStore(1:end-1,3), 'b'); hold on;
plot(time_axis, X_matrix, 'g'); hold on;
plot(pensimdata(1:end, 1), pensimdata(1:end, 8),'r');
ylabel('Biomass conc.(g/l)') 
legend('literature #1', 'jedd', 'original');

subplot(3,2,4)
plot(tStore(1:end-1),xStore(1:end-1,4), 'b'); hold on;
plot(time_axis, P_matrix, 'g'); hold on;
plot(pensimdata(1:end, 1), pensimdata(1:end, 9),'r');
ylabel('Penicillin conc. (g/l)')
legend('literature #1', 'jedd', 'original');

subplot(3,2,5)
plot(tStore(1:end-1),xStore(1:end-1,5), 'b'); hold on;
plot(time_axis, V_matrix, 'g'); hold on;
plot(pensimdata(1:end, 1), pensimdata(1:end, 10),'r');
ylabel('Culture vol. (l)')
legend('literature #1', 'jedd', 'original');

subplot(3,2,6)
plot(tStore(1:end-1),xStore(1:end-1,6), 'b');hold on;
plot(time_axis, CO2meas_matrix, 'g'); hold on;
plot(pensimdata(1:end, 1), pensimdata(1:end, 11),'r');
ylabel('CO_2 conc. (g/l)')
legend('literature #1', 'jedd', 'original');