function [stationary,probstat] = isstatshift(X,wSize,alpha,thresh,delay)
count = 0;
sFrq = 1; % Sampling Frequency (keep at 1)
total = 0;
alphaover = thresh; % the bigger more likely to be seen as steady

if wSize<100  % Set the degrees of freedom to the size of the Window
    DOF = wSize;
else
    DOF = 100;
end

for i = 1:size(X,2)
    tcrit(i) = CritT(alpha(i),DOF,'one');  % Determine the Critical t
end


for z = wSize:1:size(X,1) % Step through window
    
    n = wSize;
    D = X(z-wSize+1:z,:); % Group data within window
    
    for j=1:size(X,2) % Step through variables
        V = D(:,j)';
        total=0;
        for i = 2:sFrq:n
            total = total + (V(i)-V(i-1))/sFrq;
        end
        m(j) = 1/n*total; % Calculate the gradient or drift
        total = 0;
        for  i=1:sFrq:n
            total = total + V(i)-m(j)*(i);
        end
        mu(j) = 1/n*total; % Calculate the mean
        total = 0;
        for i = 1:sFrq:n
            total = total+(V(i)-m(j)*i-mu(j))^2;
        end
        stdev(j) = sqrt(1/(n-2)*total); % Calculate the standard deviation
        for i = 1:wSize
            if (abs(V(i)-mu(j)))<(tcrit(j)*stdev(j)) % Perform the student's ttest
                y(i) = 1; % Accepts Hypothesis for variable and sample
            else
                y(i)=0;   % Rejects Hypothesis for variable and sample
            end
        end
        if exist('y') == 1  % Adjusting for end of time series data set (window does exceeds bounds of time series)
            yvar(:,j) = y;
        else
            yvar(:,j) = Inf;
        end
    end
    yover=prod(yvar,2);  % Multivariate adjustment of the SSD technique
    count = count+1;
    probstat(z-delay) = 1/n*sum(yover);  % Assign the Steadiness value to a sample, considering delay
    if 1/n*sum(yover)>=(1-alphaover)     % Final Steady verdict for sample, either 1 (steady) or 0 (transient)
        
        stationary(z-delay) = 1;
    else
        stationary(z-delay) = 0;
        
    end
    clear y
    clear yvar
end

idx = isinf(probstat);
for  z = 1:size(probstat,2)  % Adjusting for end of time series data set (window does exceeds bounds of time series)
    if idx(z) == 1
        probstat(z) = probstat(z-1);
    end
end