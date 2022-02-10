function [stationary,probstat] = isstat(X,wSize,alpha,thresh)
count = 0;
sFrq = 1;
total = 0;
alphaover = thresh; %  the bigger more likely to be seen as steady

if wSize<100
    DOF = wSize;
else
    DOF = 100;
end

for i = 1:size(X,2)
    calc(i) = 1-alpha(i);
    tcrit(i) = CritT(alpha(i),DOF,'one'); % Determine Critical t value
end


for z = 1:wSize:size(X,1)
    if z+wSize>size(X,1)    % Reduce final window size such that it fits on final data segment of time series (when window does not perfectly fit in data)
        wSize = size(X,1)-z;
    end
    
    n = wSize;
    D = X(z:(z+wSize)-1,:); % Select data within window
    
    for j=1:size(X,2) % Step through variables
        V = D(:,j)';
        total=0;
        for i = 2:sFrq:n 
            total = total + (V(i)-V(i-1))/sFrq; 
        end
        m(j) = 1/n*total; % Calculate the gradient
        total = 0;
        for  i=1:sFrq:n
            total = total + V(i)-m(j)*(i);
        end
        mu(j) = 1/n*total; % Calculate the mean
        total = 0;
        for i = 1:sFrq:n
            total = total+(V(i)-m(j)*i-mu(j))^2;
        end
        stdev(j) = sqrt(1/(n-2)*total); % Calculate standard deviation
        for i = 1:wSize
            if (abs(V(i)-mu(j)))<(tcrit(j)*stdev(j)) % Perform student's ttest
                y(i) = 1;
            else
                y(i)=0;
            end
        end
        if exist('y') == 1   % For issues with window size, ie last window does conntains no samples
            yvar(:,j) = y;
        else
            yvar(:,j) = Inf;
        end
    end
    yover=prod(yvar,2); % Multivariate extension of the method
    count = count+1;
    probstat(z:z+wSize) = 1/n*sum(yover);  
    if 1/n*sum(yover)>=(1-alphaover) % Deem entire window stationary or transient 
        
        stationary(z:z+wSize) = 1;
    else
        stationary(z:z+wSize) = 0;
        
    end
    clear y
    clear yvar
end

idx = isinf(probstat);   % For issues arising due to window size 
for  z = 1:size(probstat,2)
    if idx(z) == 1
        probstat(z) = probstat(z-1);
    end
end



