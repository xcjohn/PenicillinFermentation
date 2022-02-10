function [gmfit,adjData,adjIDX] = removetrans(X,gmfit,thresh,idx,Sigma,SharedCovariance,options)
[gmfit] = reaarrangegmdist(gmfit);

newgm.mu = gmfit.mu(gmfit.ComponentProportion>=thresh,:);
newgm.ComponentProportion = gmfit.ComponentProportion(gmfit.ComponentProportion>=thresh);

if gmfit.SharedCovariance == 1
gmfit.Sigma = gmfit.Sigma;  %Will have to fix this
else
    newgm.Sigma = gmfit.Sigma(:,:,gmfit.ComponentProportion>=thresh);
end
gmfit = gmdistribution(newgm.mu,newgm.Sigma,newgm.ComponentProportion);
adjData = X(idx <= size(gmfit.ComponentProportion,2),:);  % Remove all samples that are considered "transient", so they wont effect the mode thresholds
adjIDX = idx(idx <= size(gmfit.ComponentProportion,2));
%% Fit again so that weights add up to 1
gmfit = fitgmdist(adjData,max(adjIDX),'CovarianceType',Sigma,'SharedCovariance',SharedCovariance,'Options',options,'Start',adjIDX,'RegularizationValue',0.00001);
[gmfit] = reaarrangegmdist(gmfit);
end