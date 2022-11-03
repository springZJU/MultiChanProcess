function MLA_CSD(MATPATH, FIGPATH)
%% Parameter setting

temp = strsplit(MATPATH, "\");
dateStr = string(temp{end - 1});
DATAPATH = strcat(MATPATH, "data.mat");
FIGPATH = strcat(FIGPATH, dateStr, "\");

run("CSD_Config.m");

[trialAll, LFPDataset] = CSD_Preprocess(DATAPATH);
[trialAll, WAVEDataset] = MUA_Preprocess(DATAPATH);

CSD_Process
MUA_Process
window = [0 1000];
[trialsLPF, chLfpMean] = selectEcog(LFPDataset, trialAll, "trial onset", window);
trialsWAVE = selectEcog(WAVEDataset, trialAll, "trial onset", window);

%% save figures
mkdir(FIGPATH);
for cIndex = 1 : length(Fig)
    print(Fig(cIndex), strcat(FIGPATH,"ch", num2str(ch(cIndex) + 1)), "-djpeg", "-r200");
end

close all
end