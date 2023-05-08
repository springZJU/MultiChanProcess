clc;clear;

%% load data
protSel = "TB_Var_400_200_100_50_Reg";
popResPath = "E:\MonkeyLinearArray\ProcessedData\";
DATAPATH = strcat(popResPath, protSel, "\popRes");
load(DATAPATH);

%% plot data
RegSigIdx = logical(popAll(5).sigIdxHigh);
RegNoSigIdx = ~RegSigIdx;
Idx = [4,3,2,1,5];
x = -[1/50, 1/100, 1/200, 1/400, 0]';
run("generalCodes.m");

%% anova
pAnova.frRaw = mAnova_Col(frRaw(1:end-1, :)');
pAnova.frNormRaw = mAnova_Col(frNormRaw(1:end-1, :)');
pAnova.peak = mAnova_Col(peakRaw(1:end-1, :)');
pAnova.latency = mAnova_Col(latencyRaw(1:end-1, :)');
pAnova.AUCRaw = mAnova_Col(AUCRaw(1:end-1, :)');