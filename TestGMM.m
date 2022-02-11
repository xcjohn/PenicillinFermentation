% You can use GMMs to perform either hard clustering or soft clustering on query data.
% 
% To perform hard clustering, the GMM assigns query data points to the multivariate normal components 
% that maximize the component posterior probability, given the data. That is, given a fitted GMM, 
% cluster assigns query data to the component yielding the highest posterior probability. 
% Hard clustering assigns a data point to exactly one cluster.
% 
% Additionally, you can use a GMM to perform a more flexible clustering on data, 
% referred to as soft (or fuzzy) clustering. Soft clustering methods assign a score to a data point for each cluster. 
% The value of the score indicates the association strength of the data point to the cluster. 
% As opposed to hard clustering methods, soft clustering methods are flexible 
% because they can assign a data point to more than one cluster. When you perform GMM clustering, the score is the posterior probability.


% For GMMs, follow these best practices:
    % Consider the component covariance structure. You can specify diagonal or full covariance matrices, and whether all components have the same covariance matrix.
    % Specify initial conditions. The Expectation-Maximization (EM) algorithm fits the GMM. As in the k-means clustering algorithm, EM is sensitive to initial conditions and might converge to a local optimum. You can specify your own starting values for the parameters, specify initial cluster assignments for data points or let them be selected randomly, or specify use of the k-means++ algorithm.
    % Implement regularization. For example, if you have more predictors than data points, then you can regularize for estimation stability.