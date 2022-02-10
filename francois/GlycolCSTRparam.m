clear all
clc

Fao = 80;
To = 75;
V = (1/7.484)*500; %ft3
UA = 16000; %16000
dh = -36000;
mc = 1000;
Fmo = 100;
Fbo = 1000;
Vo = Fao/0.923+Fbo/3.45+Fmo/1.54; %This equation needs to be in simu
ko = 16.96e12;
EA=32400;
R=1.987;
pa = 0.923; % Molar Density Ib-mol/ft3
pb = 3.45;
pm = 1.54;
pc = 1.04/76.095/453.59/(3.53*10^-5);
Cpa=35;  %Btu/lb-mol.F
Cpb = 18;
Cpm=19.5;
Cpc=46;
Cpw = 18;
Tc=60; %Farhenheit
Fcs=1000;
height = 2.5; %was 1 [m]
r = 0.7768;
As = pi*r^2; %m2
Tamb = 25*9/5+32;
h = 5.944*3.41; %Btu/m^2 K (W*3.41-->Btu/h)
Cpav = Cpa*0.56;
Cpbv = Cpb*0.476;
Cpcv=0.648*Cpc;
Cpmv = 0.543*Cpm;
den = 2.6729;
Kla= 0; % Kla = 1;
g = 9.81;
Ve = 100;
h = 5;
Patm = 14.5; %PSI
Cv = 10;
KT = -10;  % Nb its -10 originally
KTank1 = -20;%CSTR Level
tauT = 2; % Its 2 originally  % 0.5 for new 
tauTank = 0.2; %CSTR [5]  % CSTR 
Vtankmax = V*600*0.028; %[m3]
Atank = 6^2*pi(); %m2
htankmax = Vtankmax/Atank; %m
Ktank = -1000; 
Hvap = 18279; %btu/pbmol

