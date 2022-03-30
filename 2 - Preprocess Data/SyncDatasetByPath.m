function [history_sync,golden_sync] = SyncDatasetByPath(history,golden1, ignoredProps, w, variable)
%p = warping path as determined by FindOptimalDTWParams

%a chosen sync variable (e.g. Penicillin conc.) is used to determine the
%optimal warping window (w) within a given range (min-max). The
%corresponding warping path (p) is calculated with this window.

%The warping path is an array of indices that map the elements of signal A
%and B such that the distance between them is minimized.

%it does not make sense to use a different warping path for each process
%variable, as the optimal sync path for any variable (e.g. Penicillin
%conc.) should be applicable to the entire dataset and using multiple
%warping paths for each variable could give strange results. 

%%TEMPORARY - TODO [IMPLEMENT LDTW ALGORITHM]
    %sync the golden batch variables to the longest warping path
    
p_golden_max = [0];

for i = 1:length(history)
    
    currBatch = history(i);
    
    %define a sync variable (match it to that of FindOptimalDTWParam.m)
    sample = currBatch.(variable).data;
    golden_ref = golden1.(variable).data;
        
    %calculate the warping paths with optimal warping window (w)
    [distance, p_golden, p_batch] = dtw(golden_ref,sample,  floor(1000*i));
    
    %store the longest warping path calculated
    if length(p_golden) > length(p_golden_max)
        p_golden_max = p_golden;
    end
    
    
    %apply that warping path to all process variables
    
   props = properties(currBatch);   %array of properties ['CL, F, Fa, Fb...']
   fprintf('--[Historical batch #%d]--\n', i);
   
   for j= 1:length(props)
      currProp = props{j};           %e.g. 'CL'
      runSync = 1;
      
      fprintf('\nsynchronizing %s...', currProp);
      
      for k=1:length(ignoredProps)
          if isequal(currProp, ignoredProps(k))
              runSync = 0;
              fprintf('(ignoring property `%s`)', currProp);
          end
      end

      if runSync == 1
          %synchronize the trajectory
          currPropValue = currBatch.(currProp).data; %timeseries data e.g. CL data
          currGoldenValue = golden1.(currProp).data;
          
          history_sync(i).(currProp)    = ApplyWarpingPath(currPropValue, p_batch); 
          golden_sync.(currProp)        = ApplyWarpingPath(currGoldenValue, p_golden_max); %inefficient (re-syncing every time), but will result in the max 
      end
   end
end

end

