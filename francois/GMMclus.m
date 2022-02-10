function [gmfit,BIC,idx,TrainData] = GMMclus(X,k,Sigma,SharedCovariance,idx,merge,delete)          
%% For reproducibility and setting maximum Number Iters
rng(3);
options = statset('MaxIter',1000,'Display','final');


%% Fitting
gmfit = fitgmdist(X,k,'CovarianceType',Sigma,'SharedCovariance',SharedCovariance,'Options',options,'Start',idx,'RegularizationValue',0.00001); % Finds Centres of the clusters
BIC = gmfit.BIC;
[gmfit] = reaarrangegmdist(gmfit); % Store in descending propotions

clusterX = cluster(gmfit,X); % pxtuartitions the data in X into k clusters determined by the k Gaussian mire components %%%This is importanat!!! How?
idx = clusterX;
TrainData = X;
%% Merge Gaussians and Refit
if merge == 1
    [adjIDX,consec] = countconsecutive(idx,20,gmfit,X);
    gmfit = fitgmdist(X,max(adjIDX),'CovarianceType',Sigma,'SharedCovariance',SharedCovariance,'Options',options,'Start',adjIDX,'RegularizationValue',0.00001);
    [gmfit] = reaarrangegmdist(gmfit);
    idx = cluster(gmfit,X);%idx = adjIDX;  Actually also fine, since I always assign it to the heaviest (lowest index) cluster!
    TrainData = X;
end

%% Delete Gaussians and Make new Traning Data
if delete == 1
    [gmfit,TrainData,adjIDX] = removetrans(X,gmfit,0.037,idx,Sigma,SharedCovariance,options);
    idx = adjIDX;
end



end
