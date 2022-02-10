clear all;
clc;

load hald;
%load imports-85; X(:,3:15)
%Data matrix X has 13 continuous variables in columns 3 to 15: wheel-base, length, width, height, curb-weight, engine-size, bore, stroke, compression-ratio, horsepower, peak-rpm, city-mpg, and highway-mpg.

[coeff, score, latent, tsquared, explained, mu] = pca( ingredients   );

idx = find(cumsum(explained)>95,1) %number of components required to explain >95% of variability

figure(1);
biplot(coeff(:,1:2),'scores',score(:,1:2));
figure(2);
plot(explained);