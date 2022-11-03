clear; clc;
rootPathMat = "E:\MonkeyLinearArray\MAT Data\DDZ\ClickTrainLongTerm\";
rootPathFig = "E:\MonkeyLinearArray\Figure\ClickTrainLongTerm\";

%% set protocols
temp = dir(rootPathMat);
temp(ismember(string({temp.name}'), [".", ".."])) = [];
protocols = string({temp.name}');

%% select data
dateSel = "";
protSel = "BF_CSD_Nice";

for rIndex = 1 : length(protocols)

    protPathMat = strcat(rootPathMat, protocols(rIndex), "\");
    protocolStr = protocols(rIndex);

    temp = dir(protPathMat);
    temp(ismember(string({temp.name}'), [".", ".."])) = [];
    
    MATPATH = cellfun(@(x) string([char(protPathMat), x, '\']), {temp.name}', "UniformOutput", false);
    FIGPATH = strcat(rootPathFig, protocolStr, "\");

    indSel = all(cell2mat([cellfun(@(x) contains(x, dateSel), MATPATH, "uni", false), cellfun(@(x) contains(x, protSel), MATPATH, "uni", false)]), 2);
    MATPATH = MATPATH(indSel);

    for mIndex = 1 : length(MATPATH)
        if strcmp(protocolStr, "Noise")
            %         MLA_Noise(MATPATH{mIndex}, FIGPATH);
            continue
        elseif strcmp(protocolStr, "BF_CSD_Nice")
            MLA_CSD(MATPATH{mIndex}, FIGPATH);
%             continue
        elseif strcmp(protocolStr, "Tone_CF")
            MLA_FRA(MATPATH{mIndex}, FIGPATH);
        else
%             clickTrainLongTermProcess(MATPATH{mIndex}, FIGPATH);
            continue;
        end
    end
end