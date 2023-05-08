clc;clear;
protSel = "TB_Basic_4_4.06_Contol_Tone";
popResPath = "E:\MonkeyLinearArray\ProcessedData\";
DATAPATH = strcat(popResPath, protSel, "\popRes");
load(DATAPATH);

%% compute latency


%% distribution
%reg4-4.06
RegSigIdx = logical(popAll(1).sigIdx);
RegSigIdxHigh = logical(popAll(1).sigIdxHigh);
RegSigIdxLow = logical(popAll(1).sigIdxLow);
RegNoSigIdx = ~RegSigIdx;

infoPool = ["Reg1PopSig", "Reg1PopLowSig", "Reg1PopHighSig", "Reg1PopNoSig", "Irreg1PopSig", "Irreg1PopLowSig", "Irreg1PopHighSig", "Irreg1PopNoSig"]';
pIndex = [1, 1, 1, 1, 3, 3, 3, 3]';
idxPool = [{RegSigIdx}, {RegSigIdxLow}, {RegSigIdxHigh}, {RegNoSigIdx}, {RegSigIdx}, {RegSigIdxLow}, {RegSigIdxHigh}, {RegNoSigIdx}]';

pwlField = ["latency", "peak", "width"];
for i = 1 : length(infoPool)
    plotRes(i).info = infoPool(i);
    plotRes(i).data = popAll(pIndex(i)).chSPK(idxPool{i, 1});
    for pwlIdx = 1 : length(pwlField)
        plotRes(i).pwl(3*pwlIdx-2).info = strcat(pwlField(pwlIdx), "Mean");
        plotRes(i).pwl(3*pwlIdx-2).data = mean([plotRes(i).data.(pwlField(pwlIdx))]');
        plotRes(i).pwl(3*pwlIdx-1).info = strcat(pwlField(pwlIdx), "Median");
        plotRes(i).pwl(3*pwlIdx-1).data = median([plotRes(i).data.(pwlField(pwlIdx))]');
        plotRes(i).pwl(3*pwlIdx).info = strcat(pwlField(pwlIdx), "Raw");
        plotRes(i).pwl(3*pwlIdx).data = [plotRes(i).data.(pwlField(pwlIdx))]';
    end
end

%% zscore
temp = zscore(vertcat(plotRes(1).data(46).countRaw_1, plotRes(5).data(46).countRaw_1)); % 20221227CH6
zscoreRez.RegIrreg = [temp(1:length(temp)/2), temp(length(temp)/2+1:end)];
temp = zscore(vertcat(plotRes(1).data(46).countRaw_1, plotRes(1).data(46).countRaw_0)); % 20221227CH6
zscoreRez.FR1FR0 = [temp(1:length(temp)/2), temp(length(temp)/2+1:end)];

%% TBI & RPI
Indexs.TBISig.Data = ([plotRes(1).data.frMean_1]' - [plotRes(1).data.frMean_0]')./[plotRes(1).data.frMean_0]';
Indexs.TBISig.Data(isinf(Indexs.TBISig.Data)) = 0;
Indexs.TBISig.Mean = mean(Indexs.TBISig.Data);
Indexs.TBISig.Median = median(Indexs.TBISig.Data);

Indexs.TBINoSig.Data = ([plotRes(4).data.frMean_1]' - [plotRes(4).data.frMean_0]')./[plotRes(4).data.frMean_0]';
Indexs.TBINoSig.Data(isinf(Indexs.TBINoSig.Data)) = 0;
Indexs.TBINoSig.Mean = mean(Indexs.TBINoSig.Data);
Indexs.TBINoSig.Median = median(Indexs.TBINoSig.Data);

[~, Indexs.ttetTBI] = ttest2(Indexs.TBISig.Data, Indexs.TBINoSig.Data);

Indexs.RPISig.Data = ([plotRes(1).data.frMean_1]' - [plotRes(5).data.frMean_1]')./([plotRes(1).data.frMean_1]' + [plotRes(5).data.frMean_1]');
Indexs.RPISig.Data(isinf(Indexs.RPISig.Data)) = 0;
Indexs.RPISig.Mean = mean(Indexs.RPISig.Data);
Indexs.RPISig.Median = median(Indexs.RPISig.Data);

Indexs.RPINoSig.Data = ([plotRes(4).data.frMean_1]' - [plotRes(8).data.frMean_1]')./([plotRes(4).data.frMean_1]' + [plotRes(8).data.frMean_1]');
Indexs.RPINoSig.Data(isinf(Indexs.RPINoSig.Data)) = 0;
Indexs.RPINoSig.Mean = mean(Indexs.RPINoSig.Data);
Indexs.RPINoSig.Median = median(Indexs.RPINoSig.Data);
[~, Indexs.ttetRPI] = ttest2(Indexs.RPISig.Data, Indexs.RPINoSig.Data);