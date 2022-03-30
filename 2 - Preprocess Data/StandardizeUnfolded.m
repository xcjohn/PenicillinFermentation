function [N, centers, scales] = StandardizeUnfolded(unfolded)

% N = normalize(A) returns the vectorwise z-score of the data in A with center 0 and standard deviation 1.
% If A is a vector, then normalize operates on the entire vector.
% A is a matrix, table, or timetable, then normalize operates on each column of data separately.

% normalize returns C and S as arrays such that N = (A - C) ./ S.

[N, C ,S] = normalize(unfolded);
unfolded_norm = N;
centers = C;
scales = S;

end

