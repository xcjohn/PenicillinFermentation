clear all
clc

load('data/historicalBatches.mat');
load('data/goldenBatch.mat');

signal = history(1).CL;
reference = golden1.CL;

plot(signal);
hold on;
plot(reference);
legend ('signal', 'reference');

testSignal = history(1).CL;
testReference = golden1.CL;

tout = [0:1:450];

signal_resampled = resample ( testSignal, tout );
reference_resampled = resample( testReference, tout);




pyversion
% pathToScript = fileparts(which('TestJedd.py'));
% 
% if count(py.sys.path, pathToScript) == 0
%     insert (py.sys.path, int32(0), pathToScript);
% end
% 
% 
sig = py.numpy.array(signal_resampled);
ref = py.numpy.array(reference_resampled);

%pyout = py.tslearn.metrics.dtw_path_limited_warping_length(sig, ref, length(sig))

