clc
clear all

addpath(genpath('./util/'));

load('data/historicalBatches.mat');
load('data/goldenBatch.mat');

history_new = ResampleHistory(history, 10);
golden_new = ResampleHistory(golden1, 10);

signal    = history_new(1).P';
reference = golden_new.P';

% figure(1);
% plot(signal);
% hold on;
% plot(reference);
% legend ('signal', 'reference');


sig = py.numpy.array(signal);
ref = py.numpy.array(reference);
len = py.numpy.uint(length(reference) + 50 );

disp("calling python module...");

args = pyargs ('global_constraint', "sakoe_chiba", 'sakoe_chiba_radius', 2);

%pyout = py.tslearn.metrics.dtw_path(sig, ref, args );
pyout = py.tslearn.metrics.dtw_path_limited_warping_length(sig, ref, len);

path     = pyout{1};
distance = pyout{2};

for i =1:length(path)
    pair = path{i};
    signal_index =int64( pair{1} ) + 1; %python starts from 0
    ref_index    =int64( pair{2} ) + 1;
    
    sig_new(i) = signal(signal_index);
    ref_new(i) = reference(ref_index);
end


% figure(2);
% plot(sig_new);
% hold on;
% plot(ref_new);