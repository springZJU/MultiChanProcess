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

run("generalCodes_Offset.m");

%% find offset duration threshold
CTLParams = MLA_ParseCTLParams(protSel);
parseStruct(CTLParams);
if strcmpi(protSel, "Offset_Duration_Effect_4ms_Reg_New")
    Offset_ThrVal = [256, 128, 64, 32, 16, 8, 4, 2, 1, 360];
elseif strcmpi(protSel, "Offset_Duration_Effect_16ms_Reg_New")
    Offset_ThrVal = [64, 32, 16, 8, 4, 2, 1, 100];
end
rspWin = [0, 200];
sponWin = [-200, 0];
temp = structSelect(plotRes, "sig");

run("Utils_Duration_MinimalICI.m");