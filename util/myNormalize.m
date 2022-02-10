function N = mymyNormalize(A,varargin)
%myNormalize   myNormalize data.
%   N = myNormalize(A) myNormalizes data in A using the 'zscore' method, which 
%   centers the data to have mean 0 and scales it to have standard 
%   deviation 1. NaN values are ignored. If A is a matrix or a table, 
%   myNormalize operates on each column separately. If A is an N-D array,  
%   myNormalize operates along the first array dimension whose size does not 
%   equal 1.
%
%   myNormalize(A,DIM) specifies the dimension to operate along.
%
%   myNormalize(...,METHOD) myNormalizes using the normalization method METHOD.
%   NaN values are ignored. METHOD can be one of the following:
%
%     'zscore' - (default) myNormalizes by centering the data to have mean 0 
%                and scaling it to have standard deviation 1.
%
%     'norm'   - myNormalizes by scaling the data to unit length using the 
%                vector 2-norm.
%
%     'center' - myNormalizes by centering the data to have mean 0.
%
%     'scale'  - myNormalizes by scaling the data by the standard deviation.
%
%     'range'  - myNormalizes by rescaling the range of the data to the 
%                interval [0,1].
%
%   myNormalize(A,'zscore',TYPE) and myNormalize(A,DIM,'zscore',TYPE) 
%   myNormalizes using the 'zscore' method specified by TYPE. TYPE can be one 
%   of the following:
%
%     'std'    - (default) centers the data to have mean 0 and standard 
%                deviation 1.
%     'robust' - centers the data to have median 0 and median absolute 
%                deviation 1.
%
%   myNormalize(A,'norm',p) and myNormalize(A,DIM,'norm',p) myNormalizes the data 
%   using the vector p-norm. p can be any positive real value or Inf. p is 
%   2 by default.
%
%   myNormalize(A,'center',TYPE) and myNormalize(A,DIM,'center',TYPE) 
%   myNormalizes using the 'center' method specified by TYPE. TYPE can be one 
%   of the following:
%
%     'mean'   - (default) centers the data to have mean 0.
%     'median' - centers the data to have median 0.
%        k     - centers the data by the numeric scalar value k.
%
%   myNormalize(A,'scale',TYPE) and myNormalize(A,DIM,'scale',TYPE) myNormalizes 
%   using the 'scale' method specified by TYPE. TYPE can be one of the 
%   following:
%
%      'std'   - (default) scales the data by the standard deviation.
%      'mad'   - scales the data by the median absolute deviation.
%      'first' - scales the data by the first element.
%        k     - scales the data by the numeric scalar value k.
%
%   myNormalize(A,'range',[a,b]) and myNormalize(A,DIM,'range',[a,b]) 
%   myNormalizes the output range to [a,b]. The default range is [0,1].
%
%   myNormalize(...,'DataVariables',DV) myNormalizes the data only in the table
%   variables specified by DV. The default is all table variables in A. 
%   DV must be a table variable name, a cell array of table variable names,
%   a vector of table variable indices, a logical vector, or a function 
%   handle that returns a logical scalar (such as @isnumeric).
%   The output table N has the same size as the input table A.
%
%   EXAMPLE: Compute the z-scores of two data vectors in order to compare 
%   the data on one plot
%       A(:,1) = 3*rand(5,1);
%       A(:,2) = 2000*rand(5,1);
%       N = myNormalize(A);
%       plot(N);
%
%   EXAMPLE: Scale each column of a matrix to unit length using the vector
%   2-norm
%       A = rand(10);
%       N = myNormalize(A,'norm');
%
%   See also RESCALE, SMOOTHDATA, FILLOUTLIERS, FILLMISSING, VECNORM.
 
%   Copyright 2017 The MathWorks, Inc.

[dim,method,methodType,dataVars,AisTablular] = parseInputs(A,varargin{:});

if ~AisTablular
    checkSupportedArray(A,method,methodType,false);
    N = myNormalizeArray(A,method,methodType,dim);
else
    N = A;
    for vj = dataVars
        Avj = A.(vj);
        checkSupportedArray(Avj,method,methodType,true);
        if ~(iscolumn(Avj) || isempty(Avj))
            error(message('MATLAB:myNormalize:NonVectorTableVariable'));
        end
        N.(vj) = myNormalizeArray(A.(vj),method,methodType,dim);
    end
end
end

%--------------------------------------------------------------------------
function N = myNormalizeArray(A,method,methodType,dim)
% Normalization for arrays - always omit NaNs

if isequal("zscore", method)
    if isequal("std",methodType)
        N = (A - mean(A,dim,'omitnan')) ./ std(A,0,dim,'omitnan');
    else % "robust"
        N = (A - median(A,dim,'omitnan')) ./ median(abs(A - median(A,dim,'omitnan')),dim,'omitnan');
    end
elseif isequal("norm", method)
    % In order to omit NaNs in this case fill NaNs with 0 to compute norms
    fillA = A;
    fillA(isnan(fillA)) = 0;
    N = A./vecnorm(fillA,methodType,dim);
elseif isequal("center", method)
    if isequal("mean",methodType)
        N = A - mean(A,dim,'omitnan');
    elseif isequal("median",methodType)
        N = A - median(A,dim,'omitnan');
    else % numeric
        N = A - methodType;
    end
elseif isequal("scale", method)
    if isequal("std",methodType)
        N = A ./ std(A,0,dim,'omitnan');
    elseif isequal("mad",methodType)
        N = A ./ median(abs(A - median(A,dim,'omitnan')),dim,'omitnan');
    elseif isequal("first",methodType)
        if isempty(A)
            N = A;
        else
            ind = repmat({':'},ndims(A),1);
            ind{dim} = 1;
            N = A ./ A(ind{:});
        end
    else % numeric
        N = A ./ methodType;
    end
elseif isequal("range", method)
    minA = min(A,[],dim);
    maxA = max(A,[],dim);
    if ~isfloat(A)
        minA = double(minA);
        maxA = double(maxA);
    end
    N = rescale(A,methodType(1),methodType(2),'InputMin',minA,'InputMax',maxA);
end
end

%--------------------------------------------------------------------------
function checkSupportedArray(A,method,methodType,AisTabular)
% Parse input A
if isequal("range",method)
    if (~(isnumeric(A) || islogical(A)) || ~isreal(A))
        if AisTabular
            error(message('MATLAB:myNormalize:UnsupportedTableVariableRange'));
        else
            error(message('MATLAB:myNormalize:InvalidFirstInputRange'));
        end
    end
elseif isequal("zscore",method) && isequal("robust",methodType)
    if ~isfloat(A) || ~isreal(A)
        if AisTabular
            error(message('MATLAB:myNormalize:UnsupportedTableVariableRobust'));
        else
            error(message('MATLAB:myNormalize:InvalidFirstInputRobust'));
        end
    end
else
    if ~isfloat(A)
        if AisTabular
            error(message('MATLAB:myNormalize:UnsupportedTableVariable'));
        else
            error(message('MATLAB:myNormalize:InvalidFirstInput'));
        end
    end
end
end
%--------------------------------------------------------------------------
function [dim,method,methodType,dataVars,AisTabular] = parseInputs(A,varargin)
% Parse myNormalize inputs
AisTabular = matlab.internal.datatypes.istabular(A);

% Set defaults
method = "zscore";
methodType = "std";
if ~AisTabular
    dim = find(size(A) ~= 1,1); % default to first non-singleton dimension
    if isempty(dim)
        dim = 2; % dim = 2 for scalar and empty A
    end
    dataVars = []; % not supported for arrays
else
    dim = 1; % Fill each table variable separately
    dataVars = 1:width(A);
end

% myNormalize(A,DIM)
% myNormalize(A,DIM,METHOD)
% myNormalize(A,DIM,METHOD,TYPE)
% myNormalize(A,METHOD)
% myNormalize(A,METHOD,TYPE)
% myNormalize(A,'DataVariables',DV)
% myNormalize(A,METHOD,'DataVariables',DV)
% myNormalize(A,METHOD,TYPE,'DataVariables,DV)
if nargin > 1
    indStart = 1;
    % Parse dimension - errors for invalid dim
    dimProvided = false;
    methodProvided = false;
    if isnumeric(varargin{indStart}) || islogical(varargin{indStart})
        if AisTabular
            error(message('MATLAB:myNormalize:TableDIM'));
        end
        dim = varargin{indStart};
        if ~isscalar(dim) || ~isreal(dim) || dim < 1 || ~(fix(dim) == dim) || ~ isfinite(dim)
            error(message('MATLAB:myNormalize:InvalidDIM'));
        end
        indStart = indStart + 1;
        dimProvided = true;
    end
    if indStart < nargin
        % Parse method - does not error for invalid method
        validMethods = ["zscore","norm","center","scale","range"];
        if checkCharString(varargin{indStart})
            indMethod = startsWith(validMethods, varargin{indStart}, 'IgnoreCase', true);
            if nnz(indMethod) == 1
                method = validMethods(indMethod);
                defaultTypes = {"std",2,"mean","std",[0,1]};
                methodType = defaultTypes{indMethod};
                indStart = indStart + 1;
                methodProvided = true;
                % Parse type - does not error for invalid character/string type
                if indStart < nargin
                    [methodType,indStart] = parseType(varargin{indStart},method,methodType,indStart,AisTabular);
                end
            end
        end
        
        % Parse name-value pairs
        if rem(nargin-indStart,2) == 0
            for j = indStart:2:length(varargin)
                name = varargin{j};
                if ~AisTabular
                    error(message('MATLAB:myNormalize:DataVariablesArray'));
                elseif ~checkCharString(name)
                    error(message('MATLAB:myNormalize:ParseFlags'));
                elseif startsWith("DataVariables", name, 'IgnoreCase', true)
                    dataVars = matlab.internal.math.checkDataVariables(A, varargin{j+1}, 'myNormalize');
                elseif ~methodProvided && any(startsWith(validMethods, name, 'IgnoreCase', true))
                    error(message('MATLAB:myNormalize:MethodAfterOptions'));
                else
                    error(message('MATLAB:myNormalize:ParseFlags'));
                end
            end
        elseif (nargin < 3) || (dimProvided && nargin < 4)
            error(message('MATLAB:myNormalize:InvalidMethod'));
        else
            if ~AisTabular
                error(message('MATLAB:myNormalize:IncorrectNumInputsArray'));
            else
                error(message('MATLAB:myNormalize:KeyWithoutValue'));
            end
        end
    end
end
end
%--------------------------------------------------------------------------
function [methodType,indStart] = parseType(input,method,methodType,indStart,AisTabular)
% Parse Method Type 
if method == "zscore"
    if isnumeric(input) || islogical(input)
        error(message('MATLAB:myNormalize:InvalidZscoreType'));
    elseif checkCharString(input)
        validZscoreType = ["std","robust"];
        indZscoreType = startsWith(validZscoreType, input, 'IgnoreCase', true);
        if nnz(indZscoreType) == 1
            methodType = validZscoreType(indZscoreType);
            indStart = indStart + 1;
        elseif ~AisTabular && ~startsWith("DataVariables", input, 'IgnoreCase', true)
            error(message('MATLAB:myNormalize:InvalidZscoreType'));
        end
    end
elseif method == "norm"
    if isnumeric(input) || islogical(input)
        if ~isscalar(input) || (input <= 0 || ~isreal(input)) || islogical(input)
            error(message('MATLAB:myNormalize:InvalidNormType'));
        end
        methodType = input;
        indStart = indStart + 1;
    elseif checkCharString(input)
        if strcmpi("inf",input)
            methodType = "inf";
            indStart = indStart + 1;
        elseif ~AisTabular && ~startsWith("DataVariables", input, 'IgnoreCase', true)
            error(message('MATLAB:myNormalize:InvalidNormType'));    
        end
    end
elseif method == "center"
    if isnumeric(input) || islogical(input)
        if ~isscalar(input) || islogical(input)
            error(message('MATLAB:myNormalize:InvalidCenterType'));
        end
        methodType = input;
        indStart = indStart + 1;
        if ~isfloat(methodType)
            methodType = double(methodType);
        end
    elseif checkCharString(input)
        validCenterType = ["mean","median"];
        indCenterType = startsWith(validCenterType, input, 'IgnoreCase', true);
        if nnz(indCenterType) == 1
            methodType = validCenterType(indCenterType);
            indStart = indStart + 1;
        elseif ~AisTabular && ~startsWith("DataVariables", input, 'IgnoreCase', true)
            error(message('MATLAB:myNormalize:InvalidCenterType'));
        end
    end
elseif method == "scale"
    if isnumeric(input) || islogical(input)
        if ~isscalar(input) || islogical(input)
            error(message('MATLAB:myNormalize:InvalidScaleType'));
        end
        methodType = input;
        indStart = indStart + 1;
        if ~isfloat(methodType)
            methodType = double(methodType);
        end 
    elseif checkCharString(input)
        validScaleType = ["std","mad","first"];
        indScaleType = startsWith(validScaleType, input, 'IgnoreCase', true);
        if nnz(indScaleType) == 1
            methodType = validScaleType(indScaleType);
            indStart = indStart + 1;
        elseif ~AisTabular && ~startsWith("DataVariables", input, 'IgnoreCase', true)
            error(message('MATLAB:myNormalize:InvalidScaleType'));
        end
    end
elseif method == "range"
    if isnumeric(input) || islogical(input)
        if ~isvector(input) || length(input) ~= 2 || ~isreal(input) || islogical(input)
            error(message('MATLAB:myNormalize:InvalidRangeType'));
        end
        methodType = input;
        indStart = indStart + 1;
    elseif ~AisTabular && ~startsWith("DataVariables", input, 'IgnoreCase', true)
        error(message('MATLAB:myNormalize:InvalidRangeType'));
    end
end
end

%--------------------------------------------------------------------------
function flag = checkCharString(inputName)
flag = (ischar(inputName) && isrow(inputName)) || (isstring(inputName) && isscalar(inputName) ...
    && strlength(inputName) ~= 0);
end

