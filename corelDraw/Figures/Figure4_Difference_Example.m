clc;clear;
%% get Reg4-4.06 sigIdx
BasicPATH = strcat(fileparts(fileparts(mfilename("fullpath"))), "\DATA\TB_Basic_4_4.06_Contol_Tone\popRes");
load(BasicPATH, "-mat", "popAll");
basicData = popAll;

%% load data
protSel = "TB_Ratio_4_4.04";
DATAPATH = strcat(fileparts(fileparts(mfilename("fullpath"))), "\DATA\", protSel, "\popRes");
load(DATAPATH);

%% plot data
RegSigIdx = logical(basicData(1).sigIdx);
RegNoSigIdx = ~RegSigIdx;
Idx = [1,2,3,4,5];
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
        toPlot(neu).raster(vIndex, :) = [{plotRes(vIndex).stimStr}, {findWithinInterval(plotRes(vIndex).sig(neu).spikePlot, plotWin, 1)}] ;
        toPlot(neu).PSTH(vIndex,:) = [{plotRes(vIndex).stimStr}, {plotRes(vIndex).sig(neu).PSTH}];
    end
end





