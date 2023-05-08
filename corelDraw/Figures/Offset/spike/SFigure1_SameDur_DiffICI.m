clc;clear;

%% load data
protSel = "Offset_2_128_4s_New";
popResPath = "E:\MonkeyLinearArray\ProcessedData\";
DATAPATH = strcat(popResPath, protSel, "\popRes");
load(DATAPATH);

%% plot data
% RegSigIdx = logical(popAll(1).sigOnsetIdx);
RegSigIdx = true(length(popAll(1).chSPK), 1);
RegNoSigIdx = ~RegSigIdx;
Idx = 1:9;
x = [1, 2, 4, 8, 16, 32, 64, 128, 8]';
SameDur_DiffICI = 1;
run("generalCodes_Offset.m");


