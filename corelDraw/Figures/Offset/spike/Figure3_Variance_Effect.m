clc;clear;

%% load data
protSel = "Offset_Variance_Effect_4ms_16ms_sigma250_2_500msReg";
popResPath = "E:\MonkeyLinearArray\ProcessedData\";
DATAPATH = strcat(popResPath, protSel, "\popRes");
load(DATAPATH);

%% plot data
% RegSigIdx = any([popAll.sigIdxHigh], 2);
% RegSigIdx = cell2mat(cellfun(@(x, y, z) x>y+2*z, {popAll(end).chSPK.frMean_OnsetRsp}', {popAll(end).chSPK.frMean_OnsetSpon}', {popAll(1).chSPK.frSE_OnsetSpon}', "UniformOutput", false));
RegSigIdx = true(length(popAll(1).chSPK), 1);
RegNoSigIdx = ~RegSigIdx;
Idx = 1:10;
run("generalCodes_Offset.m");

%%
frRawMeanFlip = flipud(frRawMean);
frRawSEFlip = flipud(frRaw(:, 2:2:end));
temp = frRawMeanFlip(1:5, :);
tempSE = frRawSEFlip(1:5, :);
IrregHigh.Idx = find(temp(end, :) >= temp(1, :))'; % +2*tempSE(1, :)
IrregHigh.date = string({toPlot(IrregHigh.Idx).CH})';
IrregLow.Idx = find(temp(end, :) <= temp(1, :))'; % -2*tempSE(1, :)
IrregLow.date = string({toPlot(IrregLow.Idx).CH})';
IrregHigh.frRaw = frRawMeanFlip(:, IrregHigh.Idx);
IrregHigh.frMean = mean(frRawMeanFlip(:, IrregHigh.Idx), 2);
IrregHigh.se = SE(frRawMeanFlip(:, IrregHigh.Idx), 2);
IrregLow.frRaw = frRawMeanFlip(:, IrregLow.Idx);
IrregLow.frMean = mean(frRawMeanFlip(:, IrregLow.Idx), 2);
IrregLow.se = SE(frRawMeanFlip(:, IrregLow.Idx), 2);



%% anova
pAnova.frRaw = mAnova_Col(frRaw(1:end-1, :)');
pAnova.peak = mAnova_Col(peakRaw(1:end-1, :)');
pAnova.latency = mAnova_Col(latencyRaw(1:end-1, :)');
pAnova.AUCRaw = mAnova_Col(AUCRaw(1:end-1, :)');