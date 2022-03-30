global source;

%always load
%S_threshold_range = [0.25 0.35]; % - Jedd
S_threshold_optimal = [0.3 0.3]; % - Jedd
S_threshold_range = S_threshold_optimal; % - Jedd, temporary to generate more accurate data

if source == 1      % [Liu, 2018]
    fg_range    = [3    10];          %(L/h)  - aeration rate 
    Pw_range    = [20   50];          %(W)    - agitation rate
    F_range     = [0.035 0.045];      %(L/h)  - substrate feed 
    Tf_range    = [296  298];         %(K)    - substrate temp
    S_range     = [5    50]; %excessive
    X_range     = [0    0.2]; %from Jedd
    V_range     = [100  150];         %(L)    - culture volume
    pH_range    = [4    6];           %(-)    - culture pH
    S_optimal   = [15    17]; %from Jiang
    V_optimal   = [100  115];
    F_optimal   = [0.042 0.045];
    Pw_optimal  = [29   31];
    fg_optimal  = [8.5  10];
    pH_optimal  = [4.9  5.1];
    CL_optimal    = [1    1.2]; %from Jiang
    
elseif source == 2  % [Jiang, 2019]
    fg_range    = [8    9];           %(L/h)  - aeration rate 
    Pw_range    = [29   31];          %(W)    - agitation rate
    F_range     = [0.039 0.045];      %(L/h)  - substrate feed   
    Tf_range    = [295  298];         %(K)    - substrate temp
    S_range     = [15    17];
    CL_range    = [1    1.2];
    CO2_range   = [0.5  1];
    T_range     = [297  299];
    V_range     = [101  103];         %(L)    - culture volume
    pH_range    = [4.95    5.05];     %(-)    - culture pH
    S_optimal   = [15    17]; 
    V_optimal     = [101  103];  
    CL_optimal    = [1    1.2];
    pH_optimal    = [4.95    5.05];

elseif source == 3 % [Jedd, combination of optimal values from different sources to generate the Golden Batch(s)]
    Pw_optimal  = [29   31];        % [Liu, 2018]
    fg_optimal  = [8.5  10];        % [Liu, 2018]
    F_optimal   = [0.042 0.045];    % [Liu, 2018]
    S_optimal     = [15    17];     % [Jiang, 2019]
    V_optimal     = [101  103];     % [Jiang, 2019]      
    CL_optimal    = [1    1.2];     % [Jiang, 2019]
    pH_optimal    = [4.95    5.05]; % [Jiang, 2019]
    Tf_optimal    = [296 298]; %Jedd
    X_optimal     = [0.1 0.1]; %Jedd
    
    fg_range    = fg_optimal;      
    Pw_range    = Pw_optimal;         
    F_range     = F_optimal;      
    Tf_range    = Tf_optimal;        
    S_range     = S_optimal; 
    X_range     = X_optimal;
    V_range     = V_optimal;        
    pH_range    = pH_optimal;          
    
else
    disp('invalid source specified for loading variable ranges.');
end 











