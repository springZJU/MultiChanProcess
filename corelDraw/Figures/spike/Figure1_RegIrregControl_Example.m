clc;clear;
%% get Reg4-4.06 sigIdx
popResPath = "E:\MonkeyLinearArray\ProcessedData\";
BasicPATH = strcat(popResPath, "TB_Basic_4_4.06_Contol_Tone\popRes");
load(BasicPATH, "-mat", "popAll");
basicData = popAll;

%% load data
protSel = "TB_Basic_4_4.06_Contol_Tone";
DATAPATH = strcat(popResPath, protSel, "\popRes");
load(DATAPATH);

%% plot data
RegSigIdx = logical(basicData(1).sigIdx);
RegNoSigIdx = ~RegSigIdx;

plotWin = [-2200, 1000];
for vIndex = 1 : length(popAll)
    plotRes(vIndex).stimStr = popAll(vIndex).stimStr;
    plotRes(vIndex).sig = popAll(vIndex).chSPK(RegSigIdx);
    plotRes(vIndex).noSig = popAll(vIndex).chSPK(RegNoSigIdx);
end
Idx = [1,3,5,7,2,4,6,8];
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





