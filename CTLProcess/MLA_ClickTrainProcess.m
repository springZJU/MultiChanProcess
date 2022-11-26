function MLA_ClickTrainProcess(MATPATH, FIGPATH)
%% Parameter setting
params.processFcn = @PassiveProcess_clickTrainContinuous;
fd = 500;
temp = string(strsplit(MATPATH, "\"));
dateStr = temp(end - 1);
protStr = temp(end - 2);
DATAPATH = strcat(MATPATH, "data.mat");
FIGPATH = strcat(FIGPATH, dateStr, "\");

if exist(FIGPATH, "dir")
    return
end
[trialAll, spikeDataset, lfpDataset] = spikeLfpProcess(DATAPATH, params);

%% load click train params
[S1Duration, window, ~, stimStr] = MLA_ParseCTLParams(protStr);
lfpDataset = ECOGDownsample(lfpDataset, fd);

%% set trialAll
devType = unique([trialAll.devOrdr]);
devTemp = {trialAll.devOnset}';
[~, ordTemp] = ismember([trialAll.ordrSeq]', devType);
temp = cellfun(@(x, y) x + S1Duration(y), devTemp, num2cell(ordTemp), "UniformOutput", false);
trialAll = addFieldToStruct(trialAll, temp, "devOnset");
trialAll(1) = [];
   
%% split data
[trialsLFPRaw, ~, ~] = selectEcog(lfpDataset, trialAll, "dev onset", window); % "dev onset"; "trial onset"
trialsLFPFiltered = mECOGFilter(trialsLFPRaw, 0.1, 200);

% spike
psthPara.binsize = 10; % ms
psthPara.binstep = 4; % ms
chSelect = [spikeDataset.realCh]';

trialsLfpByCh = cell(length(devType), 1);
temp = cell(length(devType), 1);
chSpikeLfp = struct("stimStr", temp, "data", temp);
for dIndex = 1:length(devType)
    tIndex = [trialAll.devOrdr] == devType(dIndex);
    trials = trialAll(tIndex);
    trialsLFP = trialsLFPFiltered(tIndex);
    % spike
    chSpike = selectSpike(spikeDataset, trials, psthPara, "dev onset", window);

    % lfp
    chLfpMean = cell2mat(cellfun(@mean , changeCellRowNum(trialsLFP), 'UniformOutput', false));
    chStd = cell2mat(cellfun(@(x) std(x)/sqrt(length(tIndex)), changeCellRowNum(trialsLFP), 'UniformOutput', false));

    trialsLfpByCh{dIndex, 1} = changeCellRowNum(trialsLFP);
    meanLFP = mat2cell(chLfpMean(chSelect, :),  ones(length(chSelect), 1));
    stdLFP = mat2cell(chStd(chSelect, :),  ones(length(chSelect), 1));

    chSpikeLfp(dIndex).stimStr = stimStr(dIndex);
    chSpikeLfp(dIndex).spikeLfp = addFieldToStruct(chSpike, [trialsLfpByCh{dIndex, 1}(chSelect), meanLFP, stdLFP] , ["trialsLfp"; "meanLFP"; "stdLFP"]);

end

%% plot figure

mkdir(FIGPATH);
% single unit
Fig = MLA_PlotRasterLfp(chSpikeLfp, window, stimStr);
for cIndex = 1 : length(Fig)
    print(Fig(cIndex), strcat(FIGPATH, "_ch", num2str(spikeDataset(cIndex).ch)), "-djpeg", "-r300");
    close(Fig(cIndex));
end

% lfp of whole period
FigLFP = MLA_PlotLfpByCh(trialsLfpByCh, window, stimStr);
scaleAxes(FigLFP, "y", [], [-1000 300]);
print(FigLFP, strcat(FIGPATH, "LFP_ch"), "-djpeg", "-r300");

% % lfp of s1 and s2
% FigS1S2 = MLA_PlotS1S2Lfp(trialsLfpByCh, S1Duration, stimStr, window);
% scaleAxes(FigLFP, "y", [], [-1000 300]);
% print(FigS1S2, fullfile(SAVEPATH, strcat("s1s2LFP_ch")), "-djpeg", "-r300");
% 

close all;
end


