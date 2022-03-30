function [history_sync,golden_sync] = SyncDataset(history,golden1, ignoredProps, w)

addpath(genpath('./util/')); % (import util functions into current Path)


for i = 1:length(history)
   currBatch = history(i);          %batch no. 2
   props = properties(currBatch);   %array of properties ['CL, F, Fa, Fb...']
   fprintf('--[Historical batch #%d]--\n', i);
   
   for j= 1:length(props)
      currProp = props{j};           %'CL'
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
          currPropValue = currBatch.(currProp).data; %timeseries data
          goldenPropValue = golden1.(currProp).data;
          [currGoldenProp_synced, currProp_synced] = SynchronizeArray(goldenPropValue, currPropValue, w);
          golden_sync.(currProp) = currGoldenProp_synced;
          history_sync(i).(currProp) = currProp_synced;
      end
   end
end

end

