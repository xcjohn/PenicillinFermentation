function [GlobalEff,LocalEff] = evalEfficiency(determinedmode,X,ModeKPI,conMat)
KPI = X(:,9).*X(:,6)*300- X(:,14)*10;
for i = 1:size(determinedmode,2)
    if determinedmode(i) ~= 0
        LocalEff(i) = (KPI(i)-ModeKPI{determinedmode(i)}(1))/(ModeKPI{determinedmode(i)}(3)-ModeKPI{determinedmode(i)}(1));
    else
        if exist('LocalEff')==1
            LocalEff(i)=LocalEff(i-1);
        else
            LocalEff(i)=0;
        end
    end
end


conMat(conMat<0) = 0;
G = digraph(conMat);
%% Try to get All possible Paths!! (then do the KPI)
for i = 1:size(determinedmode,2)
    count = 0;
    if determinedmode(i) ~= 0
        for j = 1:max(determinedmode)
            if ModeKPI{determinedmode(i)}(2)<ModeKPI{j}(2)
                count = count+1;
                KPIoptions(count) = ModeKPI{j}(2);
                SuggMode(count) = j;
                Path{count}=shortestpath(G,determinedmode(i),SuggMode(count));
            end
        end
        if count~=0
            for k = 1:count
                if isempty(Path{k})==0
                    ActualKPIoptions(k) = KPIoptions(k);
                    ActualPath{k} = Path{k};
                end
            end
            if exist('ActualKPIoptions') ==1
            [BestChoiceKPI(i) int] = max(ActualKPIoptions);
            BestChoiceMode(i)  = ActualPath{int}(end);
            else
               BestChoiceKPI(i) = ModeKPI{determinedmode(i)}(2); 
            end
        else
            BestChoiceKPI(i) = ModeKPI{determinedmode(i)}(2);
        end
        GlobalEff(i) = ModeKPI{determinedmode(i)}(2)/BestChoiceKPI(i);
    else
        if exist('GlobalEff')==1
            GlobalEff(i)=GlobalEff(i-1);
        else
            GlobalEff(i)=0;
        end
    end
    clear ActualKPIoptions
    clear KPIoptions
    clear SuggMode
    clear Path
    clear ActualPath
end
%plotnetwork(statstart,statend,runlength,mostprop,color)

end