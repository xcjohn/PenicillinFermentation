function [capsSeg] = evalcapsule(idx)
for i = 1:max(idx)
    A = idx==i;
    A = A';
    transitions = diff([0; A' == 1; 0]); %find where the array goes from non-zero to zero and vice versa
    statstart = find(transitions == 1);
    statend = find(transitions == -1);
    runlength = statend-statstart;
    capsSeg(i) = sum(runlength)/size(runlength,1);
end
x=1;
