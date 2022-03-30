clc

load('data/signal.csv');
load('data/reference.csv');

figure(1);
plot(signal);
hold on;
plot(reference);
legend ('signal', 'reference');

pyversion
% pathToScript = fileparts(which('TestJedd.py'));
% 
% if count(py.sys.path, pathToScript) == 0
%     insert (py.sys.path, int32(0), pathToScript);
% end

sig = py.numpy.array(signal);
ref = py.numpy.array(reference);

args = pyargs ('global_constraint', "sakoe_chiba", 'sakoe_chiba_radius', 3);

pyout = py.tslearn.metrics.dtw_path(sig, ref, args );
%pyout = py.tslearn.metrics.dtw_path_limited_warping_length(sig, ref, size(signal), args)

path = pyout{1};
distance = pyout{2};

for i =1:length(path)
    pair = path{i};
    signal_index =int64( pair{1} ) + 1; %python starts from 0
    ref_index    =int64( pair{2} ) + 1;
    
    sig_new(i) = signal(signal_index);
    ref_new(i) = reference(ref_index);
end
figure(2);
plot(sig_new);
hold on;
plot(ref_new);