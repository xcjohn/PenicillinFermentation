from dtw import *
from numpy import genfromtxt
import matplotlib.pyplot as plt

#p = genfromtxt('C:\\Users\\Jedd\\Documents\\MATLAB\\masters\\data\\extracted\\signal_CL.csv', encoding="utf8", skip_header=0)
#pr = genfromtxt('C:\\Users\\Jedd\\Documents\\MATLAB\\masters\\data\\extracted\\reference_CL.csv', encoding="utf8", skip_header=0)

p = genfromtxt('C:\\Users\\JOrsmond\\MATLAB\\projects\\masters\\data\\extracted\\golden1P.csv', delimiter=";", usecols=1, skip_header=1)
pr = genfromtxt('C:\\Users\\JOrsmond\\MATLAB\\projects\\masters\\data\\extracted\\batch2P.csv', delimiter=";", usecols=1, skip_header=1)

print("hello, world!");

print(p);
print(pr);

#Notes: step_pattern=asymmetric ---> terrible.
#                   =asymmetricP2--> best.
#                   =rabinerJuange-> okay.

dtwObj = dtw(p, pr, step_pattern=asymmetricP2, keep_internals=True);
#dtwObj = dtw(p, pr, step_pattern=asymmetricP2, keep_internals=True, window_type="sakoechiba", window_args={"window_size":250*10});

#dtwObj = dtw(p, pr, step_pattern=rabinerJuangStepPattern(4, "c"), keep_internals=True);


#dtwObj = dtw(p, pr, step_pattern=rabinerJuangStepPattern(4, "c"), keep_internals=True, window_type="sakoechiba", window_args={'window_size': 250});
print(dtwObj.index1) #for x (query)
print(dtwObj.index2) #for y (Reference)
print(dtwObj.N)
print(dtwObj.M)
dtwObj.plot()
dtwPlotTwoWay(dtwObj, p , pr);



p_new = []; #x, aka (query)
pr_new = []; #y, aka (reference)

for index in dtwObj.index1: #corresponds to x
    p_new.append( p[index] );

for index in dtwObj.index2:  # corresponds to x
    pr_new.append(pr[index]);

plt.plot(p_new); #query
plt.plot(pr_new); #reference
plt.show();


query = dtwObj.query;
ref = dtwObj.reference;
query_warpfunc = dtwObj.index1;
ref_warpfunc = dtwObj.index2;

print(query);
print(query_warpfunc);
print(ref_warpfunc);


#            x   y
#dtwObj = dtw(p, pr, step_pattern="asymmetric", window_type="sakoechiba", window_args={'window_size': 250}, open_end=True, open_begin=True);
# dtwObj = dtw(p, pr, step_pattern=rabinerJuangStepPattern(4, "c"), window_type="sakoechiba", window_args={'window_size': 250}, open_end=True, open_begin=True);
# print(dtwObj.index1) #for x (query)
# print(dtwObj.index2) #for y (Reference)
# print(dtwObj.M)
# print(dtwObj.N)
# dtwObj.plot()
# dtwPlotTwoWay(dtwObj, p , pr);
#
#
# p_new = []; #x, aka (query)
# pr_new = []; #y, aka (reference)
#
# for index in dtwObj.index1: #corresponds to x
#     p_new.append( p[index] );
#
# for index in dtwObj.index2:  # corresponds to x
#     pr_new.append(pr[index]);
#
# plt.plot(p_new);
# plt.plot(pr_new);
# plt.show();