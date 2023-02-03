clc;clear;

%% load data
protSel = "TB_BaseICI_4_8_16";
popResPath = "E:\MonkeyLinearArray\ProcessedData\";
DATAPATH = strcat(popResPath, protSel, "\popRes");
load(DATAPATH);
popAll = popAll(1:2:end);
%% plot data
RegSigIdx = logical(popAll(1).sigIdxHigh);
RegNoSigIdx = ~RegSigIdx;
Idx = [3,2,1];
plotWin = [-100, 300];
for vIndex = 1 : length(popAll)
    plotRes(vIndex).stimStr = popAll(vIndex).stimStr;
    plotRes(vIndex).sig = popAll(vIndex).chSPK(RegSigIdx);
    plotRes(vIndex).noSig = popAll(vIndex).chSPK(RegNoSigIdx);
end

for vIndex = 1 : length(popAll)
    % fr, TBI
    for neu = 1 : length(plotRes(vIndex).sig)
        toPlot(neu).CH = [plotRes(vIndex).sig(neu).Date, plotRes(vIndex).sig(neu).info];
        toPlot(neu).frPlot(vIndex, :) = [plotRes(Idx(vIndex)).sig(neu).frMean_1, plotRes(Idx(vIndex)).sig(neu).frSE_1];
        toPlot(neu).TBIPlot(vIndex, :) = plotRes(Idx(vIndex)).sig(neu).TBI_Mean;
        toPlot(neu).latency(vIndex, :) = plotRes(Idx(vIndex)).sig(neu).latency;
        toPlot(neu).peak(vIndex, :) = plotRes(Idx(vIndex)).sig(neu).peak;
        toPlot(neu).width(vIndex, :) = plotRes(Idx(vIndex)).sig(neu).width;
        toPlot(neu).raster(vIndex, :) = [{plotRes(vIndex).stimStr}, {findWithinInterval(plotRes(vIndex).sig(neu).spikePlotNew, plotWin, 1)}] ;
        toPlot(neu).PSTH(vIndex,:) = [{plotRes(vIndex).stimStr}, {plotRes(vIndex).sig(neu).PSTH}];
    
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
% firing rate
frRaw = [toPlot.frPlot];
frNormRaw = frRaw(:, 1:2:end);
frNormRaw = frNormRaw./frNormRaw(end, :);
frPop = [mean(frRaw(:, 1:2:end),2), std(frRaw(:, 1:2:end),1, 2)/sqrt(length(toPlot))];
frNormPop = [mean(frNormRaw(:, 1:2:end),2), std(frNormRaw(:, 1:2:end),1, 2)/sqrt(length(toPlot))];
% latency
latencyRaw = [toPlot.latency];
latencyPop = [mean(latencyRaw,2), std(latencyRaw,1, 2)/sqrt(length(toPlot))];
% peak
peakRaw = [toPlot.peak];

peakNormRaw = peakRaw./peakRaw(end,:);
peakPop = [mean(peakRaw,2), std(peakRaw,1, 2)/sqrt(length(toPlot))];
peakNormPop = [mean(peakNormRaw,2), std(peakNormRaw,1, 2)/sqrt(length(toPlot))];


%% polyfit
x = [4,8,16]/1000';
% firing rate regression
[slope, intercept, R2, R2Adj, p] = cellfun(@(y) mFitlm(x,y), num2cell(frNormRaw, 1), "UniformOutput", false);
regressionRez.firingRate = cell2struct([slope', intercept', R2', R2Adj', p'], ["slope", "intercept", "R2", "R2Adj", "p"], 2);
regressPlot.firingRate(1).info = "Sig";
regressPlot.firingRate(1).data = regressionRez.firingRate([regressionRez.firingRate.R2Adj] > 0.5);
regressPlot.firingRate(1).mean = mean([regressPlot.firingRate(1).data.slope]');
regressPlot.firingRate(2).info = "noSig";
regressPlot.firingRate(2).data = regressionRez.firingRate(~([regressionRez.firingRate.R2Adj] > 0.5));
regressPlot.firingRate(2).mean = mean([regressPlot.firingRate(2).data.slope]');
% latency regression
[slope, intercept, R2, R2Adj, p] = cellfun(@(y) mFitlm(x,y), num2cell(latencyRaw/1000, 1), "UniformOutput", false);
regressionRez.latency = cell2struct([slope', intercept', R2', R2Adj', p'], ["slope", "intercept", "R2", "R2Adj", "p"], 2);
regressPlot.latency(1).info = "Sig";
regressPlot.latency(1).data = regressionRez.latency([regressionRez.latency.R2Adj] > 0.5);
regressPlot.latency(1).mean = mean([regressPlot.latency(1).data.slope]');
regressPlot.latency(2).info = "noSig";
regressPlot.latency(2).data = regressionRez.latency(~([regressionRez.latency.R2Adj] > 0.5));
regressPlot.latency(2).mean = mean([regressPlot.latency(2).data.slope]');
% peak regression
[slope, intercept, R2, R2Adj, p] = cellfun(@(y) mFitlm(x,y), num2cell(peakNormRaw, 1), "UniformOutput", false);
regressionRez.peak = cell2struct([slope', intercept', R2', R2Adj', p'], ["slope", "intercept", "R2", "R2Adj", "p"], 2);
regressPlot.peak(1).info = "Sig";
regressPlot.peak(1).data = regressionRez.peak([regressionRez.peak.R2Adj] > 0.5);
regressPlot.peak(1).mean = mean([regressPlot.peak(1).data.slope]');
regressPlot.peak(2).info = "noSig";
regressPlot.peak(2).data = regressionRez.peak(~([regressionRez.peak.R2Adj] > 0.5));
regressPlot.peak(2).mean = mean([regressPlot.peak(2).data.slope]');







