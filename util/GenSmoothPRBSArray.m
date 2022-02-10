function uArray=GenSmoothPRBSArray(T,deltaT,uRef,span)
% This function returns a sequence of input array 
% Input
% T:            Total simulation time
% deltaT:       sampling interval
% uRef:         constant reference level
% span:         the span of the signal
% Output
% uArray:       The first column is the time instance, the second is the
%               input values using PRBS
N=fix(T/deltaT);

warning('off','Ident:dataprocess:idinput7');% disable warning message from prbs command.
prbsArray=idinput(1.2*N,'prbs');% produce redundant prbs signals 

index=randi(1.2*N,[N+1,1]);%prbs is pseudo random, using this method to generate differnt signals
rand_prbsArray=prbsArray(index);


Arr=uRef+span*rand_prbsArray;
Arr=smooth(Arr,fix(0.1*N),'loess');% using Local regression using weighted linear least squares and a 2nd degree polynomial model


uArray(:,1)=0:deltaT:T;
uArray(:,2)=Arr;
% plot(uArray(:,1),uArray(:,2));