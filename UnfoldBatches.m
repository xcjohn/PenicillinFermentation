function [unfolded] = UnfoldBatches(history)

batch = history(1);
props = fieldnames(batch);

baseTable = table;

for i=1:length(history)
    unfoldedBatch = UnfoldBatch(history(i) );
    unfoldedTable = array2table(unfoldedBatch);
    
    if i == 1 
        baseTable = unfoldedTable;
    else
        baseTable = [baseTable; unfoldedTable]; %append
    end
    
end

baseTable.Properties.VariableNames = props;
unfolded = baseTable;

end

