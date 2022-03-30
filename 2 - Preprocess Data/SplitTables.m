function [inputTable, outputTable] = SplitTables(unfolded_std, inputVars, outputVars)

    inputTable = table(unfolded_std.(inputVars(1)));
    outputTable = table(unfolded_std.(outputVars(1)));
    
    for i=2:length(inputVars)
        inputTable(1:end,i) = table(unfolded_std.(inputVars(i)));
    end

    inputTable.Properties.VariableNames = inputVars;
    outputTable.Properties.VariableNames = outputVars;

end

