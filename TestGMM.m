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

load fisheriris;
X = meas(:,1:2);
[n,p] = size(X);

plot(X(:,1),X(:,2),'.','MarkerSize',15);
title('Data set');
xlabel('Sepal length (cm)');
ylabel('Sepal width (cm)');

rng(3);
k = 3; % Number of GMM components
options = statset('MaxIter',1000);

Sigma = {'diagonal','full'}; % Options for covariance matrix type
nSigma = numel(Sigma);

%% Geometrically, the covariance structure determines the shape of a confidence ellipsoid drawn over a cluster. 

SharedCovariance = {true,false}; % Indicator for identical or nonidentical covariance matrices
SCtext = {'true','false'};
nSC = numel(SharedCovariance);

d = 500; % Grid length
x1 = linspace(min(X(:,1))-2, max(X(:,1))+2, d);
x2 = linspace(min(X(:,2))-2, max(X(:,2))+2, d);
[x1grid,x2grid] = meshgrid(x1,x2);
X0 = [x1grid(:) x2grid(:)];

threshold = sqrt(chi2inv(0.99,2));
count = 1;
for i = 1:nSigma
    for j = 1:nSC
        gmfit = fitgmdist(X,k,'CovarianceType',Sigma{i}, ...
            'SharedCovariance',SharedCovariance{j},'Options',options); % Fitted GMM
        clusterX = cluster(gmfit,X); % Cluster index 
        mahalDist = mahal(gmfit,X0); % Distance from each grid point to each GMM component
        % Draw ellipsoids over each GMM component and show clustering result.
        subplot(2,2,count);
        h1 = gscatter(X(:,1),X(:,2),clusterX);
        hold on
            for m = 1:k
                idx = mahalDist(:,m)<=threshold;
                Color = h1(m).Color*0.75 - 0.5*(h1(m).Color - 1);
                h2 = plot(X0(idx,1),X0(idx,2),'.','Color',Color,'MarkerSize',1);
                uistack(h2,'bottom');
            end    
        plot(gmfit.mu(:,1),gmfit.mu(:,2),'kx','LineWidth',2,'MarkerSize',10)
        title(sprintf('Sigma is %s\nSharedCovariance = %s',Sigma{i},SCtext{j}),'FontSize',8)
        legend(h1,{'1','2','3'})
        hold off
        count = count + 1;
    end
end