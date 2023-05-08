clear; clc
monkeyName = ["DDZ", "CM"];
for mIndex = 1 : length(monkeyName)
configPath = strcat("E:\MonkeyLinearArray\MultiChanProcess\corelDraw\MLA_", monkeyName(mIndex), "_NeuronSelect.xlsx");
popConfig{mIndex, 1} = table2struct(readtable(configPath));
end
popConfig = vertcat(popConfig{:});

load("E:\MonkeyLinearArray\ProcessedData\TB_BaseICI_4_8_16\popRes.mat")
% popResBackup = popRes;
% popConfigBackup = popConfig;
% exclude_Date = cellstr(["ddz20221203"; "ddz20221209"]);
% exclude_Trial = {[6, 8, 13]; 18};
% exclude_Prot = {2; 5};
% excludeTrial = cell2struct([exclude_Date,  exclude_Trial,  exclude_Prot], ["Date", "Trial", "Prot"], 2);
selDate = "cm20230310";
excludeDate = ["ddz20221130", "ddz20221214", "ddz20221217", "ddz20221223", "ddz20221226", "ddz20221227"];
if exist("excludeDate", "var")
    popConfig(matches({popRes.Date}', excludeDate)) = [];
    popRes(matches({popRes.Date}', excludeDate)) = [];
end
%% example CSD and MUA
run("generateLFP_CSD_MUA_Amp.m");

%% set idx
idx = [1, 3];
run("generateRspPool.m");

%% set conpare Idx
compareIdx = [3, 1];
run("generateDiffAmpSigRatio");
%% anova pop
anovaIdx = [1, 3];
run("generatePopAnova.m");
%% dateSel Res
run("generateExampleData.m");

% %% cdrPlot data
% run("generateCdrPlot.m");
% 
% %% slope
% x = [1, 2]';
% slopeIdx = [1, 2];
% ampIdx =  [2, 3];
% run("generateSlope.m");