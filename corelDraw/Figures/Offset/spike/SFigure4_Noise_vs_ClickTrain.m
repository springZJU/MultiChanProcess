clc;clear;

%% load data
protSel = "Offset_Duration_Effect_4ms_Reg_New";
% protSel = "Offset_Duration_Effect_16ms_Reg_New";
popResPath = "E:\MonkeyLinearArray\ProcessedData\";
DATAPATH = strcat(popResPath, protSel, "\popRes");
load(DATAPATH);

%% plot data
% RegSigIdx = cell2mat(cellfun(@(x, y, z) x>y+2*z, {popAll(1).chSPK.frMean_OnsetRsp}', {popAll(1).chSPK.frMean_OnsetSpon}', {popAll(1).chSPK.frSE_OnsetSpon}', "UniformOutput", false));
RegSigIdx = true(length(popAll(1).chSPK), 1);
RegNoSigIdx = ~RegSigIdx;
Noise_Click_Compare = 1;
run("generalCodes_Offset.m");

