clear; clc
monkeyName = ["DDZ", "CM"];
for mIndex = 1 : length(monkeyName)
configPath = strcat("E:\MonkeyLinearArray\MultiChanProcess\corelDraw\MLA_", monkeyName(mIndex), "_NeuronSelect.xlsx");
popConfig{mIndex, 1} = table2struct(readtable(configPath));
end
popConfig = vertcat(popConfig{:});

load("E:\MonkeyLinearArray\ProcessedData\TB_Basic_4_4.06_Contol_Tone\popRes.mat")
% popResBackup = popRes;
% popConfigBackup = popConfig;
% exclude_Date = cellstr([]);
% exclude_Trial = {[]};
% exclude_Prot = {[]};
% excludeTrial = cell2struct([exclude_Date,  exclude_Trial,  exclude_Prot], ["Date", "Trial", "Prot"], 2);

selDate = "ddz20221201";
excludeDate = ["ddz20221130", "ddz20221214", "ddz20221217", "ddz20221223", "ddz20221226", "ddz20221227"];
if exist("excludeDate", "var")
    popConfig(matches({popRes.Date}', excludeDate)) = [];
    popRes(matches({popRes.Date}', excludeDate)) = [];
end
%% example CSD and MUA
run("generateLFP_CSD_MUA_Amp.m");

%% set idx
idx = [1,3];
run("generateRspPool.m");

%% set conpare Idx
compareIdx = [3, 1];
run("generateDiffAmpSigRatio");

%% anova pop
anovaIdx = [1, 3];
run("generatePopAnova.m");
%% dateSel Res
run("generateExampleData.m");

%% layer compare in reg4-4.06 
cmpStr = ["SgGr", "GrIg", "SgIg"];
cmpIdx = {[1, 2], [2, 3], [1, 3]};
for sIdx = 1 : length(sigString)
    % ttest
    for lIdx = 1 : length(cmpStr)
    regP.(sigString(sIdx))(lIdx).info = cmpStr(lIdx);
    [regP.(sigString(sIdx))(lIdx).h, regP.(sigString(sIdx))(lIdx).p] = ...
    ttest2(TBIs(1).(sigString(sIdx))(cmpIdx{lIdx}(1)).poolData, TBIs(1).(sigString(sIdx))(cmpIdx{lIdx}(2)).poolData);
    end

    % ANOVA-post hoc
    bufferReg{1,1} = [TBIs(1).(sigString(sIdx))(1).poolData, 1*ones(length(TBIs(1).(sigString(sIdx))(1).poolData), 1)];
    bufferReg{2,1} = [TBIs(1).(sigString(sIdx))(2).poolData, 2*ones(length(TBIs(1).(sigString(sIdx))(2).poolData), 1)];
    bufferReg{3,1} = [TBIs(1).(sigString(sIdx))(3).poolData, 3*ones(length(TBIs(1).(sigString(sIdx))(3).poolData), 1)];
    temp = cell2mat(bufferReg);
    [regAnova.(sigString(sIdx)).p, ~, regAnova.(sigString(sIdx)).status] = anova1(temp(:, 1), temp(:, 2), "off");
    regAnova.(sigString(sIdx)).c = multcompare(regAnova.(sigString(sIdx)).status, "Display","off");
end
c = multcompare(regAnova.MUA.status, "Display","off");

% %% cdrPlot data
% run("generateCdrPlot.m");
% 
% %% slope
% x = [1, 2]';
% slopeIdx = [2, 1];
% ampIdx = 1;
% run("generateSlope.m");