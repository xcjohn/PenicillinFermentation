function [F1, Recall, Precision,confusM,FAR,TAR] = evalRes(detmode,actualmode)
dimensions = max(actualmode)+1;%max(detmode)+1;
for z = 1:size(detmode,2)
    if detmode(z) == 0
        detmode(z) = dimensions;
    end
    if actualmode(z) == 0
        actualmode(z) = dimensions;
    end
end

TP = zeros(1,dimensions);
FP = zeros(dimensions,dimensions);
confusM = zeros(dimensions,dimensions);
% for i = 1:dimensions % Cycle through mode
%     for j = 1:size(detmode,2) % Cycle through sample
%         if (detmode(j)== i && actualmode(j)==i)==1%(detmode(j) == actualmode(j)) == 1
%             TP(i) = TP(i)+1;
%             confusM(i,i) = TP(i);
%         else
%             FP(i,actualmode(j)) = FP(i,actualmode(j))+1;
%             confusM(i,actualmode(j)) = FP(i,actualmode(j));
%         end
%     end
% end
for i = 1:dimensions % Cycle through mode
    for j = 1:size(detmode,2)
        if (actualmode(j)==i)==1
           if (detmode(j) == actualmode(j)) == 1
               TP(i) = TP(i)+1;
            confusM(i,i) = TP(i);
           else
              FP(i,detmode(j)) = FP(i,detmode(j))+1;
            confusM(i,detmode(j)) = FP(i,detmode(j));
           end
        end
    end
end
% Confusion matrix has the number of modes actual!! And transition needs to
% be max of actual+1!!!
Accuracy = sum(diag(confusM))/sum(sum(confusM));
for i = 1:dimensions
Precision(i) =  confusM(i,i)/sum(confusM(:,i));
Recall(i) = confusM(i,i)/sum(confusM(i,:));
F1(i) = 2*Precision(i)*Recall(i)/(Precision(i)+Recall(i));
Specificity(i) = (sum(sum(confusM))-sum(confusM(i,:))-sum(confusM(:,i)))/((sum(sum(confusM))-sum(confusM(i,:))-sum(confusM(:,i)))+sum(confusM(:,i))-confusM(i,i));
end
flag = 0;

if (max(actualmode)) ==2
    if max(detmode)==1 
        FAR = 0;
        MAR = 1;
        flag =1;
    end
    if min(detmode)==2
        FAR = 1;
        MAR = 0;
        flag = 1;
    end

   if flag==0 
    FAR = confusM(1,2)/sum(confusM(1,:));
    MAR =  confusM(2,1)/sum(confusM(2,:));
   end

TAR = 1-MAR;
end
end

