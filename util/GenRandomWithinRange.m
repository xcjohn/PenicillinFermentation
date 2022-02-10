function value = GenRandomWithinRange(range)
%GENRANDOMWITHINRANGE Given a range, generate random (uniform distribution)
% Formula for interval (a,b): r = a + (b-a)*rand(N,1)
value   = range(1,1)  +   (range(1,2)   - range(1,1))*rand(1,1);
end