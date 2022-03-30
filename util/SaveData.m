ignoredProps = ["tout", "SimulationMetadata", "ErrorMessage", "errorStorePH", "errorStoreTemp", "phStore", "tempStore"];

for i = 1:length(history)
   currBatch = history(i);          %batch no. 2
   props = properties(currBatch);   %array of properties ['CL, F, Fa, Fb...']
   fprintf('--[Historical batch #%d]--\n', i);
   
   for j= 1:length(props)
      currProp = props{j};           %'CL'
      runSave = 1;
      
      for k=1:length(ignoredProps)
          if isequal(currProp, ignoredProps(k))
              runSave = 0;
              fprintf('(ignoring property `%s`)', currProp);
          end
      end
      
      if runSave == 1
          currPropValue = currBatch.(currProp).data; %timeseries data
          goldenPropValue = golden1.(currProp).data;
      
          save_string1 = strcat("data/extracted/batch", string(i), string(currProp), ".csv");
          save_string2 = strcat("data/extracted/golden",string(i), string(currProp), ".csv");
          csvwrite( save_string1, currPropValue);
          csvwrite( save_string2, goldenPropValue);
      end
   end
end