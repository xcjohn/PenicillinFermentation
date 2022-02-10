addpath(genpath('./util/'));

signal    = history_new(2).P';
reference = golden_new.P';

sig = py.numpy.array(signal);
ref = py.numpy.array(reference);

%dtwObj = dtw(p, pr, step_pattern=rabinerJuangStepPattern(4, "c"), window_type="sakoechiba", window_args={'window_size': 250}, open_end=True, open_begin=True);

%args = pyargs ('global_constraint', "sakoe_chiba", 'sakoe_chiba_radius', 2);

%args = pyargs ("step_pattern", "asymmetric");

pyout = py.dtw.dtw(sig, ref);
