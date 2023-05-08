clc;clear;

%% load data
protSel = "TB_Oscillation_500_250_125_60_30_BF";
popResPath = "E:\MonkeyLinearArray\ProcessedData\";
DATAPATH = strcat(popResPath, protSel, "\popRes");
load(DATAPATH);
%% plot data
Idx = [1:7];
plotWin = [-100, 4000];
correspFreq = 1000./[500, 250, 125, 60, 30];

RegSigIdx = logical(popAll(1).sigIdxHigh);
RegNoSigIdx = ~RegSigIdx;
for vIndex = 1 : length(popAll)
    plotRes(vIndex).stimStr = popAll(vIndex).stimStr;
    plotRes(vIndex).sig = popAll(vIndex).chSPK(RegSigIdx);
end



for vIndex = 1 : length(popAll)
    % fr, TBI
    for neu = 1 : length(plotRes(vIndex).sig)
        toPlot(neu).CH = [plotRes(vIndex).sig(neu).Date, plotRes(vIndex).sig(neu).info];
        toPlot(neu).raster(vIndex, :) = [{plotRes(vIndex).stimStr}, {findWithinInterval(plotRes(vIndex).sig(neu).spikePlotNew, plotWin, 1)}] ;
        toPlot(neu).PSTH(vIndex,:) = [{plotRes(vIndex).stimStr}, {plotRes(vIndex).sig(neu).PSTH}];
    end
end

%% rayleigh statistics
RSWin = [repmat({[0, 8000]}, 6, 1); {[0, 4000]}; {[0, 4000]}];
rasterRS = {toPlot.raster}';
trialNum = cellfun(@(x) length(x), {plotRes(1).sig.countRaw_0}', "UniformOutput", false);
periods = [500, 250, 125, 60, 30, 1, 60, 30]';
[RS, vs] = cellfun(@(x, y) mRS(x, periods, RSWin, y), rasterRS, trialNum, "UniformOutput", false);
toPlot = addFieldToStruct(toPlot, [RS, vs], ["RS"; "vs"]);

%% psth population
temp = [toPlot.PSTH];
temp = cellfun(@(x) x(:,2), temp(:, 2:2:end), "UniformOutput", false);
psthInfo = cellstr(toPlot(1).PSTH(:, 1));
psthRaw = cellfun(@(x) cell2mat(x), num2cell(temp, 2), "UniformOutput", false);
psthMean = cellfun(@(x) mean(x, 2), psthRaw, "UniformOutput", false);
psthSE = cellfun(@(x) std(x,1,2)/sqrt(size(x, 2)), psthRaw, "UniformOutput", false);
psthPop = cell2struct([psthInfo, psthRaw, psthMean, psthSE], ["Info", "Raw", "Mean", "SE"], 2);

%% FFT
mFs = 1000/unique(diff(toPlot(1).PSTH{1,2}(:, 1)));
PSTH = {toPlot.PSTH}';
t = toPlot(1).PSTH{1,2}(:, 1);
FFT = cellfun(@(x) mFFT_PSTH(x, mFs, t, plotWin), PSTH, "UniformOutput", false);
toPlot = addFieldToStruct(toPlot, FFT, "PSTH");


%% FFT & RS population
for sIndex = 1 : length(plotRes)
    FFTPop(sIndex).stimStr = toPlot(1).PSTH(sIndex).stimStr;
    signal = cell2mat(cellfun(@(x) x(sIndex).FFT(:, 2), {toPlot.PSTH}', "UniformOutput", false)');
    FFTPop(sIndex).f = toPlot(1).PSTH(sIndex).FFT(:,1);
    FFTPop(sIndex).FFTRaw = signal;
    FFTPop(sIndex).FFT = [mean(signal, 2), std(signal, 1, 2)/sqrt(size(signal, 2))];
end

RSAll = [toPlot.RS];
sigRSIdx = find(any(RSAll(1:5, :) > 13.8, 1));
noSigRSIdx = find(~any(RSAll(1:5, :) > 13.8, 1));
RSPop.sig = [mean(RSAll(:, sigRSIdx),2), SE(RSAll(:, sigRSIdx),2)];
RSPop.noSig = [mean(RSAll(:, noSigRSIdx),2), SE(RSAll(:, noSigRSIdx),2)];

% RS pVal
for pIndex = 1 : 5
    [~, RSPVal.sig(pIndex, 1)] = ttest(RSAll(pIndex, sigRSIdx), 13.8);
    [~, RSPVal.noSig(pIndex, 1)] = ttest(RSAll(pIndex, noSigRSIdx), 13.8);
end




%% FFT pVal
trialsControl = {FFTPop(6).FFTRaw'};
for pIndex = 1 : 5
    trialsFFT = {FFTPop(pIndex).FFTRaw'};
    [tarMean, idx] = findWithinWindow(FFTPop(pIndex).FFT(:,1), FFTPop(pIndex).f, [0.95, 1.05] * correspFreq(pIndex), 2);
    [~, targetIndex] = max(tarMean, [], 1);
    targetIdx(pIndex) = mode(targetIndex) + idx(1) - 1;
    [~, fftPVal(pIndex, 1)] = waveFFTPower_pValue(trialsFFT, trialsControl, [{FFTPop(pIndex).f}, {FFTPop(pIndex).f}], targetIdx(pIndex), 2);
end

%% functions
function rez = mFFT_PSTH(data, fs, t, window)
     signal = cellfun(@(x) findWithinWindow(x(:, 2)', t, window), data(:,2), "UniformOutput", false);
     [f, ~, P] = cellfun(@(x) mFFT_Base(x, fs), signal, "UniformOutput", false);
     fftRes = cellfun(@(x, y) [x', y'], f, P, "UniformOutput", false);
     rez = cell2struct([data, fftRes], ["stimStr", "PSTH", "FFT"], 2);
end

function [RS, vs] = mRS(data, periods, RSWin, trialNum)

     signal = cellfun(@(x, y) findWithinInterval(x(:, 1), y), data(:, 2), RSWin, "UniformOutput", false);
     [RS, vs] = cellfun(@(x, y) RayleighStatistic(x, y, trialNum), signal, num2cell(periods), "uni", false);
     RS = cell2mat(RS);
     vs = cell2mat(vs);
     RS(6) = [];
     vs(6) = [];
end









