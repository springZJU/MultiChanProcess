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
CTLParams = MLA_ParseCTLParams(protStr);
CTLFields = string(fields(CTLParams));
for fIndex = 1 : length(CTLFields)
    eval(strcat(CTLFields(fIndex), " = CTLParams.", CTLFields(fIndex), ";"));
end
lfpDataset = ECOGDownsample(lfpDataset, fd);

%% set trialAll
devType = unique([trialAll.devOrdr]);
devTemp = {trialAll.devOnset}';
[~, ordTemp] = ismember([trialAll.ordrSeq]', devType);
temp = cellfun(@(x, y) x + S1Duration(y), devTemp, num2cell(ordTemp), "UniformOutput", false);
trialAll = addFieldToStruct(trialAll, temp, "devOnset");
trialAll(1) = [];
   
%% split data
[trialsLFPRaw, ~, ~] = selectEcog(lfpDataset, trialAll, "dev onset", Window); % "dev onset"; "trial onset"
trialsLFPFiltered = mECOGFilter(trialsLFPRaw, 0.1, 200);

% spike
psthPara.binsize = 10; % ms
psthPara.binstep = 4; % ms
chSelect = [spikeDataset.realCh]';
% spike
trialsSpike = selectSpike(spikeDataset, trialAll, psthPara, CTLParams, "dev onset");

% initialize
t = linspace(Window(1), Window(2), size(trialsLFPFiltered{1}, 2))';


%% classify by devTypes
PMean = cell(length(devType), 1);
chMean = cell(length(devType), 1);
temp = cell(length(devType), 1);

chSpikeLfp = struct("stimStr", temp);
chAll = struct("stimStr", temp);

for dIndex = 1:length(devType)
    tIndex = [trialAll.devOrdr] == devType(dIndex);
    trialsLFP = trialsLFPFiltered(tIndex);
    trialsSPK = trialsSpike(tIndex);
    chLFP = [];
    for ch = 1 : size(trialsLFPFiltered{1}, 1)
        chLFP(ch).info = strcat("CH", num2str(ch));
    end
    %% LFP
        % FFT 
        tIdx = find(t > FFTWin(dIndex, 1) & t < FFTWin(dIndex, 2));
        [ff, PMean{dIndex, 1}, trialsFFT]  = trialsECOGFFT(trialsLFP, fs, tIdx, [], 2);
        % raw wave
        chMean{dIndex, 1} = cell2mat(cellfun(@mean , changeCellRowNum(trialsLFP), 'UniformOutput', false));
%         chStd = cell2mat(cellfun(@(x) std(x)/sqrt(length(tIndex)), changeCellRowNum(trialsLFP), 'UniformOutput', false));
        
        for ch = 1 : size(chMean{dIndex, 1}, 1)
            chLFP(ch).Wave(:, 1) = t';
            chLFP(ch).Wave(:, 2) = chMean{dIndex, 1}(ch, :)';
            chLFP(ch).FFT(:, 1) = ff';
            chLFP(ch).FFT(:, 2) = PMean{dIndex, 1}(ch, :)';
        end

        %% spike
        spikePlot = cellfun(@(x) cell2mat(x), num2cell(struct2cell(trialsSPK)', 1), "UniformOutput", false);
        chRS = cellfun(@(x) RayleighStatistic(x(:, 1), BaseICI(dIndex)), spikePlot, "UniformOutput", false);
        chPSTH = cellfun(@(x) calPsth(x(:, 1), psthPara, 1e3, 'EDGE', Window, 'NTRIAL', sum(tIndex)), spikePlot, "uni", false);
        chStr = fields(trialsSPK)';
         
        chSPK = cell2struct([chStr; spikePlot; chPSTH; chRS], ["info", "spikePlot", "PSTH", "chRS"]);
    
        
        % integration
    chSpikeLfp(dIndex).trialNum = sum(tIndex);
    chSpikeLfp(dIndex).stimStr = stimStr(dIndex);
    chSpikeLfp(dIndex).chSPK = chSPK;
    chSpikeLfp(dIndex).chLFP = chLFP(chSelect);
    chAll(dIndex).chLFP = chLFP;
end

%% Plot Figure
% single unit
Fig = chPlotFcn(chSpikeLfp, CTLParams);
mkdir(FIGPATH);
for cIndex = 1 : length(Fig)
    print(Fig(cIndex), strcat(FIGPATH, "CH", num2str(spikeDataset(cIndex).ch)), "-djpeg", "-r300");
    close(Fig(cIndex));
end

% lfp of whole period
FigLFP = MLA_PlotLfpByCh(chAll, CTLParams);
scaleAxes(FigLFP, "y");
scaleAxes(FigLFP, "x", plotWin);
print(FigLFP, strcat(FIGPATH, "LFP_ch"), "-djpeg", "-r300");

% lfp comparison acorss channels
FigLFPCompare = MLA_PlotLfpAcrossCh(chAll, CTLParams);
scaleAxes(FigLFPCompare, "x", [-50, 500]);
print(FigLFPCompare, strcat(FIGPATH, "LFP_Compare_Chs"), "-djpeg", "-r300");

close all;
end


