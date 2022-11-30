clear; clc;
warning("off");
monkeyName = "DD";
rootPathMat = strcat("E:\MonkeyLinearArray\MAT Data\", monkeyName, "\CTL_New\");
rootPathFig = "E:\MonkeyLinearArray\Figure\CTL_New\";
recordPath = strcat(fileparts(fileparts(mfilename("fullpath"))), "\utils\MLA_New_", monkeyName, "_Recording.xlsx");

%% set protocols
temp = dir(rootPathMat);
temp(ismember(string({temp.name}'), [".", ".."])) = [];
protocols = string({temp.name}');

%% select data
dateSel = "";
protSel = "";

for rIndex = 1 : length(protocols)

    protPathMat = strcat(rootPathMat, protocols(rIndex), "\");
    protocolStr = protocols(rIndex);

    temp = dir(protPathMat);
    temp(ismember(string({temp.name}'), [".", ".."])) = [];
    FIGPATH = strcat(rootPathFig, protocolStr, "\");

    MATPATH = cellfun(@(x) string([char(protPathMat), x, '\']), {temp.name}', "UniformOutput", false);
    MATPATH = MATPATH( contains(string(MATPATH), dateSel) & contains(string(MATPATH), protSel) );
    %     [MATPATH, recordInfo, excelIdx] = selUnprocessedMat(MATPATH, recordPath);

    for mIndex = 1 : length(MATPATH)

        if strcmp(protocolStr, "Noise")
            % MLA_Noise(MATPATH{mIndex}, FIGPATH);
            continue
        elseif strcmp(protocolStr, "BF_CSD_Nice")
            MLA_CSD(MATPATH{mIndex}, FIGPATH);
%             continue
        elseif matches(protocolStr, ["ToneCF", "Tone_Prior_CF"])
            MLA_FRA(MATPATH{mIndex}, FIGPATH);

        elseif MLA_IsCTLProt(protocolStr) % click train longterm
            try
                MLA_ClickTrainProcess(MATPATH{mIndex}, FIGPATH);
            catch e
                disp(e.message);
                e.stack(1)
                continue;
            end
        end
        %         recordInfo(excelIdx(mIndex)).processed = 1;
    end

    %     writetable(struct2table(recordInfo), recordPath);
end