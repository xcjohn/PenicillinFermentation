function [seeds] = getseeds(X,stationary,usestat)
    
rng(1) % For Reproducibility
transitions = diff([0; stationary' == 1; 0]); %find where the array goes from non-zero to zero and vice versa
statstart = find(transitions == 1);
statend = find(transitions == -1);
runlength = statend-statstart;
if usestat == 1
    for i = 1:size(statstart,1)
        if statend(i)<size(X,1)
            average(i,:) = mean(X(statstart(i):statend(i),:));
        else
            average(i,:) = mean(X(statstart(i):statend(i)-1,:));
        end
    end
    
    Z = linkage(average,'complete');
    
    for k =1:size(statstart,1)
        clear C
        k
        idx = cluster(Z,'MaxClust',k);
        Sigma(:,:,k) = diag(std(X));
        prop = 1/k*ones(1,k);
        for z = 1:k
            C(z,1:size(X,2)) = mean(average(idx==z,:),1);
        end
        seeds{k} = struct('mu',C,'Sigma',Sigma,'ComponentProportion',prop);
        clear C
    end
end
if usestat == 2  %% Matlabs default method
    for k = 1:15%size(statstart,1)
        [idx C] = kmeans(X,k,'Replicates',10);
        for j = 1:k
            Sigma(:,:,j) = diag(std(X));
        end
        prop = 1/k*ones(1,k);
        seeds{k} = struct('mu',C,'Sigma',Sigma,'ComponentProportion',prop);
    end
end
if usestat == 3  %Feed GMM with index
    for k = 1:15
        [idx C] = kmeans(X,k,'Replicates',10);
        seeds{k} = idx;
    end
end




% for j = 1:k
%     Sigma(:,:,j) = diag(std(X));
% end
% prop = 0.5*ones(1,k);
% seeds = struct('mu',C,'Sigma',Sigma,'ComponentProportion',prop);
% end