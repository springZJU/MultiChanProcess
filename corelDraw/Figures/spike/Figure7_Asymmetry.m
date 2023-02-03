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
% ICI increase prefering Index
ICI_IncFR = [popAll(1).chSPK.frMean_1]';
ICI_DecFR = [popAll(2).chSPK.frMean_1]';
IIPI = (ICI_IncFR-ICI_DecFR)./(ICI_IncFR+ICI_DecFR);
% ICI increase sensitive Index
ICI_IncLTNC = 200 - [popAll(1).chSPK.latency]';
ICI_DecLTNC = 200 - [popAll(2).chSPK.latency]';
IISI = (ICI_IncLTNC-ICI_DecLTNC)./(ICI_IncLTNC+ICI_DecLTNC);
IISI(isnan(IISI)) = 0;


plotWin = [-2200, 1000];
for vIndex = 1 : length(popAll)
    plotRes(vIndex).stimStr = popAll(vIndex).stimStr;
    plotRes(vIndex).raw = popAll(vIndex).chSPK;
    plotRes(vIndex).sig = popAll(vIndex).sigSPK;
    plotRes(vIndex).sigInc = popAll(vIndex).sigSPKHigh;
    plotRes(vIndex).sigDec = popAll(vIndex).sigSPKLow;
    plotRes(vIndex).noSig = popAll(vIndex).noSigSPK;
end

    for neu = 1 : length(plotRes(vIndex).raw)
        for vIndex = 1 : length(popAll)
        toPlot.Raw(neu).CH = [plotRes(vIndex).raw(neu).Date, plotRes(vIndex).raw(neu).info];
        toPlot.Raw(neu).frPlot(vIndex, :) = plotRes(vIndex).raw(neu).frMean_1;
        toPlot.Raw(neu).TBIPlot(vIndex, :) = plotRes(vIndex).raw(neu).TBI_Mean;
        toPlot.Raw(neu).latency(vIndex, :) = plotRes(vIndex).raw(neu).latency;
        toPlot.Raw(neu).peak(vIndex, :) = plotRes(vIndex).raw(neu).peak;
        toPlot.Raw(neu).width(vIndex, :) = plotRes(vIndex).raw(neu).width;
        toPlot.Raw(neu).raster(vIndex, :) = [{plotRes(vIndex).stimStr}, {findWithinInterval(plotRes(vIndex).raw(neu).spikePlotNew, plotWin, 1)}] ;
        toPlot.Raw(neu).PSTH(vIndex,:) = [{plotRes(vIndex).stimStr}, {plotRes(vIndex).raw(neu).PSTH}];
        end
        toPlot.Raw(neu).IIPI = IIPI(neu);
        toPlot.Raw(neu).IISI = IISI(neu);
    end

ICI_Inc_sigIdx = popAll(1).sigIdx;
ICI_Dec_sigIdx = popAll(2).sigIdx;
noSigIdx = (~ICI_Inc_sigIdx) & (~ICI_Dec_sigIdx);
toPlot.ICI_Inc_Sig = toPlot.Raw(ICI_Inc_sigIdx);
toPlot.ICI_Dec_Sig = toPlot.Raw(ICI_Dec_sigIdx);
toPlot.noSig = toPlot.Raw(noSigIdx);

%% asymmetry
% sig in Inc and noSig in Dec
[~, IncIdx] = setdiff({toPlot.ICI_Inc_Sig.CH}', {toPlot.ICI_Dec_Sig.CH}');
toPlot.ICI_Inc_SigOnly = toPlot.ICI_Inc_Sig(IncIdx);

% sig in Dec and noSig in Inc
[~, DecIdx] = setdiff({toPlot.ICI_Dec_Sig.CH}', {toPlot.ICI_Inc_Sig.CH}');
toPlot.ICI_Dec_SigOnly = toPlot.ICI_Dec_Sig(DecIdx);

% sig in both Inc and Dec
[~, BothIdx] = intersect({toPlot.ICI_Inc_Sig.CH}', {toPlot.ICI_Dec_Sig.CH}');
toPlot.ICI_Both_Sig = toPlot.ICI_Inc_Sig(BothIdx);

%% for coreldraw

% firing rate
plotFR(1).noSig = [toPlot.noSig.frPlot]';
plotFR.IncSig = [toPlot.ICI_Inc_SigOnly.frPlot]';
plotFR.DecSig = [toPlot.ICI_Dec_SigOnly.frPlot]';
plotFR.BothSig = [toPlot.ICI_Both_Sig.frPlot]';
% latency
plotLatency.noSig = [toPlot.noSig.latency]';
plotLatency.IncSig = [toPlot.ICI_Inc_SigOnly.latency]';
plotLatency.DecSig = [toPlot.ICI_Dec_SigOnly.latency]';
plotLatency.BothSig = [toPlot.ICI_Both_Sig.latency]';
% mean IIPI&IISI
sigStr = ["noSig", "IncSig", "DevSig", "BothSig"];
fieldStr = ["noSig", "ICI_Inc_SigOnly", "ICI_Dec_SigOnly", "ICI_Both_Sig"];
for idx = 1 : length(sigStr)
plotII.IIPI(idx).info = sigStr(idx);
plotII.IIPI(idx).data = [toPlot.(fieldStr(idx)).IIPI]';
plotII.IIPI(idx).mean = mean(plotII.IIPI(idx).data);

plotII.IISI(idx).info = sigStr(idx);
plotII.IISI(idx).data = [toPlot.(fieldStr(idx)).IISI]';
plotII.IISI(idx).mean = mean(plotII.IISI(idx).data);
end


