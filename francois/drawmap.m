function [ModeKPI,conMat] = drawmap(stationary,gmfit,scoresTrain,SP,leadTime,Nthresh,X) 

transitions = diff([0; stationary' == 1; 0]); %find where the array goes from non-zero to zero and vice versa
statstart = find(transitions == 1);
statend = find(transitions == -1);
runlength = statend-statstart;

[modeNLLP,PropThresh,NLLP] = detmode(gmfit,scoresTrain,Nthresh);
determinedmode = modeNLLP;



for i = 1:size(statstart,1)
    mostprop(i) = mode(determinedmode(statstart(i):statend(i)-1)); %Could be prone to error if the analysis is completely wrong
    % transitions will be automatically be set to state 0
end




modes = unique(mostprop);
conMat = zeros(size(modes,2)); %rather unique?
how = cell(size(modes,2));


%% KPI per unit in Simulation
for i = 1:size(statstart,1)
    TrainedModes(statstart(i):statend(i)-1) = mode(determinedmode(statstart(i):statend(i)-1)); %Could be prone to error if the analysis is completely wrong
    % transitions will be automatically be set to state 0
end

for i = 1:size(modes,2)
    forKPIMode{i} =  X(TrainedModes==i,:);                                                                                                                                                                                      %kmol/hr     m3/hr   %R/hr
    KPI{i} =(X(TrainedModes==i,9)*453.59237/1000/0.0283168.*X(TrainedModes==i,6)*0.0283168)*76.1*1.3*17 - (X(TrainedModes==i,1)*0.0283168.*X(TrainedModes==i,2)*453.59237/1000/0.0283168)*58*17*0.5 - X(TrainedModes==i,14)*453.59237/1000*18/1000*11.4*17; % KPI{i} =(X(TrainedModes==i,9)*453.59237/1000/0.0283168.*X(TrainedModes==i,6)*0.0283168)*76.1*1.3*17 - (X(TrainedModes==i,1)*0.0283168.*X(TrainedModes==i,2)*453.59237/1000/0.0283168)*58*17*1 - X(TrainedModes==i,14)*453.59237/1000*18/1000*11.4*17;    
    h{i} = histogram(KPI{i},10);
    count{i} = h{i}.Values;
    edges{i} = h{i}.BinEdges;
    for j = 1:size(edges{i},2)-1
        midpoint(j) = (edges{i}(j)+edges{i}(j+1))/2;
        frac(j) = count{i}(j)/sum(count{i});
        KPIforSec(j) = frac(j)* midpoint(j) ;
    end
    ModeT(i) = round((sum(X(TrainedModes==i,12),1)/size(X(TrainedModes==i,12),1)-32)*5/9);
    ModeL(i) = round(sum(X(TrainedModes==i,5),1)/size(X(TrainedModes==i,5),1),1);
    AvgModeKPI(i) = sum(KPIforSec);
    minModeKPI(i) = midpoint(1);
    maxModeKPI(i) = midpoint(end);
    ModeKPI{i} = [minModeKPI(i) AvgModeKPI(i) maxModeKPI(i)];
end

%% Detemine Connectivity Matrix or adjacency matrix

for j= 1:(size(statstart,1)-1)
    if mostprop(j)~=mostprop(j+1)
        EstimatedTransStart = find((NLLP(statend(j):statstart(j+1)-1)>Nthresh(mostprop(j))),1,'first');
        Transtime =find((NLLP(statend(j)+EstimatedTransStart+10:statstart(j+1)-1)<Nthresh(mostprop(j+1))),1,'first')/60; %[hr]
        if isempty(Transtime)==1
            Transtime = 0.01; %default
        end
        conMat(mostprop(j),mostprop(j+1)) = Transtime;
        %end
        if sum(sum(ischange(SP((statend(j)-leadTime):statstart(j+1),:)),2))~=0
            if sum(sum(ischange(SP((statend(j)-leadTime):statstart(j+1),1)),2))~=0
                transonset = ischange(SP((statend(j)-leadTime):statstart(j+1),1));
                transstartSP = find(transonset ~= 0);
                SetPoint = round((SP((statend(j)-leadTime)+transstartSP(end)+15,1)+121-32)*5/9);
                how{mostprop(j),mostprop(j+1)}= ['Temp SP to ',num2str(SetPoint), ' C'] ;
            end
            if sum(sum(ischange(SP((statend(j)-leadTime):statstart(j+1),2)),2))~=0
                transonset = ischange(SP((statend(j)-leadTime):statstart(j+1),2));
                transstartSP = find(transonset ~= 0);
                SetPoint = SP((statend(j)-leadTime)+transstartSP(end)+15,2)+1; % Add SSD value
                how{mostprop(j),mostprop(j+1)}= ['Level SP to ',num2str(SetPoint),' m'] ;
            end
        else
            how{mostprop(j),mostprop(j+1)}= 'Disturbance';
            conMat(mostprop(j),mostprop(j+1)) = -1;
            
        end
    end
end

%% Plot Network

if size(scoresTrain,2) == 2
    plotnetwork(statstart,statend,runlength,mostprop,color)
    scatter(scoresTrain(:,1),scoresTrain(:,2),[],determinedmode,'.')
    hold on
    G = digraph(conMat);
    h = plot(G,'XData',gmfit.mu(:,1),'YDATA',gmfit.mu(:,2),'EdgeColor','k','NodeColor','k');
    for i = 1:size(conMat,1)
        for j = 1:size(conMat,2)
            if conMat(i,j) == -1
                highlight(h,[i j],'LineStyle','--')
            end
            if conMat(i,j) ~=0
                labeledge(h,[i],[j],how{i,j})
            end
        end
    end
    
    for z = 1:size(modes,2)
        msg = {['Mode = ' num2str(z)],['KPI = ' num2str(round((ModeKPI{z}(2))))]};
        text(gmfit.mu(z,1),gmfit.mu(z,2),msg,'FontSize',9)
    end
    h.EdgeFontSize = 7;
    h.NodeLabel = {};
    hold off
else
    G = digraph(conMat);
    h = plot(G,'EdgeColor','k','NodeColor','k','Layout','force','MarkerSize',10);
    for i = 1:size(conMat,1)
        for j = 1:size(conMat,2)
            if conMat(i,j) == -1
                highlight(h,[i j],'LineStyle','--')
            end
            if conMat(i,j) ~=0
                labeledge(h,[i],[j],how{i,j})
            end
        end
    end
    for z = 1:size(modes,2)
        msg = {['(' num2str(z) ')'],['KPI = R ' num2str(round((ModeKPI{z}(2)))) '/hr'],['   T = ' num2str(ModeT(z)) ' ^{o}C'],[' L = ' num2str(ModeL(z)) ' m']};
        msg1 = [msg{1} msg{3} msg{4}];
        labelnode(h,z,msg1)%text(gmfit.mu(z,1),gmfit.mu(z,2),msg,'FontSize',9)
    end
    for r = 1:size(modes,2)
    Col(r) = ModeKPI{r}(2);
    end
    h.EdgeFontSize = 7;
    h.NodeCData = Col
    c = colorbar('southoutside');
    c.Label.String = 'KPI = R/hr';
end




