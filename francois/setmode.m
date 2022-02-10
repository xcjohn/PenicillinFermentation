function notrans = setmode(idx,wSize)
for i = 1:wSize:size(idx,1)
    if i+wSize>size(idx,1)    % Reduce final window size such that it fits on final data segment of time series (when window does not perfectly fit in data)
        wSize = size(idx,1)-i;
    end
    notrans(i:i+wSize) = mode(idx(i:i+wSize));
end
end