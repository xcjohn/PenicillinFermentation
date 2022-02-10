function [modeNLLP,PropThresh,NLLP] = detmode(gm,scores,NLLPthresh) %[modeMahal modeNLLP,disthresh,PropThresh,dBMC,NLLP] = detmode(gm,scores,d2thresh,NLLPthresh)
weight = gm.ComponentProportion;
mean = gm.mu;
cov = gm.Sigma;
% if gm.SharedCovariance == 1
%     for j = 1:size(mean,1)
%         for i = 1:size(scores,1)
%             d2(i,j) =  (scores(i,:)-mean(j,:))*inv(cov)*(scores(i,:)-mean(j,:))';
%         end
%     end
% else
%     for j = 1:size(mean,1)
%         for i = 1:size(scores,1)
%             d2(i,j) =  (scores(i,:)-mean(j,:))*inv(cov(:,:,j))*(scores(i,:)-mean(j,:))';
%         end
%     end
% end
% for z = 1:size(d2,1)
%     [dBMC(z) BMC(z)] = min(d2(z,:));
%     disthresh(z) = d2thresh(BMC(z)); % For plotting
%     if dBMC(z) <= d2thresh(BMC(z))
%         modeMahal(z) = BMC(z);
%     else
%         modeMahal(z) = 0;
%     end
% end

if gm.SharedCovariance == 1
    for j = 1:size(mean,1)
        for i = 1:size(scores,1)
            density(i,j) =  ((2*pi())^(-1*size(mean(j,:),2)/2))*(det(cov)^(-1/2))*exp(-1/2*(scores(i,:)-mean(j,:))*inv(cov)*(scores(i,:)-mean(j,:))');
        end
    end
else
    for j = 1:size(mean,1)
        for i = 1:size(scores,1)
            density(i,j) =  ((2*pi())^(-1*size(mean(j,:),2)/2))*(det(cov(:,:,j))^(-1/2))*exp(-1/2*(scores(i,:)-mean(j,:))*inv(cov(:,:,j))*(scores(i,:)-mean(j,:))');
        end
    end
end


NLLP = -log(sum(weight.*density,2)); %NLPDF
P = posterior(gm,scores);
for z = 1:size(NLLP,1)
    [postprob(z) bmcNLLP(z)] = max(P(z,:));
    PropThresh(z) = NLLPthresh(bmcNLLP(z)); %For plotting
    if NLLP(z) <= NLLPthresh(bmcNLLP(z))
        modeNLLP(z) = bmcNLLP(z); %was BMC, but thats wrong?
    else
        modeNLLP(z) = 0;  % For RI to work??
    end
end


end