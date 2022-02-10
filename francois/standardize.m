function [Z, stdparam] = standardize(X, method)
%Matlab PCA function generaly only subtracts mean from dataset, therefore
%uses the covariance method. However sometimes using the correlation matrix
%is more informative, but then both standard deviation and mean have to be
%used in further examples.
if strcmp(method, 'corr') == 1 %If its chosen to standardize according to std and average
[Z, mu,sigma] = zscore(X);
stdparam(1,:) = mu;
stdparam(2,:) = sigma;
end
if strcmp(method, 'cov') == 1 %Only centred according to mean
    Z = bsxfun(@minus,X,mean(X));
    stdparam = mean(X); %requires only one parameter
end
if strcmp(method,'scale')
stdparam(1,:) = min(X);
stdparam(2,:) = max(X);
Z = bsxfun(@rdivide, (X-stdparam(1,:)), (stdparam(2,:)-stdparam(1,:)));
%Z = (X-stdparam(1,:))/(stdparam(2,:)-stdparam(1,:))';
end
% if strcmp(method,'steady')
% [Z,stdparam] = standardizeSS(X,3000);
% %stdparam = 'modeBased';
% end
if strcmp(method, 'none') == 1
stdparam(1,:) = 0;
stdparam(2,:) = 0;
Z = X;
end
if strcmp(method, 'mad') == 1
stdparam(1,:) = median(X);
stdparam(2,:) = mad(X,1);
Z = bsxfun(@rdivide, (X-stdparam(1,:)),stdparam(2,:));
end

