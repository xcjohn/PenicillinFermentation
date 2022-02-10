function [retainedPC, stdparam, eigenvals,V,scores] = PCmodel(X,method,cumThresh)
[Z, stdparam] = standardize(X, method); %standardizeaccording to chosen method, mean centred or zscore 
VCovM = cov(Z); %obtain variance covariance matrix
[V, D] = eig(VCovM); %find eigenvectors
V = fliplr(V); %flip matrix, such that eigenvector and value that explains most variance appears first
D = fliplr(D);
eigenvals = sum(D);
tot = sum(sum(D)); 
varExp = sum(D)/tot; %Determine % explained variance for each eigenvector

cumVarExp = cumsum(varExp); %Cumalitive explained variance 
count = 0;
for i = 1:max(size(V)) %choosing number of retained PCs for model
    if count ~= 1
    if cumVarExp(i)>=cumThresh %Retained variance cutoff 
        retainedPC = V(:,1:i);
        count = 1;
        pos = i;
    end
    end
end
%retainedPC = V(:,:);
scores = Z*retainedPC;
reportb = ['The number of retained PCs is ', num2str(size(retainedPC,2)), ', which explain ', num2str(100*cumVarExp(pos)),'% of the variance'];
disp(reportb)
end
    