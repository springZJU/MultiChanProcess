
if strcmpi(protSel, "Offset_2_128_4s_New")
    plotWin = [-4500, 1000];
    if ~exist("SameDur_DiffICI", "var")
        popAll = popAll(1:end-1);
    end
elseif strcmpi(protSel, "Offset_Duration_Effect_4ms_Reg_New")
    Idx = 1:11;
    plotWin = [-1000, 2000];
    if ~exist("Noise_Click_Compare", "var")
        popAll = popAll([1:8, 11]);
    end

elseif strcmpi(protSel, "Offset_Duration_Effect_16ms_Reg_New")
    Idx = 1:9;
    plotWin = [-1000, 2000];
    popAll = popAll(1:7);
elseif strcmpi(protSel, "Offset_Variance_Effect_4ms_16ms_sigma250_2_500msReg")
    Idx = 1:10;
    plotWin = [-1000, 1000];
end
for vIndex = 1 : length(popAll)
    plotRes(vIndex).stimStr = popAll(vIndex).stimStr;
    plotRes(vIndex).sig = popAll(vIndex).chSPK(RegSigIdx);
    plotRes(vIndex).noSig = popAll(vIndex).chSPK(RegNoSigIdx);
end

for pIndex = 1 : length(plotRes)
    sigRatio.ttest(pIndex, 1) = sum([plotRes(pIndex).sig.h_ttest]);
    sigRatio.ttest(pIndex, 2) = sum([plotRes(pIndex).sig.h_ttest])/length([plotRes(pIndex).sig.h_ttest]);
    sigRatio.date(pIndex).ttest = {plotRes(pIndex).sig([plotRes(pIndex).sig.h_ttest]' == 1).CH}';
    sigRatio.ranksum(pIndex, 1) = sum([plotRes(pIndex).sig.h_ranksum])/length([plotRes(pIndex).sig.h_ranksum]);
    sigRatio.ranksum(pIndex, 2) = sum([plotRes(pIndex).sig.h_ranksum]);
    sigRatio.date(pIndex).ranksum = {plotRes(pIndex).sig([plotRes(pIndex).sig.h_ranksum]' == 1).CH}';
end

for vIndex = 1 : length(popAll)
    % fr, TBI
    for neu = 1 : length(plotRes(vIndex).sig)
        toPlot(neu).CH = [plotRes(vIndex).sig(neu).Date, plotRes(vIndex).sig(neu).info];
        toPlot(neu).frPlot(vIndex, :) = [plotRes(Idx(vIndex)).sig(neu).frMean_1, plotRes(Idx(vIndex)).sig(neu).frSE_1];
        toPlot(neu).RS(vIndex, :) = plotRes(Idx(vIndex)).sig(neu).RS;
        toPlot(neu).latency(vIndex, :) = plotRes(Idx(vIndex)).sig(neu).latency;
        toPlot(neu).peak(vIndex, :) = plotRes(Idx(vIndex)).sig(neu).peak;
        toPlot(neu).width(vIndex, :) = plotRes(Idx(vIndex)).sig(neu).width;
        toPlot(neu).raster(vIndex, :) = [{plotRes(Idx(vIndex)).stimStr}, {findWithinInterval(plotRes(Idx(vIndex)).sig(neu).spikePlotNew, plotWin)}] ;
        toPlot(neu).PSTH(vIndex,:) = [{plotRes(Idx(vIndex)).stimStr}, {plotRes(Idx(vIndex)).sig(neu).PSTH}];
        toPlot(neu).AUC(vIndex,:) = auc_analysis(plotRes(Idx(vIndex)).sig(neu).countRaw_1, plotRes(Idx(vIndex)).sig(neu).countRaw_0);
    end
end

%% population
temp = [toPlot.PSTH];
temp = cellfun(@(x) x(:,2), temp(:, 2:2:end), "UniformOutput", false);
psthInfo = cellstr(toPlot(1).PSTH(:, 1));
psthRaw = cellfun(@(x) cell2mat(x), num2cell(temp, 2), "UniformOutput", false);
psthMean = cellfun(@(x) mean(x, 2), psthRaw, "UniformOutput", false);
psthSE = cellfun(@(x) std(x,1,2)/sqrt(size(x, 2)), psthRaw, "UniformOutput", false);
psthPop = cell2struct([psthInfo, psthRaw, psthMean, psthSE], ["Info", "Raw", "Mean", "SE"], 2);

%% RS
RSRaw = [toPlot.RS];
RSPop.all = [mean(RSRaw,2), std(RSRaw,1, 2)/sqrt(length(toPlot))];
syncIdx = find(any((RSRaw > 13.8),1));
nonSyncIdx = find(~any((RSRaw > 13.8),1));
RSPop.sync = [mean(RSRaw(:, syncIdx),2), std(RSRaw(:, syncIdx),1, 2)/sqrt(length(syncIdx))];
RSPop.nonSync = [mean(RSRaw(:, nonSyncIdx),2), std(RSRaw(:, nonSyncIdx),1, 2)/sqrt(length(nonSyncIdx))];
[maxRS.all(:, 2), maxRS.all(:, 1)] = max(RSRaw, [], 1);
maxRS.sync = maxRS.all(syncIdx, :);
maxRS.nonSync = maxRS.all(nonSyncIdx, :);
RSMax.all = tabulate(maxRS.all(:, 1));
RSMax.sync = tabulate(maxRS.sync(:, 1));
RSMax.nonSync = tabulate(maxRS.nonSync(:, 1));



%% firing rate
frRaw = [toPlot.frPlot];
frRawMean = frRaw(:, 1:2:end);
frPop.all = [mean(frRawMean,2), std(frRawMean,1, 2)/sqrt(length(toPlot))];
frPop.sync = [mean(frRawMean(:, syncIdx),2), std(frRawMean(:, syncIdx),1, 2)/sqrt(length(syncIdx))];
frPop.nonSync = [mean(frRawMean(:, nonSyncIdx),2), std(frRawMean(:, nonSyncIdx),1, 2)/sqrt(length(nonSyncIdx))];
[maxFR.all(:, 2), maxFR.all(:, 1)] = max(frRawMean, [], 1);
maxFR.sync = maxFR.all(syncIdx, :);
maxFR.nonSync = maxFR.all(nonSyncIdx, :);

FRMax.all = tabulate(maxFR.all(:, 1));
FRMax.sync = tabulate(maxFR.sync(:, 1));
FRMax.nonSync = tabulate(maxFR.nonSync(:, 1));

%% latency
latencyRaw = [toPlot.latency];
latencyPop = [mean(latencyRaw,2), std(latencyRaw,1, 2)/sqrt(length(toPlot))];
% peak
peakRaw = [toPlot.peak];
peakNormRaw = peakRaw./peakRaw(end,:);
peakPop = [mean(peakRaw,2), std(peakRaw,1, 2)/sqrt(length(toPlot))];
peakNormPop = [mean(peakNormRaw,2), std(peakNormRaw,1, 2)/sqrt(length(toPlot))];

%% AUC
AUCRaw = [toPlot.AUC];
AUCPop = [mean(AUCRaw,2), std(AUCRaw,1, 2)/sqrt(length(toPlot))];

%% sig ratio
sigRatio = cellfun(@(x) sum(x&popAll(1).sigOnsetIdx)*100/sum(popAll(1).sigOnsetIdx), {popAll.sigIdxHigh}', "UniformOutput", false);
temp = [popAll.sigIdxHigh]';
% temp = temp(:, popAll(1).sigOnsetIdx);
offsetThr = cell2mat(cellfun(@(x) min([find(x, 1, "last"), 10]), num2cell(temp, 1), "UniformOutput", false))';
offsetNaN = offsetThr(offsetThr == 10);
offsetOK = offsetThr(offsetThr < 10);
offsetNANIdx = offsetThr == 10;