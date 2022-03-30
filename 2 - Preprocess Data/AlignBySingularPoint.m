function [historySP] = AlignBySingularPoint(history, s_threshold, timestep)
%default values:
% s_threshold = 0.3;
% timestep = 0.01;


%basic comparison alignment using SP
%The SP in this case would be the point at which batch->fedbatch mode.
%this is done at S=0.3g/mol

%strategy - determine this time index for each batch
%the batch with the last (latest) time index = t2 (time2)
%the batch with the first (earliest) time index = t1
%shift the data entries for each batch according: SHIFT LEFT = (ti-t1)
%apply this to all the variables

%cut the total batch length by the amount (t2-t1) i.e. the length of the
%shortest batch

t = zeros(1,length(history))

%% Determine Relevant Indices
for i=1:length(history)
    currBatch = history(i);
    currBatchS = currBatch.S;
    
    ti = 1; %set index to first value
    while currBatchS.data(ti) > s_threshold
        ti = ti + 1;
    end
    
    t(i) = ti;
    
    fprintf('index determined to be %d\n', ti);
end

[t1, minIndex] = min(t)
[t2, maxIndex] = max(t)

%% Modify Batch Data
ignoredProps = ["tout", "SimulationMetadata", "ErrorMessage", "errorStorePH", "errorStoreTemp", "phStore", "tempStore"];

for i=1:length(t)
    fprintf('batch #%d\n', i);
    if (i~=99999) %removed this constraint, it actually wasn't necessary. hitting batch#(t_min) just results in no action.
        currBatch = history(i);
        
        props = properties(currBatch);   %array of properties ['CL, F, Fa, Fb...']
        
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
                currData = currBatch.(currProp).data;
                currTime = currBatch.(currProp).time;
                
                ti = t(i);
                currData = currData( (ti-t1 + 1):end);
                newTime = [0:0.01:((length(currData)-1)*timestep)]';
                ts = timeseries(currData, newTime)
                historySP(1,i).(currProp) = ts;
            end
            
        end
        
    end
end

end

