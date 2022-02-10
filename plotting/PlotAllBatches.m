%Input - 'history'
%history is an array of SimulationOutput objects as exported by
%Fermentation.slx for each run.

%This function can also be used to plot a single batch, given that history
%is an array of length=1.

function output = PlotAllBatches ( history ) 

workspace; %get variables in the local function workspace to appear in global Workspace

    %[P, X, pH, CL(CL_meas), CO2(CO2_meas), V,S,] [T,F, Fa, Fb, Fc, H, Kla,  Qrxn, Pw, fg, dCO2, dH, dQ, dT, dV,
    %dX, errorStorePH, errorStoreTemp, mu, mu_pp,  phStore, tempStore

    clf; %clear current figure;
    
    %time_axis = history(1,1).tout; %set the time_axis to the first batch in history
    time_axis = history(1,1).S.time; %set the time_axis to the first batch in history
    for i=1:size(history,2)
        if size(history(1,i).S.time,1) > size(time_axis,1)    %fix a bug when plotting historical data without any batches reaching the full 450hr
            time_axis = history(1,i).S.time;
            fprintf('time axis set to %.0f\n', size(time_axis,1));
        end
    end

    fprintf('time axis set to %.0f\n', size(time_axis,1));
    rows = size (time_axis, 1);
    cols = size (history, 2);

    P_matrix    = NaN( rows , cols);
    X_matrix    = NaN( rows , cols);
    pH_matrix   = NaN( rows , cols);
    CL_matrix   = NaN( rows , cols);
    CLmeas_matrix = NaN (rows, cols);
    CO2_matrix  = NaN( rows , cols);
    CO2meas_matrix = NaN (rows, cols);
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

    figure(1); %PID Control Variables
    subplot(2,2,1);
    plot(time_axis, Fa_matrix);
    ylabel('Acid Flowrate [mL/h]');
    xlabel('time [hr]');
    subplot(2,2,2);
    plot(time_axis, Fb_matrix);
    ylabel('Base Flowrate [mL/h]');
    xlabel('time [hr]');
    subplot(2,2,3);
    plot(time_axis, Fc_matrix);
    ylabel('Cooling Water Flowrate [L/h]');
    xlabel('time [hr]');

    figure(2); %Input Variables
    subplot(2,2,1)
    plot(time_axis, fg_matrix);
    xlabel('time [hr]');
    ylabel('Aeration rate [L/h]')
    subplot(2,2,2)
    plot(time_axis, Pw_matrix);
    xlabel('time [hr]');
    ylabel('Agitator Power (W)')
    subplot(2,2,3)
    plot(time_axis, F_matrix);
    xlabel('time [hr]');
    ylabel('Substrate feedrate [L/h]')
    subplot(2,2,4)
    plot(time_axis, Qrxn_matrix);
    xlabel('time [hr]');
    ylabel('Generated heat [kCal]')

    figure(3);
    subplot(2,1,1)
    plot(time_axis, pH_matrix);
    xlabel('time [hr]');
    ylabel('pH [-]')
    subplot(2,1,2)
    plot(time_axis, T_matrix);
    xlabel('time [hr]');
    ylabel('Fermentor Temperature [K]')

    figure(4);
    subplot(3,2,1)
    plot(time_axis, S_matrix);
    xlabel('time [hr]');
    ylabel('Substrate conc. [g/L]')
    subplot(3,2,2)
    plot(time_axis, CL_matrix);
    xlabel('time [hr]');
    ylabel('O2 conc, [g/L]')
    subplot(3,2,3)
    plot(time_axis, X_matrix);
    xlabel('time [hr]');
    ylabel('Biomass conc.[g/L]')
    subplot(3,2,4)
    plot(time_axis, P_matrix);
    xlabel('time [hr]');
    ylabel('Penicillin conc. [g/L]')
    subplot(3,2,5)
    plot(time_axis, V_matrix);
    xlabel('time [hr]');
    ylabel('Culture vol. [L]')
    subplot(3,2,6)
    plot(time_axis, CO2_matrix);
    xlabel('time [hr]');
    ylabel('CO_2 conc. [g/L]')
    
    figure(5);
    subplot(1,2,1)
    plot(time_axis, CL_matrix, '-'); hold on;
    plot(time_axis, CLmeas_matrix);
    xlabel('time [hr]');
    ylabel('Dissolved O2 conc. [g/L]')
    subplot(1,2,2)
    plot(time_axis, CO2_matrix, '-'); hold on;
    plot(time_axis, CO2meas_matrix);
    xlabel('time [hr]');
    ylabel('CO2 conc, [g/L]')

end 