 clear; clc
protocol = "Offset_Variance_Effect_4ms_16ms_sigma250_2_500msReg";
load(strcat("E:\MonkeyLinearArray\ProcessedData\", protocol, "\popRes.mat"));
SAVEPATH = strcat(fileparts(mfilename("fullpath")), "\Figures");
CTLParams = MLA_ParseCTLParams(protocol);
parseStruct(CTLParams);
mkdir(SAVEPATH);
%% integrate different days


for dIndex = 1 : length(popRes)

    if popRes(dIndex).IsA1 ~= 1
        continue
    end
layIdx.Sg = str2double(strsplit(popRes(dIndex).Sg, ","))';
layIdx.Gr = str2double(strsplit(popRes(dIndex).Gr, ","))';
layIdx.Ig = str2double(strsplit(popRes(dIndex).Ig, ","))';
tempLFP = popRes(dIndex).rawLFP;  
sponWin = [-300, 0];
rspWin = [0, 300];
plotWin = [-50, 300];


%% LFP response strength
for pIndex = 1 : length(tempLFP)
    Window = [tempLFP(pIndex).rawLFP.t(1), tempLFP(pIndex).rawLFP.t(end)];
    temp = tempLFP(pIndex).rawLFP.rawWave;
    [~, rspRMS] = cellfun(@(x) waveAmp_Norm(x, Window, rspWin+BaseICI(pIndex)), temp, 'UniformOutput', false);
%     [~, baseRMS] = cellfun(@(x) waveAmp_Norm(x, Window, [-BaseICI(pIndex)*10, 0]), temp, 'UniformOutput', false);
%     realRMS = changeCellRowNum(cellfun(@(x, y) x-y, rspRMS, baseRMS, "UniformOutput", false));
    realRMS = changeCellRowNum(rspRMS);
    sponRMS = changeCellRowNum(cellfun(@(x) waveAmp_Norm(x, Window, sponWin-S1Duration(pIndex)), temp, 'UniformOutput', false));
    RMS(dIndex).date = popRes(dIndex).Date;
    RMS(dIndex).SgSel = layIdx.Sg;
    RMS(dIndex).GrSel = layIdx.Gr;
    RMS(dIndex).IgSel = layIdx.Ig;
    RMS(dIndex).raw = realRMS;
    RMS(dIndex).zscoredRaw = cellfun(@(x, y) x./y, realRMS, sponRMS, "UniformOutput", false);
    [RMS(dIndex).zscoreH, RMS(dIndex).zscoreP] = cellfun(@(x) ttest(x, 1), RMS(dIndex).zscoredRaw, "UniformOutput", false);
    RMS(dIndex).normRaw = changeCellRowNum(cellfun(@(x) x./x(1), changeCellRowNum(realRMS), "UniformOutput", false));
    RMS(dIndex).mean = [cellfun(@mean, RMS(dIndex).raw), cellfun(@SE, RMS(dIndex).raw)];
    RMS(dIndex).zscoredMean = [cellfun(@mean, RMS(dIndex).zscoredRaw), cellfun(@SE, RMS(dIndex).zscoredRaw)];
    
    RMS(dIndex).normMean = [cellfun(@mean, RMS(dIndex).normRaw), cellfun(@SE, RMS(dIndex).normRaw)];
    % Sg
    RMS(dIndex).Sg.mean(pIndex, :) = [mean(RMS(dIndex).mean(layIdx.Sg, 1)), SE(RMS(dIndex).mean(layIdx.Sg, 1))];
    RMS(dIndex).Sg.zscoredMean(pIndex, :) = [mean(RMS(dIndex).zscoredMean(layIdx.Sg, 1)), SE(RMS(dIndex).zscoredMean(layIdx.Sg, 1))];
    RMS(dIndex).Sg.normMean(pIndex, :) = [mean(RMS(dIndex).normMean(layIdx.Sg, 1)), SE(RMS(dIndex).normMean(layIdx.Sg, 1))];
    RMS(dIndex).Sg.zscoreH(pIndex, :) = cell2mat(RMS(dIndex).zscoreH(layIdx.Sg));
    RMS(dIndex).Sg.zscoreP(pIndex, :) = cell2mat(RMS(dIndex).zscoreP(layIdx.Sg));
    % Gr
    RMS(dIndex).Gr.mean(pIndex, :) = [mean(RMS(dIndex).mean(layIdx.Gr, 1)), SE(RMS(dIndex).mean(layIdx.Gr, 1))];
    RMS(dIndex).Gr.zscoredMean(pIndex, :) = [mean(RMS(dIndex).zscoredMean(layIdx.Gr, 1)), SE(RMS(dIndex).zscoredMean(layIdx.Gr, 1))];
    RMS(dIndex).Gr.normMean(pIndex, :) = [mean(RMS(dIndex).normMean(layIdx.Gr, 1)), SE(RMS(dIndex).normMean(layIdx.Gr, 1))];
    RMS(dIndex).Gr.zscoreH(pIndex, :) = cell2mat(RMS(dIndex).zscoreH(layIdx.Gr));
    RMS(dIndex).Gr.zscoreP(pIndex, :) = cell2mat(RMS(dIndex).zscoreP(layIdx.Gr));
    % Ig
    RMS(dIndex).Ig.mean(pIndex, :) = [mean(RMS(dIndex).mean(layIdx.Ig, 1)), SE(RMS(dIndex).mean(layIdx.Ig, 1))];
    RMS(dIndex).Ig.zscoredMean(pIndex, :) = [mean(RMS(dIndex).zscoredMean(layIdx.Ig, 1)), SE(RMS(dIndex).zscoredMean(layIdx.Ig, 1))];
    RMS(dIndex).Ig.normMean(pIndex, :) = [mean(RMS(dIndex).normMean(layIdx.Ig, 1)), SE(RMS(dIndex).normMean(layIdx.Ig, 1))];
    RMS(dIndex).Ig.zscoreH(pIndex, :) = cell2mat(RMS(dIndex).zscoreH(layIdx.Ig));
    RMS(dIndex).Ig.zscoreP(pIndex, :) = cell2mat(RMS(dIndex).zscoreP(layIdx.Ig));
end

end

%%
RMS(isemptycell({RMS.date}')) = [];
for rIndex = 1 : length(RMS)
[~, RMS(rIndex).Sg.maxICI] = max(RMS(rIndex).Sg.mean([6,8,10], 1));
[~, RMS(rIndex).Sg.zscoredMaxICI] = max(RMS(rIndex).Sg.zscoredMean([6,8,10], 1));
[~, RMS(rIndex).Gr.maxICI] = max(RMS(rIndex).Gr.mean([6,8,10], 1));
[~, RMS(rIndex).Gr.zscoredMaxICI] = max(RMS(rIndex).Gr.zscoredMean([6,8,10], 1));
[~, RMS(rIndex).Ig.maxICI] = max(RMS(rIndex).Ig.mean([6,8,10], 1));
[~, RMS(rIndex).Ig.zscoredMaxICI] = max(RMS(rIndex).Ig.zscoredMean([6,8,10], 1));
end


%% population RMS
layerStr = ["Sg", "Gr", "Ig"];
for lIndex = 1:length(layerStr)
temp = cell2mat(cellfun(@(x) x.mean(:, 1), {RMS.(layerStr(lIndex))}', "UniformOutput", false)');
RMSPop.(layerStr(lIndex)).mean = [mean(temp, 2), SE(temp, 2)];
temp = cell2mat(cellfun(@(x) x.zscoredMean(:, 1), {RMS.(layerStr(lIndex))}', "UniformOutput", false)');
RMSPop.(layerStr(lIndex)).zscoredMean = [mean(temp, 2), SE(temp, 2)];
RMSPop.(layerStr(lIndex)).maxICI = cell2mat(cellfun(@(x) x.maxICI(:, 1), {RMS.(layerStr(lIndex))}, "UniformOutput", false)');
RMSPop.(layerStr(lIndex)).maxICIRatio = tabulate(RMSPop.(layerStr(lIndex)).maxICI);
RMSPop.(layerStr(lIndex)).zscoredMaxICI = cell2mat(cellfun(@(x) x.zscoredMaxICI(:, 1), {RMS.(layerStr(lIndex))}, "UniformOutput", false)');
RMSPop.(layerStr(lIndex)).zscoredMaxICIRatio = tabulate(RMSPop.(layerStr(lIndex)).zscoredMaxICI);
temp = cell2mat(cellfun(@(x) x.zscoreH, {RMS.(layerStr(lIndex))}', "UniformOutput", false)');
RMSPop.(layerStr(lIndex)).zscoreH = temp;
RMSPop.(layerStr(lIndex)).z_H_Ratio = sum(temp, 2)./size(temp, 2);
temp = cellfun(@(x) find(x(1:end-2)==1, 1, "last"), num2cell(temp, 1), "UniformOutput", false);
temp(cellfun(@isempty, temp)) = [];
RMSPop.(layerStr(lIndex)).z_H_Thr = tabulate(cell2mat(temp));

end


