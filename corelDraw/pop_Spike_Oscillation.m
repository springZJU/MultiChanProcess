clc;clear
monkeyName = "DDZ";
rootPathFig = "E:\MonkeyLinearArray\Figure\CTL_New\";

%% set protocols
temp = dir(rootPathFig);
temp(ismember(string({temp.name}'), [".", ".."])) = [];
protocols = string({temp.name}');

%% select data
dateSel = "";
% protSel = ["TB_Basic_4_4.06_Contol_Tone", "TB_Ratio_4_4.04", "TB_Var_400_200_100_50_Reg", "TB_BaseICI_4_8_16"];
protSel = ["TB_Oscillation_500_250_125_60_30_BF"];

for rIndex = 1 : length(protocols)
    clear popAll popRes
    %% load excel
    configPath = strcat(fileparts(mfilename("fullpath")), "\MLA_", monkeyName, "_NeuronSelect.xlsx");
    popRes = table2struct(readtable(configPath));
    DATAPATH = "E:\MonkeyLinearArray\ProcessedData\";

    protPathFig = strcat(rootPathFig, protocols(rIndex), "\");
    temp = dir(protPathFig);
    temp(ismember(string({temp.name}'), [".", ".."])) = [];
    FIGPATH = cellfun(@(x) string([char(protPathFig), x, '\']), {temp.name}', "UniformOutput", false);
    FIGPATH = string(FIGPATH( contains(string(FIGPATH), dateSel) & contains(string(FIGPATH), protSel)));
    if isempty(FIGPATH)
        continue
    end
    temp = regexpi(string(FIGPATH), strcat(monkeyName, "\d*"), "match");
    FIGPATH(cellfun(@isempty, temp)) = [];
    Dates = [temp{:}]';
    load(strcat(FIGPATH(1), "res.mat"));
    for pIndex = 1 : length(chSpikeLfp)
        popAll(pIndex).stimStr = chSpikeLfp(pIndex).stimStr;
        popAll(pIndex).chSPK = [];
        popAll(pIndex).chLFP = [];
        
    end
    for fIndex = 1 : length(FIGPATH)
        DATANAME = strcat(FIGPATH(fIndex), "res.mat");
        load(DATANAME);
        chSPK = chSpikeLfp(1).chSPK;
        
        chIdx = matches(string({chSPK.info}'), string(strsplit(popRes(fIndex).ChSelect, ',')));
        popRes(fIndex).chSpikeLfp = chSpikeLfp;
        popRes(fIndex).chLFP = chLFP;
        popRes(fIndex).chCSD = chCSD;
        popRes(fIndex).chMUA = chMUA;
        if isempty(popRes(fIndex).ChSelect)
            continue
        end
        for pIndex = 1 : length(chSpikeLfp)
            chSpikeLfp(pIndex).trialNumRaw = chSpikeLfp(pIndex).trialNum;
            chSpikeLfp(pIndex).chSPK(~chIdx) = [];
            chSpikeLfp(pIndex).chLFP(~chIdx) = [];
            chSpikeLfp = smthRasterPSTH(chSpikeLfp, pIndex);
            

            [frMean_1, frSE_1, countRaw_1] = cellfun(@(x) calFR(x, [0, 100], chSpikeLfp(pIndex).trialsRaw), {chSpikeLfp(pIndex).chSPK.spikePlot}', "UniformOutput", false);
            [frMean_0, frSE_0, countRaw_0] = cellfun(@(x) calFR(x, [-100, 0], chSpikeLfp(pIndex).trialsRaw), {chSpikeLfp(pIndex).chSPK.spikePlot}', "UniformOutput", false);
            [p_ranksum, h_ranksum] = cellfun(@(x, y) ranksum(x, y), countRaw_0, countRaw_1, "UniformOutput", false);
            [h_ttest, p_ttest] = cellfun(@(x, y) ttest(x, y), countRaw_0, countRaw_1, "UniformOutput", false);

            chSpikeLfp(pIndex).chSPK = addFieldToStruct(chSpikeLfp(pIndex).chSPK, ...
                [cellstr(repmat(Dates(fIndex), sum(chIdx), 1)), ...
                repmat({chSpikeLfp(pIndex).trialsRaw'}, sum(chIdx), 1), ...
                frMean_1, frSE_1, countRaw_1,frMean_0, frSE_0, countRaw_0, h_ranksum, p_ranksum, h_ttest, p_ttest], ...
                ["Date"; "trialsRaw"; "frMean_1"; "frSE_1"; "countRaw_1"; "frMean_0"; "frSE_0"; "countRaw_0"; "h_ranksum"; "p_ranksum"; "h_ttest"; "p_ttest"]);
            chSpikeLfp(pIndex).chLFP = addFieldToStruct(chSpikeLfp(pIndex).chLFP, cellstr(repmat(Dates(fIndex), sum(chIdx), 1)), "Date");
            popAll(pIndex).chSPK = [popAll(pIndex).chSPK; chSpikeLfp(pIndex).chSPK];
            popAll(pIndex).chLFP = [popAll(pIndex).chLFP; chSpikeLfp(pIndex).chLFP];
            popAll(pIndex).chLFP = [popAll(pIndex).chLFP; chSpikeLfp(pIndex).chLFP];
        end
    end
    %% process population data
    for pIndex = 1 : length(popAll)
        temp = popAll(pIndex).chSPK;
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

