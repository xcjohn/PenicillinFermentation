function [history_trim] = TrimToMin(history)

%given a history struct
%will trim all the trajectories to the lowest common length

%loop through each history object
%all trajectories within a history object are the same length, find the one
%with the lowest of all

t = zeros(1,length(history)); %batch lengths

%% Find the min/max time intervals of all the batches
for i=1:length(history)
    currBatch = history(i);
    t(i) = length( currBatch.S.time );
end

[tmin, minIndex] = min(t); %shortest batch
[tmax, maxIndex] = max(t); %longest batch

%% Modify Batch Data

for i=1:length(history)
    currBatch = history(i);
    props = fieldnames(currBatch);
    
    ti = length(currBatch.S.time);
    
    for j= 1:length(props)
        currProp = props{j};           %'CL'
        
        currData = currBatch.(currProp).data(1:tmin);
        currTime = currBatch.(currProp).time(1:tmin);
        
        ts = timeseries(currData, currTime)
        history_trim(1,i).(currProp) = ts;
    end
end

end

