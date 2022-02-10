function [output] = ApplyWarpingPath(signal, p)
%given a Signal, apply a warping path to create a new signal
%warping path (p) - a sequence of indices (monotonically increasing) of the
%original signal that would represent the modified (synchronized) new
%signal

output = zeros(1, length(p) );

for i=1:length(p)
    index = p(i);
    output(i) = signal(index);
end
end

