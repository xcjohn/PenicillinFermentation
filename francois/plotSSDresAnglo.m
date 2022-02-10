function plotSSDres(stat,ProbStat,thresh,sampleTime,memo)
transitions = diff([0; stat' == 1; 0]); %find where the array goes from non-zero to zero and vice versa
statstart = find(transitions == 1)*0.1;
statend = find(transitions == -1)*0.1;
runlength = (statend-statstart);

%figure
hold on



plot(sampleTime,ProbStat,'LineWidth',0.9)
%plot(sampleTime,ProbStat,'.')


for i =1:size(statstart,1)-1
    if i == 1
        rectangle('Position', [0.1 0 statstart(i) 1],'FaceColor',[1 1 0 0.5],'EdgeColor','none')
        rectangle('Position', [statend(i) 0 (statstart(i+1)-statend(i)) 1],'FaceColor',[1 1 0 0.5],'EdgeColor','none')
        translength(i) = statstart(i);
    else
        rectangle('Position', [statend(i) 0 (statstart(i+1)-statend(i)) 1],'FaceColor',[1 1 0 0.5],'EdgeColor','none')
        translength(i) = (statstart(i+1)-statend(i));
    end
end
transitions = diff([0; memo == 1; 0]); %find where the array goes from non-zero to zero and vice versa
statstart = find(transitions == 1)*0.1;
statend = find(transitions == -1)*0.1;
runlength = (statend-statstart);

%% Plot Memo
 for i =1:size(statstart,1)-1
     if i == 1
         rectangle('Position', [0.1 0 statstart(i) 1],'FaceColor',[1 0 0 0.5],'EdgeColor','none')
         rectangle('Position', [statend(i) 0 (statstart(i+1)-statend(i)) 1],'FaceColor',[1 0 0 0.5],'EdgeColor','none')
         translength(i) = statstart(i);
     else
         rectangle('Position', [statend(i) 0 (statstart(i+1)-statend(i)) 1],'FaceColor',[1 0 0 0.5],'EdgeColor','none')
         translength(i) = (statstart(i+1)-statend(i));
     end
 end





plot(sampleTime,ones(size(sampleTime))*(1-thresh),'-.','LineWidth',1,'Color','k')
ylim([0 1])
xlabel('Time [h]')
ylabel('Stationarity') 
hold off
end