function [RandomSet,RandomSetTest,NumModes,Memo,MemoTest] =modegeneration(SimDuration,seed,minSS)
minSS =minSS/0.1;    % 200/0.1 Nb Nb   %% 100/0.1 for the minSS of seed 50
SimDuration = SimDuration/0.1+1;

LSP = [-0.2 0]; %% None of these are allowed to be the same!!
TSP =[10 30]; %[-30 20];
ToDV =[0 0]; %[0 5];%[0 0]; %[-5 0]; %2
TcDV =[0 0]; %[-3 0]; %[0 0];%[-5 0]; %This will only cause minor variance!! and count as a different mode %0.01
FMoDV = [-20 20];%[-20 100];
FBoDV = [-100 0];%[0 300];60


Choices = [LSP;TSP;ToDV;TcDV;FMoDV;FBoDV];


rng(seed)
%random = rand(1);
count = 0;
for i = minSS:minSS:SimDuration
    count = count+1;
    rng(count+seed)
    random = rand(1);
    if count ~= 1
        ChangeTime(count) = (minSS)*random + ChangeTime(count-1)+minSS;
    else
        ChangeTime(count) = (minSS)*random +minSS;
    end
    %   i = ChangeTime(count);
    
end

ChangeTime = ChangeTime(ChangeTime<SimDuration);
ChangeTime = round(ChangeTime);

RandomSet = zeros(size(ChangeTime,1),7);



for j =2:size(ChangeTime,2)
    rng(j+seed)
    
    if j ==1
        desired = Choices(randi(numel(Choices)))
        [idx col] = find(Choices==desired);
        if size(idx,1) > 1
            idx = idx(randi(numel(idx)));
        end
        RandomSet(j,idx) = desired;
        RandomSet(j,end) = ChangeTime(j);
    else
        RandomSet(j,:) = RandomSet(j-1,:);
        desired = Choices(randi(numel(Choices)));
        [idx col] = find(Choices==desired);
        if size(idx,1) > 1
            idx = idx(randi(numel(idx)));
        end
        RandomSet(j,idx) = desired;
        RandomSet(j,end) = ChangeTime(j);
    end
end
[UniqueModes index] = unique(RandomSet(:,1:end-1),'rows');
NumModes = size(UniqueModes,1);
count = 1;
for k =1:NumModes
    for z=2:size(RandomSet,1)
        if sum(UniqueModes(k,:) == RandomSet(z-1,1:end-1))==size(Choices,1)
            %            count = 1;
            if count == 1
                TimeforMode(k) = RandomSet(z,end) - RandomSet(z-1,end);
                
            else
                TimeforMode(k) = TimeforMode(k) + RandomSet(z,end) - RandomSet(z-1,end);
                
                
            end
            count = count+1;
        end
    end
    if z == size(RandomSet,1) && sum(UniqueModes(k,:) == RandomSet(z,1:end-1))==size(Choices,1) && count == 1
        TimeforMode(k) = SimDuration - RandomSet(z,end);
    end
    if z == size(RandomSet,1) && sum(UniqueModes(k,:) == RandomSet(z,1:end-1))==size(Choices,1) && count ~= 1
        TimeforMode(k) = TimeforMode(k) + SimDuration - RandomSet(z,end);
    end
    count =1;
end

[TimeInOrder I] = sort(TimeforMode,'descend');
ModesinOrder = UniqueModes(I,:);

for i = 2:size(RandomSet,1)
    for k =1:NumModes
        if sum(ModesinOrder(k,:) == RandomSet(i-1,1:end-1))==size(Choices,1) && i>2 
            Memo(RandomSet(i-1,end):RandomSet(i,end)) = k;
        end
        if sum(ModesinOrder(k,:) == RandomSet(i-1,1:end-1))==size(Choices,1) && i==2
            Memo(1:RandomSet(i,end)) = k;
        end
        if sum(ModesinOrder(k,:) == RandomSet(i,1:end-1))==size(Choices,1) && i==size(RandomSet,1)
            Memo(RandomSet(i,end):SimDuration) = k;
        end
    end
end
    
    %% Find Proportions (Assuming Transients are negligible)(Arrange in Descending order)(compare to actual order)(in another function combine with SSD)
    
count = 0; 
seed = seed+5;% As long as its not the same as in the Start!!
for i = minSS:minSS:SimDuration
    count = count+1;
    rng(count+seed)
    random = rand(1);
    if count ~= 1
        ChangeTime(count) = (minSS)*random + ChangeTime(count-1)+minSS;
    else
        ChangeTime(count) = (minSS)*random +minSS;
    end
    %   i = ChangeTime(count);
    
end

ChangeTime = ChangeTime(ChangeTime<SimDuration);
ChangeTime = round(ChangeTime);

ChangeTime = ChangeTime(1:size(RandomSet,1));

RandomSetTest = RandomSet;
RandomSetTest(:,end) = ChangeTime';  %This requires that the same time periods are made? or just not more maybe. 
for i = 2:size(RandomSetTest,1)
    for k =1:NumModes
        if sum(ModesinOrder(k,:) == RandomSetTest(i-1,1:end-1))==size(Choices,1) && i>2 
            MemoTest(RandomSetTest(i-1,end):RandomSetTest(i,end)) = k;
        end
        if sum(ModesinOrder(k,:) == RandomSetTest(i-1,1:end-1))==size(Choices,1) && i==2
            MemoTest(1:RandomSetTest(i,end)) = k;
        end
        if sum(ModesinOrder(k,:) == RandomSetTest(i,1:end-1))==size(Choices,1) && i==size(RandomSetTest,1)
            MemoTest(RandomSetTest(i,end):SimDuration) = k;
        end
    end
end

end