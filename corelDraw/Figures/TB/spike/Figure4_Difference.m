clc;clear;
%% load data
protSel = "TB_Ratio_4_4.04";
popResPath = "E:\MonkeyLinearArray\ProcessedData\";
DATAPATH = strcat(popResPath, protSel, "\popRes");
load(DATAPATH);

%% plot data
RegSigIdx = logical(popAll(5).sigIdxHigh);
RegNoSigIdx = ~RegSigIdx;
Idx = [1,2,3,4,5];
x = [0, 2.5, 5, 7.5, 10]/1000';
run("generalCodes.m");

%% anova
pAnova.frRaw = mAnova_Col(frRaw(1:end-1, :)');
pAnova.frNormRaw = mAnova_Col(frNormRaw(1:end-1, :)');
pAnova.peak = mAnova_Col(peakRaw(1:end-1, :)');
pAnova.latency = mAnova_Col(latencyRaw(1:end-1, :)');
pAnova.AUCRaw = mAnova_Col(AUCRaw(1:end-1, :)');