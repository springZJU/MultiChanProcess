clc;clear
monkeyName = ["DDZ", "CM"];
rootPathFig = "E:\MonkeyLinearArray\Figure\CTL_New\";

%% set protocols
temp = dir(rootPathFig);
temp(ismember(string({temp.name}'), [".", ".."])) = [];
protocols = string({temp.name}');

%% select data
dateSel = "";
% protSel = ["TB_Basic_4_4.06_Contol_Tone", "TB_Ratio_4_4.04", "TB_Var_400_200_100_50_Reg", "TB_BaseICI_4_8_16"];
% protSel = ["Offset_2_128_4s_New", "Offset_Duration_Effect_4ms_Reg_New", "Offset_Duration_Effect_16ms_Reg_New", "Offset_Variance_Effect_4ms_16ms_sigma250_2_500msReg"];
protSel = ["TITS_26o4_24_40"];

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
        for pIndex = 1 : length(chSpikeLfp)
            chSpikeLfp(pIndex).trialNumRaw = chSpikeLfp(pIndex).trialNum;
            chSpikeLfp(pIndex).chSPK(~chIdx) = [];
            chSpikeLfp(pIndex).chLFP(~chIdx) = [];
            chSpikeLfp = smthRasterPSTH(chSpikeLfp, pIndex);


            [frMean_1, frSE_1, countRaw_1] = cellfun(@(x) calFR(x, [0, 200], chSpikeLfp(pIndex).trialsRaw), {chSpikeLfp(pIndex).chSPK.spikePlot}', "UniformOutput", false);
            [frMean_0, frSE_0, countRaw_0] = cellfun(@(x) calFR(x, [-200, 0], chSpikeLfp(pIndex).trialsRaw), {chSpikeLfp(pIndex).chSPK.spikePlot}', "UniformOutput", false);

            %             distSelf = cellfun(@(x, y) distanceToDiagonal(x, y, "log10"), frMean_1, frMean_0, "UniformOutput", false);
            %           latency = cellfun(@(x) spkLatency(x, [-300, 0], [0, 300], chSpikeLfp(pIndex).trialsRaw), {chSpikeLfp(pIndex).chSPK.spikePlot}', "UniformOutput", false);
            spikePlot = {chSpikeLfp(pIndex).chSPK.spikePlot}';
            RS = cellfun(@(x) RayleighStatistic(x(:, 1), BaseICI(pIndex), chSpikeLfp(pIndex).trialNumRaw), spikePlot, "UniformOutput", false);
            [peak, width, latency] = cellfun(@(x) peakWidthLatency(x, [-200, 0], [0, 200], chSpikeLfp(pIndex).trialsRaw, protocols(rIndex)), {chSpikeLfp(pIndex).chSPK.spikePlot}', "UniformOutput", false);
            TBI_Raw = cellfun(@(x, y) (x-y)./y, frMean_1, frMean_0, "UniformOutput", false);
            TBI_Raw = cellfun(@(x) x(~isnan(x)&~isinf(x)), TBI_Raw, "UniformOutput", false);
            TBI_Mean = cellfun(@(x) mean(x), TBI_Raw, "UniformOutput", false);
            TBI_SE = cellfun(@(x) std(x)/sqrt(length(x)), TBI_Raw, "UniformOutput", false);
            %             TBI_Mean = cellfun(@mean, TBI_Raw);
            zscoreRaw_1 = cellfun(@(x) zscore(x), countRaw_1, "UniformOutput", false);
            % t-test
            
            [p_ranksum, h_ranksum] = cellfun(@(x, y) ranksum(x, y), countRaw_0, countRaw_1, "UniformOutput", false);
            [h_ttest, p_ttest] = cellfun(@(x, y) ttest(x, y), countRaw_0, countRaw_1, "UniformOutput", false);
            chSpikeLfp(pIndex).chSPK = addFieldToStruct(chSpikeLfp(pIndex).chSPK, ...
                [cellfun(@(x, y) [x, y], cellstr(repmat(Dates(Idx), sum(chIdx), 1)), {chSpikeLfp(pIndex).chSPK.info}' , "UniformOutput", false),...
                cellstr(repmat(Dates(Idx), sum(chIdx), 1)), ...
                repmat({chSpikeLfp(pIndex).trialsRaw'}, sum(chIdx), 1), ...
                frMean_1, frSE_1, countRaw_1,frMean_0, frSE_0, countRaw_0, zscoreRaw_1, TBI_Raw, TBI_Mean, TBI_SE, ...
                peak, width, latency, h_ranksum, p_ranksum, h_ttest, p_ttest, RS], ...
                ["CH"; "Date"; "trialsRaw"; "frMean_1"; "frSE_1"; "countRaw_1"; "frMean_0"; "frSE_0"; "countRaw_0"; "zscoreRaw_1"; "TBI_Raw"; "TBI_Mean"; "TBI_SE"; ...
                "peak"; "width"; "latency"; "h_ranksum"; "p_ranksum"; "h_ttest"; "p_ttest"; "RS"]);
            chSpikeLfp(pIndex).chLFP = addFieldToStruct(chSpikeLfp(pIndex).chLFP, cellstr(repmat(Dates(Idx), sum(chIdx), 1)), "Date");
            popAll(pIndex).chSPK = [popAll(pIndex).chSPK; chSpikeLfp(pIndex).chSPK];
            popAll(pIndex).chLFP = [popAll(pIndex).chLFP; chSpikeLfp(pIndex).chLFP];
        end
    end

    %% process population data
    for pIndex = 1 : length(popAll)
        temp = popAll(pIndex).chSPK;
        temp = chSPK_Patch(temp);
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

