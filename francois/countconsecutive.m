function [adjIDX,consec] = countconsecutive(idx,thresh,gmfit,X)
%% Determine Mode Stationarity
 %[Mstat] = modeStattionarity(X,gmfit,idx)
%% Conectivity
consec = zeros(max(idx),max(idx));
adjIDX = idx;


for i =1:size(idx,1)-1
    if idx(i) ~= idx(i+1)
        consec(idx(i),idx(i+1)) = consec(idx(i),idx(i+1))+1;
    end
end
%% Euclidean Distance
Dis = squareform(pdist((gmfit.mu)));
consec1 = consec;
consec1(consec1~=0) = 1;
Z = digraph(Dis.*consec1);

%% NB
G = digraph(consec);
% h = plot(G,'EdgeLabel',G.Edges.Weight,'layout','layered','MarkerSize',7)
h = plot(Z,'EdgeLabel',G.Edges.Weight,'layout','force','WeightEffect','direct','MarkerSize',7)
h.NodeColor = 'k';
h.NodeFontSize = 10;
% Maybe do this iteratively

% for r = 1:max(idx)
%     Col(r) = Mstat(r);
% end

h.NodeCData = gmfit.ComponentProportion;%Col;%gmfit.ComponentProportion;
c = colorbar('southoutside');
c.Label.String = 'Gaussian Weight';




for z =1:size(consec,1)
    for j = 1:size(consec,1)
        if consec(z,j) >= thresh
            highlight(h,[z j],'EdgeColor','r')
            adjIDX(adjIDX==z)=min([j z]);
            %        adjIDX(adjIDX>min([j z])) = adjIDX(adjIDX>min([j z]))-1;
        end
    end
end
new = unique(adjIDX);
for l = 1:size(new,1)
    adjIDX(adjIDX==new(l)) =l;
end
end
