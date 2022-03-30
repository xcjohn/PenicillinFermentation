function [history_new] = SyncDatasetByPython(history,golden1, w, variable, ignoredProps)

addpath(genpath('./util/'));        % (import util functions into current Path)

%history = array of batches
%golden1 = golden reference batch to by aligned against
%w       = optimal max. warping window
%variable= basis on which alignment is performed - Note: the optimal
%alignment of a single variable within a batch applies to the entire batch.
%ignored = list of variables (as part of SimulinkOutput object) excluded

% Pseudo code / algorithm:

% % 1. for each batch
% %    a) calc DTW (python, assymetric) with t_max = t_max(golden) and the chosen variable
% %    b) apply calculated warping batch to all other variables within same batch
% %    c) add synchronized batch to a new history object


for i = 1:length(history)
    currBatch = history(i);
    props = properties(currBatch);   %array of properties ['CL, F, Fa, Fb...']
    
    %define a sync variable (it should match to that of FindOptimalDTWParam.m)
    sample = currBatch.(variable).data;
    reference = golden1.(variable).data;
        %an alternative approach is to use multi-variate DTW to find an
        %optimal warping path for all trajectories within a batch
        %simultaneously
        %(https://docs.scipy.org/doc/scipy/reference/generated/scipy.spatial.distance.cdist.html)
    
    %calculate the optimal warping path (via python script)
    warping_path = SynchronizeArrayByPython(sample, reference, w);
    
    
    %apply that warping path to the rest of the variables
    for j= 1:length(props)           %cycle through each prop
        currProp = props{j};         %e.g. 'CL'
        runSync = 1;
        
        fprintf('\nsynchronizing %s...', currProp);
        
        for k=1:length(ignoredProps) %check if this is an ignored prop.
            if isequal(currProp, ignoredProps(k))
                runSync = 0;
                fprintf('(ignoring property `%s`)', currProp);
            end
        end
        
        if runSync == 1
            %synchronize the trajectory, prop should not be ignored.
            
            currPropValue = currBatch.(currProp).data; %timeseries data
            %goldenPropValue = golden1.(currProp).data;
            currPropValue_synced = ApplyWarpingPath(currPropValue, warping_path);
            history_new(i).(currProp) = currPropValue_synced;
        end
    end
end
end

