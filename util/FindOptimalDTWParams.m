function [w_optimal, d_min, p_batch, p_golden] = FindOptimalDTWParams(history,golden1, a, b, step_size,  sample_period, variable)
%w = warping window (optimal)
%d = calculated distance as per optimal w
%p = warping path as per optimal w
%variable = chosen sync variable (e.g. "S")

%DTW will synchronize the process variable trajectories from 'history' to
%that of 'golden1'.

%Automatically determine optimal warping window for best fit based on
%min-max range. (1-3)

%%DTW NOTES
%Restrictions:
%     Boundary condition - warping path must begin and terminate with corresponding start/end points of two signals
%     Monotonically increasing - preserves time order (no going back in time)
%     continuity - limit the path transitions to adjacent points in time (no skipping)
%     warping window - allowable points can be restricted to fall within a given warping window of width w (positive). this prevents extreme movements  

%setting a max warping window determines the max distance between mapping
%of indices, or in another way, limits the max. domain allowed for linking

fprintf('-- DTW Optimal Param (Warping Window) Fidner --\n');
fprintf('\tEvaluating (%d) trajectories from historical data.\n',length(history));
fprintf('\tCalculator inputs @ [min = %d, max=%d]\n\n', a, b);


%1. Select a variable to base the synchronization on:
    %ideally it should have a few SPs, but choice is arbitrary
    %synchronization of one process trajectory is equivelent to sync. all
    %of them simultaneously
    
%2. Strategy - 
        % select a process variable (e.g. Penicillin Conc.)
        % determine the 'distance' metric from w=min -> w=max
        % sum the total distance for each w=...,
        % select optimal w s.t. distance is minimized
        
golden_ref = golden1.(variable).data;


w = a:step_size:b;
j=1; %store current index
d = zeros(1, length(w));
        
for i=w  %(warping windows, increments of 0.1)
    fprintf('evaluating warping_window=%d, equivelent to %.0f hr of simulation time...\n', floor(1000*i), 1000*i*sample_period);
    total_distance = 0;
    
    for k=1:length(history) %each batch
        sample = history(k).(variable).data;
        [distance, i_g, i_s] = dtw(golden_ref,sample,  floor(1000*i));
        fprintf('\tbatch %d - [calc distance %d]\n', k,  distance);
        total_distance = total_distance + distance;
    end
    fprintf('Total distance for warping_window=%d, [%d]\n\n', i,  total_distance);
    d(1,j) = total_distance; %save values
    j = j + 1; 
end

%find minimum distance, and corresponding index 
[d_min, index]  = min(d);
w_optimal = w(index);

[d_min, p_golden, p_batch] = dtw( golden_ref,  history(1).S.data,  floor(1000*w_optimal));

fprintf('minimum distance(%d) at w=[%d]\n', d_min ,  w(index) );

plot(w,d);

xlabel('Max. Warping Window [hr]');
ylabel('Total Distance [-]')


% addpath(genpath('./util/')); % (import util functions into current Path)
% 
% for i=1:length(history)
%     
%     %get current batch object
%     currBatch = history(i);
%     %get the {process variable} trajectory and corresponding golden ref
%     CL          = history(i).CL;
%     gCL         = golden1.CL;
%     
%     %call SynchronizeArray with calculated w, to get 2 synced + cut arrays
%     [gCL_synced, CL_synced] = SynchronizeArray(gCL, CL, w(index));
%     
%     %set history_sync(i).{propertyName} to correct thing
%     history_sync(i).CL = CL_synced;
%     golden_sync.CL = gCL_synced;
%     
%     %cut the tout array as well and replace it in batch
%     
%     CL_measured = history(i).CL_measured;
%     CO2         = history(i).CO2;
%     CO2_measured = history(i).CO2_measured;
%     F           = history(i).F;
%     Fa          = history(i).Fa;
%     Fb          = history(i).Fb;
%     Fc          = history(i).Fc;
%     H           = history(i).H;
%     Kla         = history(i).Kla;
%     P           = history(i).P;
%     Pw          = history(i).Pw;
%     Qrxn        = history(i).Qrxn;
%     S           = history(i).S;
%     T           = history(i).T;
%     Tf          = history(i).Tf;
%     V           = history(i).V;
%     X           = history(i).X;
%     dCO2        = history(i).dCO2;
%     dH          = history(i).dH;
%     dQ          = history(i).dQ;
%     dT          = history(i).dT;
%     dV          = history(i).dV;
%     dX          = history(i).dX;
%     errorStorePH = history(i).errorStorePH;
%     errorStoreTemp = history(i).errorStoreTemp;
%     fg          = history(i).fg;
%     mu          = history(i).mu;
%     mu_pp       = history(i).mu_pp;
%     pH          = history(i).pH;
%     phStore     = history(i).phStore;
%     tempStore   = history(i).tempStore;
%     
%     
%     gCL_measured = golden1.CL_measured;
%     gCO2         = golden1.CO2;
%     gCO2_measured = golden1.CO2_measured;
%     gF           = golden1.F;
%     gFa          = golden1.Fa;
%     gFb          = golden1.Fb;
%     gFc          = golden1.Fc;
%     gH           = golden1.H;
%     gKla         = golden1.Kla;
%     gP           = golden1.P;
%     gPw          = golden1.Pw;
%     gQrxn        = golden1.Qrxn;
%     gS           = golden1.S;
%     gT           = golden1.T;
%     gTf          = golden1.Tf;
%     gV           = golden1.V;
%     gX           = golden1.X;
%     gdCO2        = golden1.dCO2;
%     gdH          = golden1.dH;
%     gdQ          = golden1.dQ;
%     gdT          = golden1.dT;
%     gdV          = golden1.dV;
%     gdX          = golden1.dX;
%     gerrorStorePH = golden1.errorStorePH;
%     gerrorStoreTemp = golden1.errorStoreTemp;
%     gfg          = golden1.fg;
%     gmu          = golden1.mu;
%     gmu_pp       = golden1.mu_pp;
%     gpH          = golden1.pH;
%     gphStore     = golden1.phStore;
%     gtempStore   = golden1.tempStore;
% end

%history_sync = history;
        
end

