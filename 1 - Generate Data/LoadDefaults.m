%% init functions 
%clear all;

%% Initial Conditions
disp('loading default initial values...');
S_init  = 15;        %substration concentration         (g/L)
CLsat   = 1.16;      %dissolved oxygen concentration    (g/L)
X_init  = 0.1;       %biomass concentration             (g/L)
P_init  = 0;         %penicillin concentration          (g/L)
V_init  = 100;       %culture volume                    (L)
CO2_init= 0.5;       %carbon dioxide concentration      (mmol/L)
H_init  = 10^(-5.0); %hydrogen ion concentraiton        (mol/L)
pH_init = -log10(H_init);
T_init  = 298;       %temperature                       (K)
Qrxn_init = 0;       %heat generation                   (cal)
F_init  = 0;         %feed flow rate of substrate       (L/h)
CL_init = CLsat;

%% Kinetic parameters and variables
sf = 600;       %feed substrate concentration           (g/L)
T0 = 273;       %freezing temperature of medium         (K)
Tv = 373;       %boiling temperature of medium          (K)
F  = 0.042;     %feed rate of substrate (fed-batch)     (L/h)
fg = 8.6;       %aeration rate                          (L/h)   [Liu, 2018;China]
Pw = 30;        %agitator power                         (W)     [Liu, 2018;China]
Tc = 273+16.8;  %cooling water temperature              (K)     [ref; China]
Th = 273+50;    %heating water temperature              (K)     [ref; China]
Tf = 296;       %feed temperature of substrate          (K)     [ref; China]
Yxs = 0.45;     %Yield constant                         (g biomass/g glucose)
Yxo = 0.04;     %Yield constant                         (g biomass/g oxygen)
Yps = 0.90;     %Yield constant                         (g penicillin/g glucose)
Ypo = 0.20;     %Yield constant                         (g penicillin/g oxygen)
K1 = 1e-10;     %constant                               (mol/L)
K2 = 7e-5;      %constant                               (mol/L)
mx = 0.014;     %maintenance coefficient on substrate   (per hr)
mo = 0.467;     %maintenance coefficient on oxygen      (per hr)
alpha1 = 0.143; %constant relating CO2 to growth                (mmol CO2/g biomass)
alpha2 = 4e-7;  %constant relating CO2 to maintenance energy    (mmol CO2/g biomass.hr)
alpha3 = 1e-4;  %constant relating CO2 to penicillin production (mmol CO2/L.hr)
mu_x = 0.092;   %maximum specific growth rate                   (per hr)
Kx = 0.15;      %Contois saturation constant                    (g/L)
Kox_nolim = 0;          %oxygen limitation constant             [no limitation]
Kop_nolim = 0;          %oxygen limitation constant             [no limitation]
Kox_lim = 2*(10^(-2));  %oxygen limitation constant             [with limitation]
Kop_lim = 5*(10^(-4));  %oxygen limitation constant             [with limitation]
mu_p = 0.005;   %specific rate of penicillin production         (per h)
KI = 0.1;       %inhibition constant for production formation   (g/L)
Kp = 0.0002;    %inhibition constant                            (g/L)
p = 3;          %constant                                       (-)
K  = 0.04;          %penicillin hydrolysis rate                     (per hr)
kg = 7e3;           %Arrhenius constant for growth                  (-)
Eg = 5100;          %activation energy for growth                   (cal/mol)
kd = 1e33;          %Arrhenius constant for cell death              (-)
Ed = 50000;         %activation energyfor cell death                (cal/mol)
rhoCp     = 1500;   %density x heat capacity of medium              (per °C) [ref; China] ~Note: Cinar gives it as 1/1500 but thats incorrect. In the equation its V*(rho*Cp)...using water you get approx. 1000 cal/L/K which is what it should be not 1/1000
rho_cCp_c = 2000;   %density x heat capacity of cooling liquid      (per °C) [ref; China] ~Note: Cinar gives it as 1/1500 but thats incorrect. In the equation its V*(rho*Cp)...using water you get approx. 1000 cal/L/K which is what it should be not 1/1000
rq1 = 60;           %yield heat of generation                       (cal/g biomass)
rq2 = 1.6783e-4;    %constant in heat generation                    (cal/g biomass.hr)
a   = 1000;         %heat transfer coef. of cooling/heating liquid  (cal/hr °C)
b       = 0.6;      %constant                                       (-)
alpha0  = 70;       %constant in Kla                                (-)
beta0   = 0.4;      %constant in Kla                                (-)
lambda0 = 1.0039e-4;%constant in Floss                              (per h) [ref; China] ~Note: Its reported incorrectly in Cinar
gamma0  = 1e-5;     %proportionality constant                       (mol [H+]/g biomass)
Ca      = 3;        %concentration of acid solution                 (M)
Cb      = Ca;       %concentration of base solution                 (M)
Cab     = Ca;       %generalized concentration                      (M)
R       = 1.987;    %gas constant                                   (cal/mol.K)

%% Controller Parameters
% Base / Acid
Kc_base     = 8e-4;     Kc_acid     = 1e-4;     
tauI_base   = 4.2;      tauI_acid   = 8.4;      %(hr)
tauD_base   = 0.2625;   tauD_acid   = 0.125;    %(hr)

% Saturation Limits
Fa_max = 0.01/1000; Fb_max = 100/1000;          %(L/h) ~NOTE: conversion of mL to L

% Setpoints & Gaps
setpoint_pH     = 5;
setpoint_H      = 10^(-1*setpoint_pH);
setpointGap_pH  = 0.01;                         %prevent excessive acid addition

%% Controller Parameters
% Temperature (Cooling / heating)
Kc_cooling      = 7;    Kc_heating    = 5;       %Kc,c reported incorrectly in Cinar
tauI_cooling    = 0.5;  tauI_heating  = 0.8;
tauD_cooling    = 1.6;  tauD_heating  = 0.05;

% Setpoints & Gaps
setpoint_temp    = 298;  %(K)
setpointGap_Temp = 2;    %(K) ~ avoid excessive control action

%% Threshold Values [based on substrate conc. or time]
S_threshold = 0.3;      %glucose concentration trigger to start fed-batch (g/L) - Cinar,2002
t_fedbatch  = 45;       %time until switch from batch -> fed batch        (hr) - Liu, 2018
P_threshold = 1.3;      %target yield of Penicillin for end of batch      (g/L) - Jedd

%% switching flags
oxygen_limited = 1;  %0 for no limitation, 1 for with oxygen limitation
q              = 0;  %0 for cooling, 1 for heating

%% Simulation Parameters
startTime = 0;      %hours
stopTime  = 420;    %hours
timeDelta = 0.01;   %hr

%% Pre-calculation Steps
disp('pre-calculting random arrays...');
% pH control off
Fa_init = 0;
Fb_init = 0;
Fc_init = 0;
Fh_init = 0;

%toggle between oxygen limited and non-oxygen limited scenarios
if oxygen_limited == 0
    Kox = Kox_nolim;
    Kop = Kop_nolim;
else
    Kox = Kox_lim;
    Kop = Kop_lim;
end

%toggle between cooling water flow and heating water flow scenarios
if q == 0
    Fch = Fc_init;
else
    Fch = Fh_init;
end