for pIndex = 1 : length(chSpikeLfp)
            chSpikeLfp(pIndex).trialNumRaw = chSpikeLfp(pIndex).trialNum;
            chSpikeLfp(pIndex).chSPK(~chIdx) = [];
            chSpikeLfp(pIndex).chLFP(~chIdx) = [];
            chSpikeLfp = smthRasterPSTH(chSpikeLfp, pIndex);

            % significant onset response
            [~, ~, countRaw_OnsetRsp] = cellfun(@(x) calFR(x, spikeWin - S1Duration(pIndex), chSpikeLfp(pIndex).trialsRaw), {chSpikeLfp(pIndex).chSPK.spikePlot}', "UniformOutput", false);
            [~, ~, countRaw_OnsetSpon] = cellfun(@(x) calFR(x, onsetSponWin - S1Duration(pIndex), chSpikeLfp(pIndex).trialsRaw), {chSpikeLfp(pIndex).chSPK.spikePlot}', "UniformOutput", false);
            [h_Onset_T, p_Onset_T] = cellfun(@(x, y) ttest(x, y), countRaw_OnsetRsp, countRaw_OnsetSpon, "UniformOutput", false);
            
            % compute base firing rate
            [frMean_Base, frSE_Base, countRaw_Base] = cellfun(@(x) calFR(x, [-BaseICI(pIndex)*1, 0], chSpikeLfp(pIndex).trialsRaw), {chSpikeLfp(pIndex).chSPK.spikePlot}', "UniformOutput", false);
            countRaw_Base = cellfun(@(x) x/1, countRaw_Base, "UniformOutput", false);
            
            % validate offset firing rate
            [~, ~, countRaw_1] = cellfun(@(x) calFR(x, spikeWin, chSpikeLfp(pIndex).trialsRaw), {chSpikeLfp(pIndex).chSPK.spikePlot}', "UniformOutput", false);
            countRaw_1 = cellfun(@(x, y) x-y, countRaw_1, countRaw_Base, "UniformOutput", false);
            frMean_1 = cellfun(@(x) mean(x)*1000/diff(spikeWin), countRaw_1, "UniformOutput", false);
            frSE_1 = cellfun(@(x) SE(x)*1000/diff(spikeWin), countRaw_1, "UniformOutput", false);
            
            [frMean_0, frSE_0, countRaw_0] = cellfun(@(x) calFR(x, onsetSponWin - S1Duration(pIndex), chSpikeLfp(pIndex).trialsRaw), {chSpikeLfp(pIndex).chSPK.spikePlot}', "UniformOutput", false);
%             [frMean_0, frSE_0, countRaw_0] = cellfun(@(x) calFR(x, offSponWin, chSpikeLfp(pIndex).trialsRaw), {chSpikeLfp(pIndex).chSPK.spikePlot}', "UniformOutput", false);
            spikePlot = {chSpikeLfp(pIndex).chSPK.spikePlot}';
            RS = cellfun(@(x) RayleighStatistic(x(:, 1), BaseICI(pIndex), chSpikeLfp(pIndex).trialNumRaw), spikePlot, "UniformOutput", false);
            [peak, width, latency] = cellfun(@(x) peakWidthLatency(x, offSponWin, spikeWin, chSpikeLfp(pIndex).trialsRaw, protocols(rIndex)), {chSpikeLfp(pIndex).chSPK.spikePlot}', "UniformOutput", false);
            TBI_Raw = cellfun(@(x, y) (x-y)./y, frMean_1, frMean_0, "UniformOutput", false);
            TBI_Raw = cellfun(@(x) x(~isnan(x)&~isinf(x)), TBI_Raw, "UniformOutput", false);
            TBI_Mean = cellfun(@(x) mean(x), TBI_Raw, "UniformOutput", false);
            TBI_SE = cellfun(@(x) std(x)/sqrt(length(x)), TBI_Raw, "UniformOutput", false);
            zscoreRaw_1 = cellfun(@(x) zscore(x), countRaw_1, "UniformOutput", false);
            % t-test
            [p_ranksum, h_ranksum] = cellfun(@(x, y) ranksum(x, y), countRaw_0, countRaw_1, "UniformOutput", false);
            [h_ttest, p_ttest] = cellfun(@(x, y) ttest(x, y), countRaw_0, countRaw_1, "UniformOutput", false);
            chSpikeLfp(pIndex).chSPK = addFieldToStruct(chSpikeLfp(pIndex).chSPK, ...
                [cellfun(@(x, y) [x, y], cellstr(repmat(Dates(Idx), sum(chIdx), 1)), {chSpikeLfp(pIndex).chSPK.info}' , "UniformOutput", false),...
                cellstr(repmat(Dates(Idx), sum(chIdx), 1)), ...
                repmat({chSpikeLfp(pIndex).trialsRaw'}, sum(chIdx), 1), ...
                frMean_1, frSE_1, countRaw_1,frMean_0, frSE_0, countRaw_0, zscoreRaw_1, TBI_Raw, TBI_Mean, TBI_SE, ...
                RS, peak, width, latency, h_ranksum, p_ranksum, h_ttest, p_ttest, h_Onset_T, p_Onset_T], ...
                ["CH"; "Date"; "trialsRaw"; "frMean_1"; "frSE_1"; "countRaw_1"; "frMean_0"; "frSE_0"; "countRaw_0"; "zscoreRaw_1"; "TBI_Raw"; "TBI_Mean"; "TBI_SE"; ...
                "RS"; "peak"; "width"; "latency"; "h_ranksum"; "p_ranksum"; "h_ttest"; "p_ttest"; "h_Onset_T"; "p_Onset_T"]);
            chSpikeLfp(pIndex).chLFP = addFieldToStruct(chSpikeLfp(pIndex).chLFP, cellstr(repmat(Dates(Idx), sum(chIdx), 1)), "Date");
            popAll(pIndex).chSPK = [popAll(pIndex).chSPK; chSpikeLfp(pIndex).chSPK];
            popAll(pIndex).chLFP = [popAll(pIndex).chLFP; chSpikeLfp(pIndex).chLFP];
end