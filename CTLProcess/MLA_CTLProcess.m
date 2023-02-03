monkeyName = "DDZ";
clearvars -except monkeyName
clc; close all
rootPathMat = strcat("E:\MonkeyLinearArray\MAT Data\", monkeyName, "\CTL_New\");
rootPathFig = "E:\MonkeyLinearArray\Figure\CTL_New\";
recordPath = strcat(fileparts(fileparts(mfilename("fullpath"))), "\utils\MLA_New_", monkeyName, "_Recording.xlsx");

%% set protocols
temp = dir(rootPathMat);
temp(ismember(string({temp.name}'), [".", ".."])) = [];
protocols = string({temp.name}');

%% select data
dateSel = "";
protSel = ["TB_Basic_4_4.06_Contol_Tone", "TB_Oscillation_500_250_125_60_30_BF"];
% protSel = "";
for rIndex = 1 : length(protocols)

    protPathMat = strcat(rootPathMat, protocols(rIndex), "\");
    protocolStr = protocols(rIndex);

    temp = dir(protPathMat);
    temp(ismember(string({temp.name}'), [".", ".."])) = [];
    FIGPATH = strcat(rootPathFig, protocolStr, "\");

    MATPATH = cellfun(@(x) string([char(protPathMat), x, '\']), {temp.name}', "UniformOutput", false);
    MATPATH = MATPATH( contains(string(MATPATH), dateSel) & contains(string(MATPATH), protSel) );

    for mIndex = 13 : length(MATPATH)

        if strcmp(protocolStr, "Noise")
            % MLA_Noise(MATPATH{mIndex}, FIGPATH);
            continue

        elseif strcmp(protocolStr, "BF_CSD_Nice")
            MLA_CSD(MATPATH{mIndex}, FIGPATH);

        elseif matches(protocolStr, ["ToneCF", "Tone_Prior_CF"])
            MLA_FRA(MATPATH{mIndex}, FIGPATH);

        elseif MLA_IsCTLProt(protocolStr) 
            MLA_ClickTrainProcess(MATPATH{mIndex}, FIGPATH);

        elseif MLA_IsMSTIProt(protocolStr) 
            MLA_MSTI_Process(MATPATH{mIndex}, FIGPATH);
            
        end
    end
end