from dtw import *
from numpy import genfromtxt
import matplotlib.pyplot as plt

p = genfromtxt('C:\\Users\\Jedd\\Documents\\MATLAB\\masters\\data\\extracted\\signal_CL.csv', encoding="utf8", skip_header=0)
pr = genfromtxt('C:\\Users\\Jedd\\Documents\\MATLAB\\masters\\data\\extracted\\reference_CL.csv', encoding="utf8", skip_header=0)

print("hello, world!");


#            x   y
#dtwObj = dtw(p, pr, step_pattern="asymmetric", window_type="sakoechiba", window_args={'window_size': 250}, open_end=True, open_begin=True);
dtwObj = dtw(p, pr, step_pattern=rabinerJuangStepPattern(4, "c"), window_type="sakoechiba", window_args={'window_size': 250}, open_end=True, open_begin=True);
print(dtwObj.index1) #for x (query)
print(dtwObj.index2) #for y (Reference)
print(dtwObj.M)
print(dtwObj.N)
dtwObj.plot()
dtwPlotTwoWay(dtwObj, p , pr);


p_new = []; #x, aka (query)
pr_new = []; #y, aka (reference)

for index in dtwObj.index1: #corresponds to x
    p_new.append( p[index] );

for index in dtwObj.index2:  # corresponds to x
    pr_new.append(pr[index]);

plt.plot(p_new);
plt.plot(pr_new);
plt.show();