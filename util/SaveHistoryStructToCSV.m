function [] = SaveHistoryStructToCSV(history, prefix, ignoredProps)


for i = 1:length(history)
   currBatch = history(i);          %batch no. 2
   props = fieldnames(currBatch);   %array of properties ['CL, F, Fa, Fb...']
   fprintf('--[Input batch #%d]--\n', i);
   
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
          currPropValue = currBatch.(currProp)';
          currTimeArray = currBatch.tout';
          %goldenPropValue = golden1.(currProp);
      
          save_string1 = strcat("data/extracted/",prefix, string(i), string(currProp), ".csv");
          %save_string2 = strcat("data/extracted/golden",string(i), string(currProp), ".csv");
          %csvwrite( save_string1, [currTimeArray currPropValue]);
          dlmwrite( save_string1, [currTimeArray currPropValue], 'delimiter', ';');
          %csvwrite( save_string2, goldenPropValue);
      end
   end
end

end

