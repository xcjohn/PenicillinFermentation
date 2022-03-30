%% You can use GMMs to perform either hard clustering or soft clustering on query data.

% To perform hard clustering, the GMM assigns query data points to the multivariate normal components 
% that maximize the component posterior probability, given the data. That is, given a fitted GMM, 
% cluster assigns query data to the component yielding the highest posterior probability. 
% Hard clustering assigns a data point to exactly one cluster.

% Additionally, you can use a GMM to perform a more flexible clustering on data, 
% referred to as soft (or fuzzy) clustering. Soft clustering methods assign a score to a data point for each cluster. 
% The value of the score indicates the association strength of the data point to the cluster. 
% As opposed to hard clustering methods, soft clustering methods are flexible 
% because they can assign a data point to more than one cluster. When you perform GMM clustering, the score is the posterior probability.


%% For GMMs, follow these best practices:
    % Consider the component covariance structure. You can specify diagonal or full covariance matrices, and whether all components have the same covariance matrix.
    % Specify initial conditions. The Expectation-Maximization (EM) algorithm fits the GMM. As in the k-means clustering algorithm, EM is sensitive to initial conditions and might converge to a local optimum. You can specify your own starting values for the parameters, specify initial cluster assignments for data points or let them be selected randomly, or specify use of the k-means++ algorithm.
    % Implement regularization. For example, if you have more predictors than data points, then you can regularize for estimation stability.



%% When to Regularize
% Sometimes, during an iteration of the EM algorithm, a fitted covariance matrix can become ill conditioned, which means the likelihood is escaping to infinity. This problem can happen if one or more of the following conditions exist:
% You have more predictors than data points.
% You specify fitting with too many components.
% Variables are highly correlated.

% (Using PC's + DBSCAN input + multiple batches means regularization not
% requried)

%% Tuning GMMs
    % the number of components k and appropriate covariance structure Σ are unknown. One way you can tune a GMM is by comparing information criteria.
    % Two popular information criteria are the Akaike Information Criterion (AIC) and Bayesian Information Criterion (BIC).
    % Both the AIC and BIC take the optimized, negative loglikelihood and then penalize it with the number of parameters in the model (the model complexity). However, the BIC penalizes for complexity more severely than the AIC.
    % A good practice is to look at both criteria when evaluating a model. Lower AIC or BIC values indicate better fitting models. Also, ensure that your choices for k and the covariance matrix structure are appropriate for your application.
    % fitgmdist stores the AIC and BIC of fitted gmdistribution model objects in the properties AIC and BIC. You can access these properties by using dot notation.

%% Input Data

clear all;
clc;
clf;

%% Load Dataset
labels = ["Alcohol", "Malic acid", "Ash", "Alcalinity of ash", "Magnesium","Total phenols", "Flavanoids", "Nonflavanoid phenols", "Proanthocyanins", "Color intensity", "Hue", "OD280/OD315", "Proline" ];
ImportKaggleWine; % --> wineclustering (table)
dataset_raw = wineclustering;

%% Center and Scale Dataset
[dataset_Standardized, means, stds] = StandardizeUnfolded(dataset_raw);
dataset_Standardized = table2array(dataset_Standardized);

%% REDUCE DIMENSIONALITY VIA PCA
[coeff, score, latent, tsquared, explained, mu] = pca( dataset_Standardized  );

PC1 = zeros(length(dataset_Standardized),1);
PC2 = zeros(length(dataset_Standardized),1);
PC3 = zeros(length(dataset_Standardized),1);

num_vars = size(dataset_Standardized);

PC1 = dataset_Standardized(:,1)*coeff(1,1); % V1*a
PC2 = dataset_Standardized(:,1)*coeff(1,2); 
PC3 = dataset_Standardized(:,1)*coeff(1,2); 

for i=2:num_vars(2)
    PC1 = PC1 + dataset_Standardized(:,i)*coeff(i,1);
    PC2 = PC2 + dataset_Standardized(:,i)*coeff(i,2);
    PC3 = PC3 + dataset_Standardized(:,i)*coeff(i,3);
end


X = [PC1, PC2, PC3];



%% Tune GMM

k_est = 4; %Estimated number of GMM components, as determined by K-means/DBSCAN
       %Search around these area

k = (k_est-2):(k_est+2);
nK = numel(k);
Sigma = {'full'};
nSigma = numel(Sigma);
SharedCovariance = {false};
SCtext = {'false'};
nSC = numel(SharedCovariance);
RegularizationValue = 0.01;
options = statset('MaxIter',10000);

% Preallocation
gm = cell(nK,nSigma,nSC);         
aic = zeros(nK,nSigma,nSC);
bic = zeros(nK,nSigma,nSC);
converged = false(nK,nSigma,nSC);

% Fit all models
for m = 1:nSC
    for j = 1:nSigma
        for i = 1:nK
            gm{i,j,m} = fitgmdist(X,k(i),...
                'CovarianceType',Sigma{j},...
                'SharedCovariance',SharedCovariance{m},...
                'RegularizationValue',RegularizationValue,...
                'Options',options);
            aic(i,j,m) = gm{i,j,m}.AIC;
            bic(i,j,m) = gm{i,j,m}.BIC;
            converged(i,j,m) = gm{i,j,m}.Converged;
        end
    end
end

allConverge = (sum(converged(:)) == nK*nSigma*nSC)

figure
bar(reshape(aic,nK,nSigma*nSC))
title('AIC For Various $k$ and $\Sigma$ Choices','Interpreter','latex')
xlabel('$k$','Interpreter','Latex')
ylabel('AIC')
legend({'Full-unshared'})

figure
bar(reshape(bic,nK,nSigma*nSC))
title('BIC For Various $k$ and $\Sigma$ Choices','Interpreter','latex')
xlabel('$c$','Interpreter','Latex')
ylabel('BIC')
legend({'Full-unshared'})

gmBest = gm{3,1,1};
clusterX = cluster(gmBest,X);
kGMM = gmBest.NumComponents;
d = 500;
x1 = linspace(min(X(:,1)) - 2,max(X(:,1)) + 2,d);
x2 = linspace(min(X(:,2)) - 2,max(X(:,2)) + 2,d);
x3 = linspace(min(X(:,3)) - 2,max(X(:,3)) + 2,d);
[x1grid,x2grid, x3grid] = meshgrid(x1,x2, x3);
X0 = [x1grid(:) x2grid(:) x3grid(:)];
mahalDist = mahal(gmBest,X0);
threshold = sqrt(chi2inv(0.99,2));

figure
h1 = gscatter(X(:,1),X(:,2),clusterX);
hold on
for j = 1:kGMM
    idx = mahalDist(:,j)<=threshold;
    Color = h1(j).Color*0.75 + -0.5*(h1(j).Color - 1);
    h2 = plot(X0(idx,1),X0(idx,2),'.','Color',Color,'MarkerSize',1);
    uistack(h2,'bottom')
end
plot(gmBest.mu(:,1),gmBest.mu(:,2),'kx','LineWidth',2,'MarkerSize',10)
title('Clustering [GMM, unshared/full');
xlabel('PC1')
ylabel('PC2')
legend(h1,'Cluster 1','Cluster 2','Cluster 3','Location','NorthWest')
hold off