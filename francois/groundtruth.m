function [stationary] = groundtruth(X,SP,DVset,DVact)
%% SS Vals
T = 121;
L = 0.98;
Fmo = 100;
Fbo = 1000;
To = 75;
Tc = 60;
stationary = ones(size(X,1),1);
%% Start UP
stationary(1:72)=0; %% Transient start up period for first 10 hours %Change the time the controller starts (was 10 )
%% Find times of disturbance or SP Change
transonset = sum(ischange(SP),2);
transstartSP = find(transonset ~= 0);
transonset = sum(ischange(DVset),2);
transstartDV  = find(transonset ~= 0); 
transstart = [transstartSP' transstartDV'];
transstart = (unique(transstart)-2)'; % -2 to adjust for late trans in effect detection
%transstart = unique(round(transstart/60)*60);
%% Rest of the transitions due to SP changes and DVs (SP - T, L) (DV-To,Tc,Fb,Fm)
count = 0;
for i = 0:size(transstart,1)-1
    count = 0;
    for z = transstart(i+1):size(X,1)%(transstart(i+2)-1)
        if count ~= 1
            if sum(abs((X(z:z+60,12))-(SP(transstart(i+1)+15,1)+T))<=1)/61>=0.9  && sum(abs((X(z:z+60,5))-(SP(transstart(i+1)+15,2)+L))<=0.01)/61>=0.95 && sum(abs((DVact(z:z+60,4))-(DVset(transstart(i+1)+15,4)+Fmo))<=1)/61>=0.95  && sum(abs((DVact(z:z+60,3))-(DVset(transstart(i+1)+15,3)+Fbo))<=1)/61>=0.95 &&  sum(abs((DVact(z:z+60,2))-(DVset(transstart(i+1)+15,2)+Tc))<=1)/61>=0.95  && sum(abs((DVact(z:z+60,1))-(DVset(transstart(i+1)+15,1)+To))<=1)/61>=0.95 % was 5 for Fmo
                stationary(transstart(i+1):z) =0;
                count = 1;
            end
        end 
    end
end

end

