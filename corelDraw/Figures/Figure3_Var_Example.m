clc;clear;
%% get Reg4-4.06 sigIdx
BasicPATH = strcat(fileparts(fileparts(mfilename("fullpath"))), "\DATA\TB_Basic_4_4.06_Contol_Tone\popRes");
load(BasicPATH, "-mat", "popAll");
basicData = popAll;

%% load data
protSel = "TB_Var_400_200_100_50_Reg";
DATAPATH = strcat(fileparts(fileparts(mfilename("fullpath"))), "\DATA\", protSel, "\popRes");
load(DATAPATH);

%% plot data
RegSigIdx = logical(popAll(5).sigIdxHigh);
RegNoSigIdx = ~RegSigIdx;
Idx = [4,3,2,1,5];
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
        toPlot(neu).latency(vIndex, :) = plotRes(Idx(vIndex)).sig(neu).latency;
        toPlot(neu).peak(vIndex, :) = plotRes(Idx(vIndex)).sig(neu).peak;
        toPlot(neu).width(vIndex, :) = plotRes(Idx(vIndex)).sig(neu).width;
        toPlot(neu).TBIPlot(vIndex, :) = plotRes(Idx(vIndex)).sig(neu).TBI_Mean;
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
frNormRaw = frRaw;
frNormRaw(:, 1:2:end) = frRaw(:, 1:2:end)./frRaw(5, 1:2:end);
frPop = [mean(frRaw(:, 1:2:end),2), std(frRaw(:, 1:2:end),1, 2)/sqrt(length(toPlot))];
frNormPop = [mean(frNormRaw(:, 1:2:end),2), std(frNormRaw(:, 1:2:end),1, 2)/sqrt(length(toPlot))];
% latency
latencyRaw = [toPlot.latency];
latencyPop = [mean(latencyRaw(:, 1:2:end),2), std(latencyRaw(:, 1:2:end),1, 2)/sqrt(length(toPlot))];
% peak
peakRaw = [toPlot.peak];
peakPop = [mean(peakRaw(:, 1:2:end),2), std(peakRaw(:, 1:2:end),1, 2)/sqrt(length(toPlot))];

%% regression
alpha = 0.05;
x = [1/50, 1/100, 1/200, 1/400, 0]';
[slope, intercept, slopeInt, interceptInt, r, p] = cellfun(@(y) regress_perp(x,y,alpha,1), num2cell(frRaw(:, 1:2:end), 1), "UniformOutput", false);
