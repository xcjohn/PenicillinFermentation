function [rearrangedgm] = reaarrangegmdist(gmfit)

[order I] = sort(gmfit.ComponentProportion,'descend');
rearrangedgm.ComponentProportion = order;
rearrangedgm.mu = gmfit.mu(I,:);
if gmfit.SharedCovariance == 1
rearrangedgm.Sigma = gmfit.Sigma;
else
    rearrangedgm.Sigma = gmfit.Sigma(:,:,I);
end
rearrangedgm = gmdistribution(rearrangedgm.mu,rearrangedgm.Sigma,rearrangedgm.ComponentProportion);

% %rearrangedgm.NumVariables = gmfit.NumVariables;
% %rearrangedgm.DistributionName = gmfit.DistributionName;
% %rearrangedgm.NumComponents = gmfit.NumComponents;
% %rearrangedgm.SharedCovariance = gmfit.SharedCovariance;
% %rearrangedgm.NumIterations = gmfit.NumIterations;
% %rearrangedgm.RegularizationValue = gmfit.RegularizationValue;
% rearrangedgm.NegativeLogLikelihood = gmfit.NegativeLogLikelihood;
% rearrangedgm.CovarianceType = gmfit.CovarianceType;
% rearrangedgm.AIC = gmfit.AIC;
% rearrangedgm.BIC = gmfit.BIC;
% rearrangedgm.Converged = gmfit.Converged;
% rearrangedgm.ProbabilityTolerance = gmfit.ProbabilityTolerance;


end