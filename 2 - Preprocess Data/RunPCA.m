function [unfoldedSTD, means, stds, inputTable, outputTable] = RunPCA(unfolded)
%     addpath("C:\Program Files\MATLAB\R2019b\toolbox\matlab\datafun\");

    [unfolded_std, means, stds] = StandardizeUnfolded(unfolded);
    %C = centering parameters (each column)
    %S = scaling parameter (i.e. std dev)
    
    %define inputs to be used in the model
    
    inputVars = ["CL", "CO2", "S", "T", "V", "pH", "X", "F", "Pw"];
    %inputVars = ["CL", "CO2","T", "V", "pH", "X"];
    
    %define outputs to be used in the model
    
    outputVars = ["P"];
    
    unfoldedSTD = unfolded_std;

    inputTable = table(unfoldedSTD.(inputVars(1)));
    outputTable = table(unfoldedSTD.(outputVars(1)));
    
    for i=2:length(inputVars)
        inputTable(1:end,i) = table(unfoldedSTD.(inputVars(i)));
    end

%     for i=2:length(outputVars)
%         outputTable(1:end,i) = unfoldedSTD.(outputVars(i));
%     end

    inputTable.Properties.VariableNames = inputVars;
    outputTable.Properties.VariableNames = outputVars;

      

end

