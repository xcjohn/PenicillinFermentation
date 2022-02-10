function [NLLP,thresh] = detNLLPlocalThresh(gm,scores,percentile)
weight = gm.ComponentProportion;
mean = gm.mu;
cov = gm.Sigma;
if gm.SharedCovariance == 1
    for j = 1:size(mean,1)
        for i = 1:size(scores,1)
            density(i,j) =  ((2*pi())^(-1*size(mean(j,:),2)/2))*(det(cov)^(-1/2))*exp(-1/2*(scores(i,:)-mean(j,:))*inv(cov)*(scores(i,:)-mean(j,:))'); %Probability density Via multivariate gasussian ditribution
        end
    end
else
    for j = 1:size(mean,1)
        for i = 1:size(scores,1)
            density(i,j) =  ((2*pi())^(-1*size(mean(j,:),2)/2))*(det(cov(:,:,j))^(-1/2))*exp(-1/2*(scores(i,:)-mean(j,:))*inv(cov(:,:,j))*(scores(i,:)-mean(j,:))');
        end
    end
end
NLLP = -log(sum(weight.*density,2));
P = posterior(gm,scores); % Determining Posterior Probability
for z = 1:size(P,1) % Determine best matching cluster
    [prop(z) BMC(z)] = max(P(z,:));
end
for r = 1:max(BMC) % Determine threshold based on percentile for each mode
    thresh(r) = prctile(NLLP(BMC == r),percentile); %99
end
end