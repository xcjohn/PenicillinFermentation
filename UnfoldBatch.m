function [unfoldedBatch] = UnfoldBatch(batch)
%Given a single batch, perform variable-wise 3D-2D decomposition
%('ufolding');

props = fieldnames(batch);

matrix = zeros( length(batch.S.data), 1 );

for j= 1:length(props)
    currProp = props{j};
    currData = batch.(currProp).data;
    
    matrix(1:end, j)= currData;
end

unfoldedBatch = matrix;

% props = fieldnames(batch);
% tbl = struct2table(batch);
% 
% matrix = zeros( length(batch.S.data), length(props) );
% 
% for j= 1:length(props)
%     currProp = props{j};
%     currData = batch.(currProp).data;
%     
%     matrix(1:end,j) = currData;
% end
% 
% unfoldedBatch = matrix;





end

