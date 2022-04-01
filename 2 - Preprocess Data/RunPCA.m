function [coeff, score, latent, tsquared, explained, mu, PC] = RunPCA(dataset_std)
%performs PCA on a pre-standardized dataset
%wrapper function over the matlab implementation, just calculates and
%returns the PCAs for ease of use

[coeff, score, latent, tsquared, explained, mu] = pca( dataset_std   );

%todo - change this to specify number of PCs to calc (N) and then do it via
%function

PC1 = zeros(length(dataset_std),1);
PC2 = zeros(length(dataset_std),1);
PC3 = zeros(length(dataset_std),1);
PC4 = zeros(length(dataset_std),1);
PC5 = zeros(length(dataset_std),1);
PC6 = zeros(length(dataset_std),1);
PC7 = zeros(length(dataset_std),1);


num_vars = size(dataset_std);

PC1 = dataset_std(:,1)*coeff(1,1); % V1*a
PC2 = dataset_std(:,1)*coeff(1,2); % V1*a
PC3 = dataset_std(:,1)*coeff(1,3); % V1*a
PC4 = dataset_std(:,1)*coeff(1,4); % V1*a
PC5 = dataset_std(:,1)*coeff(1,5); % V1*a
PC6 = dataset_std(:,1)*coeff(1,6); % V1*a
PC7 = dataset_std(:,1)*coeff(1,7); % V1*a

for i=2:num_vars(2)
    PC1 = PC1 + dataset_std(:,i)*coeff(i,1);
    PC2 = PC2 + dataset_std(:,i)*coeff(i,2);
    PC3 = PC3 + dataset_std(:,i)*coeff(i,3);
    PC4 = PC4 + dataset_std(:,i)*coeff(i,4);
    PC5 = PC5 + dataset_std(:,i)*coeff(i,5);
    PC6 = PC6 + dataset_std(:,i)*coeff(i,6);
    PC7 = PC7 + dataset_std(:,i)*coeff(i,7);
end

PC = [PC1 PC2 PC3 PC4 PC5 PC6 PC7];

end

