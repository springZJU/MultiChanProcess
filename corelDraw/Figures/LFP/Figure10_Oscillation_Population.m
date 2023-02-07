clear; clc
monkeyName = "DDZ";
configPath = strcat("E:\MonkeyLinearArray\MultiChanProcess\corelDraw\MLA_", monkeyName, "_NeuronSelect.xlsx");
popConfig = table2struct(readtable(configPath));


load("E:\MonkeyLinearArray\ProcessedData\TB_Oscillation_500_250_125_60_30_BF\popRes.mat")
SAVEPATH = strcat(fileparts(mfilename("fullpath")), "\Figures");
mkdir(SAVEPATH);

%% example CSD and MUA
baseWin = [-200, 0];
plotWin = [0, 3000];
rspWin = [0, 200];
for rIndex = 1 : length(popRes)
    tempCSD = popRes(rIndex).chCSD;  %20221216
    tempMUA = popRes(rIndex).chMUA;  %20221216
    SgIndex = str2double(string(strsplit(popConfig(rIndex).Sg, ",")));
    GrIndex = str2double(string(strsplit(popConfig(rIndex).Gr, ",")));
    IgIndex = str2double(string(strsplit(popConfig(rIndex).Ig, ",")));

    % MUA
    for pIndex = 1 : length(tempMUA)
        temp = tempMUA(pIndex).data;
        Window = [temp.tWave(pIndex), temp.tWave(end)];
        meanWave = temp.Wave - mean(findWithinWindow(temp.Wave, temp.tWave, baseWin), 2);
        fs = size(meanWave, 2)*1000/diff(Window);
        [f, Pow, P] = mFFT_Base(meanWave, fs, [0, 250]);
        meanWave = meanWave(:, 1:8:end);
        plotMUA(pIndex).info = tempMUA(pIndex).info;
        plotMUA(pIndex).recordDate(:, rIndex) = string(popRes(rIndex).Date);
        % Wave
        plotMUA(pIndex).tWave = temp.tWave(:, 1:8:end)';
        plotMUA(pIndex).SgWave(:, rIndex) = mean(meanWave(SgIndex, :), 1)';
        plotMUA(pIndex).GrWave(:, rIndex) = mean(meanWave(GrIndex, :), 1)';
        plotMUA(pIndex).IgWave(:, rIndex) = mean(meanWave(IgIndex, :), 1)';
        % FFT
        plotMUA(pIndex).f = f;
%         plotMUA(pIndex).FFT = P;
        plotMUA(pIndex).SgFFT(:, rIndex) = mean(P(SgIndex, :), 1)';
        plotMUA(pIndex).GrFFT(:, rIndex) = mean(P(GrIndex, :), 1)';
        plotMUA(pIndex).IgFFT(:, rIndex) = mean(P(IgIndex, :), 1)';
        
    end

    % CSD
    SgIndex = SgIndex(2:end)-1;
    GrIndex = GrIndex-1;
    IgIndex = IgIndex(2:end-1)-1;
    for pIndex = 1 : length(tempCSD)
        temp = tempCSD(pIndex).data;
        Window = [temp.tWave(1), temp.tWave(end)];
        meanWave = -1*(cell2mat(cellfun(@(x) mean(x, 1), changeCellRowNum(temp.Wave), "UniformOutput", false)));
        % normalize
        baseWave = findWithinWindow(meanWave, temp.tWave, baseWin);
        meanWave = (meanWave - mean(baseWave, 2))./std(baseWave, 1, 2);
        fs = size(meanWave, 2)*1000/diff(Window);
        [f, Pow, P] = mFFT_Base(meanWave, fs, [0, 250]);
        % Wave
        plotCSD(pIndex).info = tempCSD(pIndex).info;
        plotCSD(pIndex).tWave = temp.tWave';
        plotCSD(pIndex).SgWave(:, rIndex) = mean(meanWave(SgIndex, :), 1)';
        plotCSD(pIndex).GrWave(:, rIndex) = mean(meanWave(GrIndex, :), 1)';
        plotCSD(pIndex).IgWave(:, rIndex) = mean(meanWave(IgIndex, :), 1)';
        plotCSD(pIndex).recordDate(:, rIndex) = string(popRes(rIndex).Date);
        % FFT
        plotCSD(pIndex).f = f;
%         plotCSD(pIndex).FFT = P;
        plotCSD(pIndex).SgFFT(:, rIndex) = mean(P(SgIndex, :), 1)';
        plotCSD(pIndex).GrFFT(:, rIndex) = mean(P(GrIndex, :), 1)';
        plotCSD(pIndex).IgFFT(:, rIndex) = mean(P(IgIndex, :), 1)';
    end

end

%% pooled response and mean wave
for pIndex = 1 : length(plotMUA)
    plotMUA(pIndex).SgRsp = mean(findWithinWindow(plotMUA(pIndex).SgWave', plotMUA(pIndex).tWave',  rspWin), 2);
    plotMUA(pIndex).SgRspPool = [mean(plotMUA(pIndex).SgRsp), std(plotMUA(pIndex).SgRsp)/sqrt(length(plotMUA(pIndex).SgRsp))];
    plotMUA(pIndex).SgMean = [mean(plotMUA(pIndex).SgWave, 2), std(plotMUA(pIndex).SgWave, 1, 2)/sqrt(size(plotMUA(pIndex).SgWave, 2))];
    plotMUA(pIndex).SgFFTMean = [mean(plotMUA(pIndex).SgFFT-plotMUA(pIndex).SgFFT, 2), std(plotMUA(pIndex).SgFFT, 1, 2)/sqrt(size(plotMUA(pIndex).SgFFT, 2))];

    plotMUA(pIndex).GrRsp = mean(findWithinWindow(plotMUA(pIndex).GrWave', plotMUA(pIndex).tWave',  rspWin), 2);
    plotMUA(pIndex).GrRspPool = [mean(plotMUA(pIndex).GrRsp), std(plotMUA(pIndex).GrRsp)/sqrt(length(plotMUA(pIndex).GrRsp))];
    plotMUA(pIndex).GrMean = [mean(plotMUA(pIndex).GrWave, 2), std(plotMUA(pIndex).GrWave, 1, 2)/sqrt(size(plotMUA(pIndex).GrWave, 2))];
    plotMUA(pIndex).GrFFTMean = [mean(plotMUA(pIndex).GrFFT, 2), std(plotMUA(pIndex).GrFFT, 1, 2)/sqrt(size(plotMUA(pIndex).GrFFT, 2))];
    
    plotMUA(pIndex).IgRsp = mean(findWithinWindow(plotMUA(pIndex).IgWave', plotMUA(pIndex).tWave',  rspWin), 2);
    plotMUA(pIndex).IgRspPool = [mean(plotMUA(pIndex).IgRsp), std(plotMUA(pIndex).IgRsp)/sqrt(length(plotMUA(pIndex).IgRsp))];
    plotMUA(pIndex).IgMean = [mean(plotMUA(pIndex).IgWave, 2), std(plotMUA(pIndex).IgWave, 1, 2)/sqrt(size(plotMUA(pIndex).IgWave, 2))];
    plotMUA(pIndex).IgFFTMean = [mean(plotMUA(pIndex).IgFFT, 2), std(plotMUA(pIndex).IgFFT, 1, 2)/sqrt(size(plotMUA(pIndex).IgFFT, 2))];
end
for pIndex = 1 : length(plotCSD)
   plotCSD(pIndex).SgRsp = mean(findWithinWindow(plotCSD(pIndex).SgWave', plotCSD(pIndex).tWave',  rspWin), 2);
    plotCSD(pIndex).SgRspPool = [mean(plotCSD(pIndex).SgRsp), std(plotCSD(pIndex).SgRsp)/sqrt(length(plotCSD(pIndex).SgRsp))];
    plotCSD(pIndex).SgMean = [mean(plotCSD(pIndex).SgWave, 2), std(plotCSD(pIndex).SgWave, 1, 2)/sqrt(size(plotCSD(pIndex).SgWave, 2))];
    plotCSD(pIndex).SgFFTMean = [mean(plotCSD(pIndex).SgFFT, 2), std(plotCSD(pIndex).SgFFT, 1, 2)/sqrt(size(plotCSD(pIndex).SgFFT, 2))];

    plotCSD(pIndex).GrRsp = mean(findWithinWindow(plotCSD(pIndex).GrWave', plotCSD(pIndex).tWave',  rspWin), 2);
    plotCSD(pIndex).GrRspPool = [mean(plotCSD(pIndex).GrRsp), std(plotCSD(pIndex).GrRsp)/sqrt(length(plotCSD(pIndex).GrRsp))];
    plotCSD(pIndex).GrMean = [mean(plotCSD(pIndex).GrWave, 2), std(plotCSD(pIndex).GrWave, 1, 2)/sqrt(size(plotCSD(pIndex).GrWave, 2))];
    plotCSD(pIndex).GrFFTMean = [mean(plotCSD(pIndex).GrFFT, 2), std(plotCSD(pIndex).GrFFT, 1, 2)/sqrt(size(plotCSD(pIndex).GrFFT, 2))];

    plotCSD(pIndex).IgRsp = mean(findWithinWindow(plotCSD(pIndex).IgWave', plotCSD(pIndex).tWave',  rspWin), 2);
    plotCSD(pIndex).IgRspPool = [mean(plotCSD(pIndex).IgRsp), std(plotCSD(pIndex).IgRsp)/sqrt(length(plotCSD(pIndex).IgRsp))];
    plotCSD(pIndex).IgMean = [mean(plotCSD(pIndex).IgWave, 2), std(plotCSD(pIndex).IgWave, 1, 2)/sqrt(size(plotCSD(pIndex).IgWave, 2))];
    plotCSD(pIndex).IgFFTMean = [mean(plotCSD(pIndex).IgFFT, 2), std(plotCSD(pIndex).IgFFT, 1, 2)/sqrt(size(plotCSD(pIndex).IgFFT, 2))];
end

idx = 1:8;
PooledRsp.SgCSD = vertcat(plotCSD(idx).SgRspPool);
PooledRsp.GrCSD = vertcat(plotCSD(idx).GrRspPool);
PooledRsp.IgCSD = vertcat(plotCSD(idx).IgRspPool);

PooledRsp.SgMUA = vertcat(plotMUA(idx).SgRspPool);
PooledRsp.GrMUA = vertcat(plotMUA(idx).GrRspPool);
PooledRsp.IgMUA = vertcat(plotMUA(idx).IgRspPool);

%% slope

x = -[1/50, 1/100, 1/200, 1/400, 0]';
% MUA
PooledRsp.SgMUARaw = [plotMUA.SgRsp];
PooledRsp.SgMUARaw = PooledRsp.SgMUARaw(:, idx);
PooledRsp.GrMUARaw = [plotMUA.GrRsp];
PooledRsp.GrMUARaw = PooledRsp.GrMUARaw(:, idx);
PooledRsp.IgMUARaw = [plotMUA.IgRsp];
PooledRsp.IgMUARaw = PooledRsp.IgMUARaw(:, idx);
% CSD
PooledRsp.SgCSDRaw = [plotMUA.SgRsp];
PooledRsp.SgCSDRaw = PooledRsp.SgCSDRaw(:, idx);
PooledRsp.GrCSDRaw = [plotCSD.GrRsp];
PooledRsp.GrCSDRaw = PooledRsp.GrCSDRaw(:, idx);
PooledRsp.IgCSDRaw = [plotCSD.IgRsp];
PooledRsp.IgCSDRaw = PooledRsp.IgCSDRaw(:, idx);
% % firing rate regression
% [slope.Sg, intercept.Sg, R2.Sg, R2Adj.Sg, p.Sg] = cellfun(@(y) mFitlm(x,y), num2cell(PooledRsp.SgMUARaw, 2), "UniformOutput", false);
% [slope.Gr, intercept.Gr, R2.Gr, R2Adj.Gr, p.Gr] = cellfun(@(y) mFitlm(x,y), num2cell(PooledRsp.GrMUARaw, 2), "UniformOutput", false);
% [slope.Ig, intercept.Ig, R2.Ig, R2Adj.Ig, p.Ig] = cellfun(@(y) mFitlm(x,y), num2cell(PooledRsp.IgMUARaw, 2), "UniformOutput", false);
% slope.meanSg = mean(cell2mat(slope.Sg));
% slope.meanGr = mean(cell2mat(slope.Gr));
% slope.meanIg = mean(cell2mat(slope.Ig));