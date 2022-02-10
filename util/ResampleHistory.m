function [history_new] = ResampleHistory(history, modifier)
ignoredProps = ["tout", "SimulationMetadata", "ErrorMessage", "errorStorePH", "errorStoreTemp", "phStore", "tempStore"];

for i=1:length(history)
    currBatch = history(i);          %batch no. 2
    props = properties(currBatch);   %array of properties ['CL, F, Fa, Fb...']
    fprintf('--[Historical batch #%d]--\n', i);
    
    for j= 1:length(props)
      currProp = props{j};           %'CL'
      runResample = 1;
      
      for k=1:length(ignoredProps)
          if isequal(currProp, ignoredProps(k))
              runResample = 0;
              fprintf('(ignoring property `%s`)\n', currProp);
          end
      end
      
      
      
      if runResample == 1
          currPropValue = currBatch.(currProp).data; %timeseries data
          currToutValue = currBatch.tout;
          %goldenPropValue = golden1.(currProp).data;
          
          index = 1;
          for a=1:length(currPropValue)
              if (mod(a, modifier) == 0) || (a == 1) %take every <modifier>-th value
                  
                  history_new(i).tout(index) = currToutValue(a);
                  
                  if currPropValue < 0.001
                      history_new(i).(currProp)(index) = 0;      
                  else
                      history_new(i).(currProp)(index) = currPropValue(a);
                  end
                index = index + 1;
              end
          end
          
      end
    end
    
    %add the time vector back
    
end

end

