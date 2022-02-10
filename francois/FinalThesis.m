clc
clear all
%% CSTR Parameters
GlycolCSTRparam; % It should be noted that the simulation incorparates mass transfer effects to the atmosphere, but setting Kla to 0 removes these effects
duration =8000;
seed =60;
minSS =200;

%% Random Testing and Training Data Configurations 
[RandomSetTrain,RandomSetTest,NumModes,Memo,MemoT] = modegeneration(duration,seed,minSS); %Randomly generate data based on high low
Summary = table(RandomSetTrain(:,end)*0.1,RandomSetTrain(:,1)+0.98,RandomSetTrain(:,2)+121,RandomSetTrain(:,3)+To,RandomSetTrain(:,4)+Tc,RandomSetTrain(:,5)+Fmo,RandomSetTrain(:,6)+Fbo);
Summary.Properties.VariableNames = {'TransitionTime' 'LevelSP' 'TempSP' 'InletTempDV' 'CoolingWaterTempDV' 'SolventMolarFlowarate' 'WaterFlowrateReactantDV'};
RandomMatrix = RandomSetTrain;


%% Generate Training Data
out = sim('PropGlycAdjustedARNoNoiseNew1.slx',duration); 
XNoNoiseTrain = [out.yout{1}.Values.Data,out.yout{2}.Values.Data, out.yout{3}.Values.Data, out.yout{4}.Values.Data, out.yout{5}.Values.Data, out.yout{6}.Values.Data, out.yout{7}.Values.Data, out.yout{8}.Values.Data, out.yout{9}.Values.Data, out.yout{10}.Values.Data, out.yout{11}.Values.Data,out.yout{12}.Values.Data, out.yout{13}.Values.Data, out.yout{14}.Values.Data, out.yout{15}.Values.Data, out.yout{16}.Values.Data, out.yout{17}.Values.Data, out.yout{18}.Values.Data, out.yout{19}.Values.Data, out.yout{20}.Values.Data];
SPTrain = [out.yout{21}.Values.Data,out.yout{22}.Values.Data];
DVsetTrain = [out.yout{25}.Values.Data,out.yout{26}.Values.Data,out.yout{27}.Values.Data,out.yout{28}.Values.Data];
DVactTrain = [out.yout{11}.Values.Data,out.yout{13}.Values.Data,out.yout{29}.Values.Data,out.yout{24}.Values.Data]; % To, Tc, Fb,Fm
labels = {'Vo','Cao','Cbo','Cmo','Level','Vout','Ca','Cb','Cc','Cm','To','T','Tc','mc'};
[stationaryTrain] = groundtruth(XNoNoiseTrain,SPTrain,DVsetTrain,DVactTrain); % Determine groundtruth stationarity
MemoTrain = stationaryTrain.*Memo'; % Incorparate mode indices in groundtruth
sampleTime = out.tout;
clear out
out = sim('PropGlycAdjustedARNew1.slx',duration); % Run Simulation with Noise
XTrain = [out.yout{1}.Values.Data,out.yout{2}.Values.Data, out.yout{3}.Values.Data, out.yout{4}.Values.Data, out.yout{5}.Values.Data, out.yout{6}.Values.Data, out.yout{7}.Values.Data, out.yout{8}.Values.Data, out.yout{9}.Values.Data, out.yout{10}.Values.Data, out.yout{11}.Values.Data,out.yout{12}.Values.Data, out.yout{13}.Values.Data, out.yout{14}.Values.Data, out.yout{15}.Values.Data, out.yout{16}.Values.Data, out.yout{17}.Values.Data, out.yout{18}.Values.Data, out.yout{19}.Values.Data, out.yout{20}.Values.Data];
XTrain = XTrain(:,1:14);

%% Generate Testing Data (Repeat above but for testing data)
RandomMatrix = RandomSetTest;
clear out
out = sim('PropGlycAdjustedARNoNoiseNew1.slx',duration); 
XNoNoiseTest = [out.yout{1}.Values.Data,out.yout{2}.Values.Data, out.yout{3}.Values.Data, out.yout{4}.Values.Data, out.yout{5}.Values.Data, out.yout{6}.Values.Data, out.yout{7}.Values.Data, out.yout{8}.Values.Data, out.yout{9}.Values.Data, out.yout{10}.Values.Data, out.yout{11}.Values.Data,out.yout{12}.Values.Data, out.yout{13}.Values.Data, out.yout{14}.Values.Data, out.yout{15}.Values.Data, out.yout{16}.Values.Data, out.yout{17}.Values.Data, out.yout{18}.Values.Data, out.yout{19}.Values.Data, out.yout{20}.Values.Data];
SPTest = [out.yout{21}.Values.Data,out.yout{22}.Values.Data];
DVsetTest = [out.yout{25}.Values.Data,out.yout{26}.Values.Data,out.yout{27}.Values.Data,out.yout{28}.Values.Data];
DVactTest = [out.yout{11}.Values.Data,out.yout{13}.Values.Data,out.yout{29}.Values.Data,out.yout{24}.Values.Data]; % To, Tc, Fb,Fm
labels = {'Vo','Cao','Cbo','Cmo','Level','Vout','Ca','Cb','Cc','Cm','To','T','Tc','mc'};
[stationaryTest] = groundtruth(XNoNoiseTest,SPTest,DVsetTest,DVactTest);
MemoTest = stationaryTest.*MemoT'; %Need this for when the mode is zero!
clear out 
out = sim('PropGlycAdjustedARNew1.slx',duration); % Run Simulation with Noise
XTest = [out.yout{1}.Values.Data,out.yout{2}.Values.Data, out.yout{3}.Values.Data, out.yout{4}.Values.Data, out.yout{5}.Values.Data, out.yout{6}.Values.Data, out.yout{7}.Values.Data, out.yout{8}.Values.Data, out.yout{9}.Values.Data, out.yout{10}.Values.Data, out.yout{11}.Values.Data,out.yout{12}.Values.Data, out.yout{13}.Values.Data, out.yout{14}.Values.Data, out.yout{15}.Values.Data, out.yout{16}.Values.Data, out.yout{17}.Values.Data, out.yout{18}.Values.Data, out.yout{19}.Values.Data, out.yout{20}.Values.Data];
clear out
XTest = XTest(:,1:14);
%%  PCA (procedure 3.2.1) (On training data)
varianceRetained = 0.98;
[retainedPCTrain, stdparamTrain, eigenvals,V,StatScores1] = PCmodel(XTrain(:,1:14),'corr',varianceRetained);

%% Preform Steady State Detection (procedure 3.2.2)
[stationary,probstat] = isstat(XTrain(:,1:14),windowSize,significance*ones(14),SSDThresh);
A = X(stationary==1,:); % Remove detected transients

%% Preform State Analysis (procedure 3.2.3)
[seeds] = getseeds(StatScores1,1,2); % Get initial parameters estimates via K-means
[BIC] = investigatecluster(StatScores1,CM,seeds); % Select config based on lowest BIC
[gmfitS,BIC,idx,TrainData] = GMMclus(StatScores1,selected,'full',false,seeds{selected},0,0);  % Fit chosen GMM, last two binaries refer to if Gaussian refinement or deletion takes place
[NLLP,LocalNLLPthresh] = detNLLPlocalThresh(gmfit,TrainData,precentile); % Determine local thresholds
%% Preform Connectivity Analysis (procedure 3.2.4)
[ModeKPI,conMat] = drawmap(stationary,gmfit,StatScores1,SPTrain,100,LocalNLLPthresh,XTrain(:,1:14))

%% Evaluate on Testing Data (procedure 3.2.5)
standardTest = bsxfun(@rdivide, (XTest(:,1:14)-stdparamTrain(1,:)), (stdparamTrain(2,:)));
scoresTest = standardTest*retainedPCTrain; % Project test data into latent space
[modeNLLP,PropThresh,NLLP] = detmode(gmfit,[scoresTest],LocalNLLPthresh); %Determine state of testing data
[modeDelay] = transDelay(modeNLLP,3); % Include Detection Delay
[GlobalEff,LocalEff] = evalEfficiency(modeDelay,XTrain(:,1:14),ModeKPI,conMat); % Detemine relative efficiency
%% Determine if 
[F1S, RecallS, PrecisionS,confusMS] = evalRes(modeDelay,MemoTest'); % Calculate model performance


