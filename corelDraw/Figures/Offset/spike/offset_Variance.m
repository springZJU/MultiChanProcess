spikeWin  = [0, 200];
onsetSponWin = [-200, 0];
for pIndex = 1 : length(chSpikeLfp)
    chSpikeLfp(pIndex).trialNumRaw = chSpikeLfp(pIndex).trialNum;
    chSpikeLfp(pIndex).chSPK(~chIdx) = [];
    chSpikeLfp(pIndex).chLFP(~chIdx) = [];
    chSpikeLfp = smthRasterPSTH(chSpikeLfp, pIndex);

    % significant onset response
    [frMean_OnsetRsp, frSE_OnsetRSP, countRaw_OnsetRsp] = cellfun(@(x) calFR(x, [0, 100] - S1Duration(pIndex), chSpikeLfp(pIndex).trialsRaw), {chSpikeLfp(pIndex).chSPK.spikePlot}', "UniformOutput", false);
    [frMean_OnsetSpon, frSE_OnsetSpon, countRaw_OnsetSpon] = cellfun(@(x) calFR(x, [-100, 0] - S1Duration(pIndex), chSpikeLfp(pIndex).trialsRaw), {chSpikeLfp(pIndex).chSPK.spikePlot}', "UniformOutput", false);
    [h_Onset_T, p_Onset_T] = cellfun(@(x, y) ttest(x, y), countRaw_OnsetRsp, countRaw_OnsetSpon, "UniformOutput", false);
    h_High = cellfun(@(x, y) double(mean(x) < mean(y)), countRaw_OnsetSpon, countRaw_OnsetRsp, "UniformOutput", false);
    h_Onset_T = cellfun(@(x) replaceNaN(x, 0), h_Onset_T, "UniformOutput", false);
    p_Onset_T = cellfun(@(x) replaceNaN(x, 0), p_Onset_T, "UniformOutput", false);
    h_Onset_High = cellfun(@(x, y) x.*y, h_Onset_T, h_High, "UniformOutput", false);
    h_Onset_Low = cellfun(@(x, y) x.*(1-y), h_Onset_T, h_High, "UniformOutput", false);
    % validate offset firing rate
    [frMean_1, frSE_1, countRaw_1] = cellfun(@(x) calFR(x, spikeWin, chSpikeLfp(pIndex).trialsRaw), {chSpikeLfp(pIndex).chSPK.spikePlot}', "UniformOutput", false);
    [frMean_0, frSE_0, countRaw_0] = cellfun(@(x) calFR(x, onsetSponWin - S1Duration(pIndex), chSpikeLfp(pIndex).trialsRaw), {chSpikeLfp(pIndex).chSPK.spikePlot}', "UniformOutput", false);
    spikePlot = {chSpikeLfp(pIndex).chSPK.spikePlot}';
    RS = cellfun(@(x) RayleighStatistic(x(:, 1), BaseICI(pIndex), chSpikeLfp(pIndex).trialNumRaw), spikePlot, "UniformOutput", false);
    [peak, width, latency] = cellfun(@(x) peakWidthLatency(x, onsetSponWin - S1Duration(pIndex), spikeWin, chSpikeLfp(pIndex).trialsRaw, protocols(rIndex)), {chSpikeLfp(pIndex).chSPK.spikePlot}', "UniformOutput", false);

    % t-test
    [p_ranksum, h_ranksum] = cellfun(@(x, y) ranksum(x, y), countRaw_0, countRaw_1, "UniformOutput", false);
    [h_ttest, p_ttest] = cellfun(@(x, y) ttest(x, y), countRaw_0, countRaw_1, "UniformOutput", false);
    chSpikeLfp(pIndex).chSPK = addFieldToStruct(chSpikeLfp(pIndex).chSPK, ...
        [cellfun(@(x, y) [x, y], cellstr(repmat(Dates(Idx), sum(chIdx), 1)), {chSpikeLfp(pIndex).chSPK.info}' , "UniformOutput", false),...
        cellstr(repmat(Dates(Idx), sum(chIdx), 1)), ...
        repmat({chSpikeLfp(pIndex).trialsRaw'}, sum(chIdx), 1), ...
        frMean_1, frSE_1, countRaw_1,frMean_0, frSE_0, countRaw_0, frMean_OnsetRsp, frSE_OnsetRSP, frMean_OnsetSpon, frSE_OnsetSpon, ...
        RS, peak, width, latency, h_ranksum, p_ranksum, h_ttest, p_ttest, h_Onset_T, p_Onset_T, h_Onset_High, h_Onset_Low], ...
        ["CH"; "Date"; "trialsRaw"; "frMean_1"; "frSE_1"; "countRaw_1"; "frMean_0"; "frSE_0"; "countRaw_0"; "frMean_OnsetRsp"; "frSE_OnsetRSP"; "frMean_OnsetSpon"; "frSE_OnsetSpon"; ...
        "RS"; "peak"; "width"; "latency"; "h_ranksum"; "p_ranksum"; "h_ttest"; "p_ttest"; "h_Onset_T"; "p_Onset_T"; "h_Onset_High"; "h_Onset_Low"]);
    chSpikeLfp(pIndex).chLFP = addFieldToStruct(chSpikeLfp(pIndex).chLFP, cellstr(repmat(Dates(Idx), sum(chIdx), 1)), "Date");
    popAll(pIndex).chSPK = [popAll(pIndex).chSPK; chSpikeLfp(pIndex).chSPK];
    popAll(pIndex).chLFP = [popAll(pIndex).chLFP; chSpikeLfp(pIndex).chLFP];
end