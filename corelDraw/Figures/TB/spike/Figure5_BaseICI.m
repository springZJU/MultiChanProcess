clc;clear;

%% load data
protSel = "TB_BaseICI_4_8_16";
popResPath = "E:\MonkeyLinearArray\ProcessedData\";
DATAPATH = strcat(popResPath, protSel, "\popRes");
load(DATAPATH);
popAll = popAll(1:2:end);
%% plot data
RegSigIdx = logical(popAll(1).sigIdxHigh);
RegNoSigIdx = ~RegSigIdx;
Idx = [3,2,1];
x = [16,8,4]/1000';
plotWin = [-100, 300];
run("generalCodes.m");
%% anova 
pAnova.frRaw = mAnova_Col(frRaw');
pAnova.frNormRaw = mAnova_Col(frNormRaw');
pAnova.peak = mAnova_Col(peakRaw');
pAnova.latency = mAnova_Col(latencyRaw');
pAnova.AUCRaw = mAnova_Col(AUCRaw(1:end-1, :)');