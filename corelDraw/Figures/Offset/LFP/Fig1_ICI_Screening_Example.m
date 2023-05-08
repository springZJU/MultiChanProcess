clear; clc
protocol = "Offset_2_128_4s_New";
load(strcat("E:\MonkeyLinearArray\ProcessedData\", protocol, "\popRes.mat"));
SAVEPATH = strcat(fileparts(mfilename("fullpath")), "\Figures");
CTLParams = MLA_ParseCTLParams(protocol);
parseStruct(CTLParams);
mkdir(SAVEPATH);
%% example CSD and MUA
selDate = "cm20230401";
selIdx = contains(string({popRes.Date})', selDate);
layIdx.Sg = str2double(strsplit(popRes(selIdx).Sg, ","))';
layIdx.Gr = str2double(strsplit(popRes(selIdx).Gr, ","))';
layIdx.Ig = str2double(strsplit(popRes(selIdx).Ig, ","))';
tempLFP = popRes(selIdx).rawLFP;  
tempCSD = popRes(selIdx).chCSD;  
tempMUA = popRes(selIdx).chMUA;  
sponWin = [-300, 0];
rspWin = [0, 300];
plotWin = [-50, 300];

%% LFP Wave plot
for pIndex = 1 : length(tempLFP)
    temp = tempLFP(pIndex).rawLFP;
    plotLFP(pIndex).info = tempLFP(pIndex).info;
    plotLFP(pIndex).tWave = temp.t;
    plotLFP(pIndex).Wave.Sg = [temp.t; mean(cell2mat(cellfun(@(x) mean(x(layIdx.Sg, :), 1), temp.rawWave, "UniformOutput", false)), 1)]';
    plotLFP(pIndex).Wave.Gr = [temp.t; mean(cell2mat(cellfun(@(x) mean(x(layIdx.Gr, :), 1), temp.rawWave, "UniformOutput", false)), 1)]';
    plotLFP(pIndex).Wave.Ig = [temp.t; mean(cell2mat(cellfun(@(x) mean(x(layIdx.Ig, :), 1), temp.rawWave, "UniformOutput", false)), 1)]';
end

%% LFP response strength
for pIndex = 1 : length(tempLFP)
    Window = [tempLFP(pIndex).rawLFP.t(1), tempLFP(pIndex).rawLFP.t(end)];
    temp = tempLFP(pIndex).rawLFP.rawWave;
    plotLFP(pIndex).info = tempLFP(pIndex).info;
    [~, rspRMS] = cellfun(@(x) waveAmp_Norm(x, Window, rspWin+BaseICI(pIndex)), temp, 'UniformOutput', false);
%     [~, baseRMS] = cellfun(@(x) waveAmp_Norm(x, Window, [-BaseICI(pIndex)*10, 0]), temp, 'UniformOutput', false);
%     realRMS = changeCellRowNum(cellfun(@(x, y) x-y, rspRMS, baseRMS, "UniformOutput", false));
    realRMS = changeCellRowNum(rspRMS);
    sponRMS = changeCellRowNum(cellfun(@(x) waveAmp_Norm(x, Window, sponWin-S1Duration(pIndex)), temp, 'UniformOutput', false));
    RMS.raw = realRMS;
    RMS.zscoredRaw = cellfun(@(x, y) x./y, realRMS, sponRMS, "UniformOutput", false);
    RMS.normRaw = changeCellRowNum(cellfun(@(x) x./x(1), changeCellRowNum(realRMS), "UniformOutput", false));
    RMS.mean = [cellfun(@mean, RMS.raw), cellfun(@SE, RMS.raw)];
    RMS.zscoredMean = [cellfun(@mean, RMS.zscoredRaw), cellfun(@SE, RMS.zscoredRaw)];
    RMS.normMean = [cellfun(@mean, RMS.normRaw), cellfun(@SE, RMS.normRaw)];
    % Sg
    RMS.Sg.mean(pIndex, :) = [mean(RMS.mean(layIdx.Sg)), SE(RMS.mean(layIdx.Sg))];
    RMS.Sg.zscoredMean(pIndex, :) = [mean(RMS.zscoredMean(layIdx.Sg)), SE(RMS.zscoredMean(layIdx.Sg))];
    RMS.Sg.normMean(pIndex, :) = [mean(RMS.normMean(layIdx.Sg)), SE(RMS.normMean(layIdx.Sg))];
    % Gr
    RMS.Gr.mean(pIndex, :) = [mean(RMS.mean(layIdx.Gr)), SE(RMS.mean(layIdx.Gr))];
    RMS.Gr.zscoredMean(pIndex, :) = [mean(RMS.zscoredMean(layIdx.Gr)), SE(RMS.zscoredMean(layIdx.Gr))];
    RMS.Gr.normMean(pIndex, :) = [mean(RMS.normMean(layIdx.Gr)), SE(RMS.normMean(layIdx.Gr))];
    % Ig
    RMS.Ig.mean(pIndex, :) = [mean(RMS.mean(layIdx.Ig)), SE(RMS.mean(layIdx.Ig))];
    RMS.Ig.zscoredMean(pIndex, :) = [mean(RMS.zscoredMean(layIdx.Ig)), SE(RMS.zscoredMean(layIdx.Ig))];
    RMS.Ig.normMean(pIndex, :) = [mean(RMS.normMean(layIdx.Ig)), SE(RMS.normMean(layIdx.Ig))];
    
end

% %% FFT significance
% for pIndex = 3 : length(tempLFP)
%     temp = tempLFP(pIndex).rawLFP;
%     [~, targetIdx] = min(abs(temp.f - 1000/BaseICI(pIndex)));
%     [rangeF, rangeIdx] = findWithinInterval(temp.f, [-1, 1]+1000/BaseICI(pIndex));
%     rangeIdx(rangeIdx == targetIdx) = [];
%     [p, h] = cellfun(@(x) ttest2(x(:, targetIdx), reshape(x(:, rangeIdx), [], 1)), temp.FFT, "UniformOutput", false);
% 
% 
%     plotLFP(pIndex).Wave.Sg = [temp.t; mean(cell2mat(cellfun(@(x) mean(x(layIdx.Sg, :), 1), temp.rawWave, "UniformOutput", false)), 1)]';
%     plotLFP(pIndex).Wave.Gr = [temp.t; mean(cell2mat(cellfun(@(x) mean(x(layIdx.Gr, :), 1), temp.rawWave, "UniformOutput", false)), 1)]';
%     plotLFP(pIndex).Wave.Ig = [temp.t; mean(cell2mat(cellfun(@(x) mean(x(layIdx.Ig, :), 1), temp.rawWave, "UniformOutput", false)), 1)]';
% end

