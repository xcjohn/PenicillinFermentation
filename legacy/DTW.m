%% Purpose: Testing of trajectory alignment
%Pre-requisites: generate batch data -> 'history', 'golden1' golden
%reference batch

clear all;
clf;
clc;

load ('data\goldenBatch.mat');
load ('data\historicalBatches.mat');

goldenP = golden1.P; %timeseries object
batch1 = history(1,1).P;
batch2 = history(1,2).P;
batch3 = history(1,3).P;


batch = history(1,1);

figure(1)
fprintf('plotting %.0f, equivelent to %.0f hr window\n', 2000, 2000*0.01);


golden = golden1.S.data;
sample = batch.S.data;

[distance, i_golden, i_batch] = dtw(golden,sample,  2000);

title('Substrate Conc [g/mol], (20hr max. warping window)');

golden_new = [];
sample_new = [];
for i=1:length(i_golden)
    index_g = i_golden(i);
    index_s = i_batch(i);
   golden_new(i) = golden(index_g);
   sample_new(i) = sample(index_s);
end



% figure(2)
% fprintf('plotting %.0f, equivelent to %.0f hr window\n', 2000, 2000*0.01);
% dtw(golden1.CL.data, batch.CL.data,  2000);
% title('Dissolved O2, 20hr max. warping window');
% 
% figure(3)
% fprintf('plotting %.0f, equivelent to %.0f hr window\n', 2000, 2000*0.01);
% dtw(golden1.CL_measured.data, batch.CL_measured.data,  2000);
% title('Dissolved O2 (noise), 20hr max. warping window');
% 
% figure(4)
% fprintf('plotting %.0f, equivelent to %.0f hr window\n', 2000, 2000*0.01);
% dtw(golden1.P.data, batch.P.data,  2000);
% title('Penicillin [g/mol], 20hr max. warping window');
% 
% figure(5)
% fprintf('plotting %.0f, equivelent to %.0f hr window\n', 2000, 2000*0.01);
% dtw(golden1.CO2.data, batch.CO2.data,  2000);
% title('Dissolved CO2, 20hr max. warping window');
% 
% figure(6)
% fprintf('plotting %.0f, equivelent to %.0f hr window\n', 2000, 2000*0.01);
% dtw(golden1.CO2_measured.data, batch.CO2_measured.data,  2000);
% title('Dissolved CO2 (noise), 20hr max. warping window');
% 
% figure(7)
% fprintf('plotting %.0f, equivelent to %.0f hr window\n', 2000, 2000*0.01);
% dtw(golden1.X.data, batch.X.data,  2000);
% title('Biomass Conc. , 20hr max. warping window');
% 
% figure(8)
% fprintf('plotting %.0f, equivelent to %.0f hr window\n', 2000, 2000*0.01);
% dtw(golden1.pH.data, batch.pH.data,  2000);
% title('pH. , 20hr max. warping window');