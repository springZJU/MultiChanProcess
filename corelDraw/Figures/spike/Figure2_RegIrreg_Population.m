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
temp = zscore(vertcat([plotRes(3).data.frMean_1]', [plotRes(7).data.frMean_1]'));
zscoreRez.RegIrreg = [temp(1:length(temp)/2), temp(length(temp)/2+1:end)];
temp = zscore(vertcat([plotRes(3).data.frMean_1]', [plotRes(3).data.frMean_0]'));
zscoreRez.FR1FR0 = [temp(1:length(temp)/2), temp(length(temp)/2+1:end)];

%% TBI & RPI
Indexs.TBI = ([plotRes(3).data.frMean_1]' - [plotRes(3).data.frMean_0]')./[plotRes(3).data.frMean_0]';
Indexs.TBIMean = mean(Indexs.TBI);
Indexs.TBIMedian = median(Indexs.TBI);

Indexs.RPI = ([plotRes(3).data.frMean_1]' - [plotRes(7).data.frMean_1]')./([plotRes(3).data.frMean_1]' + [plotRes(7).data.frMean_1]');
Indexs.RPIMean = mean(Indexs.RPI);
Indexs.RPIMedian = median(Indexs.RPI);