clc;clear
monkeyName = ["DDZ", "CM"];
rootPathFig = "E:\MonkeyLinearArray\Figure\CTL_New\";

%% window settings
spikeWin  = [0, 200];
offSponWin = [200, 400];
onsetSponWin = [-200, 0];
%% set protocols
temp = dir(rootPathFig);
temp(ismember(string({temp.name}'), [".", ".."])) = [];
protocols = string({temp.name}');

%% select data
dateSel = "";
% protSel = ["TB_Basic_4_4.06_Contol_Tone", "TB_Ratio_4_4.04", "TB_Var_400_200_100_50_Reg", "TB_BaseICI_4_8_16"];
% protSel = ["Offset_2_128_4s_New", "Offset_Duration_Effect_4ms_Reg_New", "Offset_Duration_Effect_16ms_Reg_New", "Offset_Variance_Effect_4ms_16ms_sigma250_2_500msReg"];
protSel = ["Offset_Duration_Effect_4ms_Reg_New"];

%% load excel


for rIndex = 1 : length(protocols)
    clear popAll popRes
    for mIndex = 1 : length(monkeyName)
        configPath = strcat(fileparts(mfilename("fullpath")), "\MLA_", monkeyName, "_NeuronSelect.xlsx");
        popRes{mIndex, 1} = table2struct(readtable(configPath(mIndex)));
    end
    popRes = cell2mat(popRes);
    DATAPATH = "E:\MonkeyLinearArray\ProcessedData\";

    protPathFig = strcat(rootPathFig, protocols(rIndex), "\");
    temp = dir(protPathFig);
    temp(ismember(string({temp.name}'), [".", ".."])) = [];
    FIGPATH = cellfun(@(x) string([char(protPathFig), x, '\']), {temp.name}', "UniformOutput", false);
    FIGPATH = string(FIGPATH( contains(string(FIGPATH), dateSel) & contains(string(FIGPATH), protSel)));
    if isempty(FIGPATH)
        continue
    end
    %%
    CTLParams = MLA_ParseCTLParams(protocols(rIndex));
    parseStruct(CTLParams);

    clear temp
    for mIndex = 1 : length(monkeyName)
        temp(:, mIndex) = regexpi(string(FIGPATH), strcat(monkeyName(mIndex), "\d*"), "match");
    end
    temp = rowFcn(@(x) [x{1}, x{2}], temp, "UniformOutput", false);

    FIGPATH(cellfun(@isempty, temp)) = [];
    Dates = [temp{:}]';
    load(strcat(FIGPATH(1), "res.mat"));

    for pIndex = 1 : length(chSpikeLfp)
        popAll(pIndex).stimStr = chSpikeLfp(pIndex).stimStr;
        popAll(pIndex).chSPK = [];
        popAll(pIndex).chLFP = [];
    end

    %%
    for fIndex = 1 : length(popRes)
        Idx = contains(FIGPATH, popRes(fIndex).Date, "IgnoreCase", true);
        if isempty(find(Idx, 1))
            continue
        end

        DATANAME = strcat(FIGPATH(Idx), "res.mat");
        load(DATANAME);
        chSPK = chSpikeLfp(1).chSPK;
        chIdx = matches(string({chSPK.info}'), string(strsplit(popRes(fIndex).ChSelect, ',')));
        popRes(fIndex).chSpikeLfp = chSpikeLfp;
        popRes(fIndex).chLFP = structSelect(chAll, ["info", "chLFP"]);
        popRes(fIndex).rawLFP = structSelect(chAll, ["info", "rawLFP"]);
        popRes(fIndex).chCSD = structSelect(chAll, ["info", "chCSD"]);
        popRes(fIndex).chMUA = structSelect(chAll, ["info", "chMUA"]);

        if isempty(popRes(fIndex).ChSelect)
            continue
        end

        if strcmpi(protSel, "Offset_2_128_4s_New")
            run("offset_ICIScreening.m")
        elseif contains(protSel, ["Offset_Duration_Effect_4ms_Reg_New", "Offset_Duration_Effect_16ms_Reg_New"])
            run("offset_DurEffect.m");
        elseif strcmp(protSel, "Offset_Variance_Effect_4ms_16ms_sigma250_2_500msReg")
            run("offset_Variance.m");
        end

    end

    %% process population data
    for pIndex = 1 : length(popAll)
        temp = popAll(pIndex).chSPK;
        temp = chSPK_Patch(temp);
        popAll(pIndex).sigOnsetIdx = logical([temp.h_Onset_T])';
        popAll(pIndex).sigOnsetHighIdx = logical([temp.h_Onset_High])';
        popAll(pIndex).sigOnsetLowIdx = logical([temp.h_Onset_Low])';
        popAll(pIndex).sigIdx = logical([temp.h_ttest])';
        popAll(pIndex).sigIdxHigh = logical([temp.h_ttest]' & [temp.frMean_1]' > [temp.frMean_0]');
        popAll(pIndex).sigIdxLow = logical([temp.h_ttest]' & [temp.frMean_1]' <= [temp.frMean_0]');
        popAll(pIndex).sigSPK = popAll(pIndex).chSPK(popAll(pIndex).sigIdx);
        popAll(pIndex).sigSPKHigh = popAll(pIndex).chSPK(popAll(pIndex).sigIdxHigh);
        popAll(pIndex).sigSPKLow = popAll(pIndex).chSPK(popAll(pIndex).sigIdxLow);
        popAll(pIndex).noSigSPK = popAll(pIndex).chSPK(~ismember(1:length(temp), find([temp.h_ttest]')));
    end
    SAVENAME = strcat(DATAPATH, protocols(rIndex), "\");
    mkdir(SAVENAME);
    save(strcat(SAVENAME, "popRes.mat"), "popRes", "popAll");
end


