clear; clc
monkeyName = ["DDZ", "CM"];
for mIndex = 1 : length(monkeyName)
configPath = strcat("E:\MonkeyLinearArray\MultiChanProcess\corelDraw\MLA_", monkeyName(mIndex), "_NeuronSelect.xlsx");
popConfig{mIndex, 1} = table2struct(readtable(configPath));
end
popConfig = vertcat(popConfig{:});

load("E:\MonkeyLinearArray\ProcessedData\TB_Oscillation_500_250_125_60_30_BF\popRes.mat")

selDate = "ddz20221201";
excludeDate = ["ddz20221130", "ddz20221214", "ddz20221217", "ddz20221223", "ddz20221226", "ddz20221227"];
if exist("excludeDate", "var")
    popConfig(matches({popRes.Date}', excludeDate)) = [];
    popRes(matches({popRes.Date}', excludeDate)) = [];
end
correspFreq = 1000./[500, 250, 125, 60, 30];
%% example CSD and MUA
baseWin = [-300, 0];
plotWin = [0, 3000];
rspWin = [0, 200];
for rIndex = 1 : length(popRes)
    tempCSD = popRes(rIndex).chCSD;  %20221216
    tempMUA = popRes(rIndex).chMUA;  %20221216
    tempLFP = popRes(rIndex).rawLFP;


    % MUA
    SgIndex = str2double(string(strsplit(string(popConfig(rIndex).Sg), ",")));
    GrIndex = str2double(string(strsplit(string(popConfig(rIndex).Gr), ",")));
    IgIndex = str2double(string(strsplit(string(popConfig(rIndex).Ig), ",")));
    for pIndex = 1 : length(tempMUA)
        temp = tempMUA(pIndex).chMUA;
        Window = [temp.tWave(1), temp.tWave(end)];
        rawWave = temp.rawWave;

        rawWaveSmth = cellfun(@(x) smoothdata(x', "gaussian", 15)', rawWave, "UniformOutput", false);
        baseWaveSmth = cellfun(@(x) findWithinWindow(x, temp.tWave, baseWin), rawWaveSmth, "UniformOutput", false);
        rawWaveSmth = cellfun(@(x, y) (x-mean(y, 2))./std(y,1,2), rawWaveSmth, baseWaveSmth, "UniformOutput", false);
        meanWaveSmth = cell2mat(cellfun(@(x) mean(x, 1), rawWaveSmth,  "UniformOutput", false));

        %         baseWave = cellfun(@(x) findWithinWindow(x, temp.tWave, baseWin), rawWave, "UniformOutput", false);
        %         rawWave = cellfun(@(x, y) (x-mean(y, 2))./std(x, 1, 2), rawWave, baseWave, "UniformOutput", false);
        meanWave = cell2mat(cellfun(@(x) mean(x, 1), rawWave,  "UniformOutput", false));

        fs = size(meanWave, 2)*1000/diff(Window);
        [f, Pow, P] = cellfun(@(x) mFFT_Base(x, fs, [0, 250]), rawWave, "UniformOutput", false);
        f = f{1};
        Pow = cell2mat(cellfun(@(x) mean(x, 1), Pow, "UniformOutput", false));
        PMean = cell2mat(cellfun(@(x) mean(x, 1), P, "UniformOutput", false));
        %         [f, Pow, P] = mFFT_Base(meanWave, fs, [0, 250]);

        meanWave = meanWave(:, 1:2:end);

        plotMUA(pIndex).info = tempMUA(pIndex).info;
        plotMUA(pIndex).recordDate(:, rIndex) = string(popRes(rIndex).Date);
        % Wave
        plotMUA(pIndex).tWave = temp.tWave(:, 1:2:end)';
        plotMUA(pIndex).SgWave(:, rIndex) = mean(meanWave(SgIndex, :), 1)';
        plotMUA(pIndex).GrWave(:, rIndex) = mean(meanWave(GrIndex, :), 1)';
        plotMUA(pIndex).IgWave(:, rIndex) = mean(meanWave(IgIndex, :), 1)';
        % FFT
        plotMUA(pIndex).f = f;
        plotMUA(pIndex).FFT = P;
        plotMUA(pIndex).AllFFT(:, rIndex) = mean(PMean, 1)';
        plotMUA(pIndex).SgFFT(:, rIndex) = mean(PMean(SgIndex, :), 1)';
        plotMUA(pIndex).GrFFT(:, rIndex) = mean(PMean(GrIndex, :), 1)';
        plotMUA(pIndex).IgFFT(:, rIndex) = mean(PMean(IgIndex, :), 1)';

    end

    % CSD
    SgIndex = str2double(string(strsplit(string(popConfig(rIndex).Sg), ",")))-1;
    SgIndex(1) = [];
    GrIndex = str2double(string(strsplit(string(popConfig(rIndex).Gr), ",")))-1;
    IgIndex = str2double(string(strsplit(string(popConfig(rIndex).Ig), ",")))-1;
    IgIndex(end) = [];
    for pIndex = 1 : length(tempCSD)
        temp = tempCSD(pIndex).chCSD;
        Window = [temp.tWave(1), temp.tWave(end)];
        rawWave = changeCellRowNum(temp.Wave);

        rawWaveSmth = cellfun(@(x) smoothdata(x', "gaussian", 15)', rawWave, "UniformOutput", false);
        baseWaveSmth = cellfun(@(x) findWithinWindow(x, temp.tWave, baseWin), rawWaveSmth, "UniformOutput", false);
        rawWaveSmth = cellfun(@(x, y) (x-mean(y, 2))./std(y,1,2), rawWaveSmth, baseWaveSmth, "UniformOutput", false);
        meanWaveSmth = cell2mat(cellfun(@(x) mean(x, 1), rawWaveSmth,  "UniformOutput", false));

        %         baseWave = cellfun(@(x) findWithinWindow(x, temp.tWave, baseWin), rawWave, "UniformOutput", false);
        %         rawWave = cellfun(@(x, y) (x-mean(y, 2))./std(x, 1, 2), rawWave, baseWave, "UniformOutput", false);
        meanWave = cell2mat(cellfun(@(x) mean(x, 1), rawWave,  "UniformOutput", false));

        fs = size(meanWave, 2)*1000/diff(Window);
        [f, Pow, P] = cellfun(@(x) mFFT_Base(x, fs, [0, 250]), rawWave, "UniformOutput", false);
        f = f{1};
        Pow = cell2mat(cellfun(@(x) mean(x, 1), Pow, "UniformOutput", false));
        PMean = cell2mat(cellfun(@(x) mean(x, 1), P, "UniformOutput", false));

        %         [f, Pow, P] = mFFT_Base(meanWave, fs, [0, 250]);
        meanWave = meanWave(:, 1:2:end);

        plotCSD(pIndex).info = tempCSD(pIndex).info;
        plotCSD(pIndex).recordDate(:, rIndex) = string(popRes(rIndex).Date);
        % Wave
        plotCSD(pIndex).tWave = temp.tWave(1:2:end)';
        plotCSD(pIndex).SgWave(:, rIndex) = mean(meanWave(SgIndex, :), 1)';
        plotCSD(pIndex).GrWave(:, rIndex) = mean(meanWave(GrIndex, :), 1)';
        plotCSD(pIndex).IgWave(:, rIndex) = mean(meanWave(IgIndex, :), 1)';

        % FFT
        plotCSD(pIndex).f = f;
        plotCSD(pIndex).FFT = P;
        plotCSD(pIndex).AllFFT(:, rIndex) = mean(PMean, 1)';
        plotCSD(pIndex).SgFFT(:, rIndex) = mean(PMean(SgIndex, :), 1)';
        plotCSD(pIndex).GrFFT(:, rIndex) = mean(PMean(GrIndex, :), 1)';
        plotCSD(pIndex).IgFFT(:, rIndex) = mean(PMean(IgIndex, :), 1)';
    end

    % LFP
    SgIndex = str2double(string(strsplit(string(popConfig(rIndex).Sg), ",")));
    GrIndex = str2double(string(strsplit(string(popConfig(rIndex).Gr), ",")));
    IgIndex = str2double(string(strsplit(string(popConfig(rIndex).Ig), ",")));

    for pIndex = 1 : length(tempLFP)
        temp = tempLFP(pIndex).rawLFP;
        Window = [temp.t(1), temp.t(end)];
        rawWave = changeCellRowNum(temp.rawWave);

        rawWaveSmth = cellfun(@(x) smoothdata(x', "gaussian", 15)', rawWave, "UniformOutput", false);
        baseWaveSmth = cellfun(@(x) findWithinWindow(x, temp.t, baseWin), rawWaveSmth, "UniformOutput", false);
        rawWaveSmth = cellfun(@(x, y) (x-mean(y, 2))./std(y,1,2), rawWaveSmth, baseWaveSmth, "UniformOutput", false);
        meanWaveSmth = cell2mat(cellfun(@(x) mean(x, 1), rawWaveSmth,  "UniformOutput", false));

        %         baseWave = cellfun(@(x) findWithinWindow(x, temp.t, baseWin), rawWave, "UniformOutput", false);
        %         rawWave = cellfun(@(x, y) (x-mean(y, 2))./std(x, 1, 2), rawWave, baseWave, "UniformOutput", false);
        meanWave = cell2mat(cellfun(@(x) mean(x, 1), rawWave,  "UniformOutput", false));

        fs = size(meanWave, 2)*1000/diff(Window);
        [f, Pow, P] = cellfun(@(x) mFFT_Base(x, fs, [0, 250]), rawWave, "UniformOutput", false);
        f = f{1};
        Pow = cell2mat(cellfun(@(x) mean(x, 1), Pow, "UniformOutput", false));
        PMean = cell2mat(cellfun(@(x) mean(x, 1), P, "UniformOutput", false));
        %         [f, Pow, P] = mFFT_Base(meanWave, fs, [0, 250]);
        meanWave = meanWave(:, 1:2:end);

        plotLFP(pIndex).info = tempLFP(pIndex).info;
        plotLFP(pIndex).recordDate(:, rIndex) = string(popRes(rIndex).Date);
        % Wave
        plotLFP(pIndex).tWave = temp.t(1:2:end)';
        plotLFP(pIndex).SgWave(:, rIndex) = mean(meanWave(SgIndex, :), 1)';
        plotLFP(pIndex).GrWave(:, rIndex) = mean(meanWave(GrIndex, :), 1)';
        plotLFP(pIndex).IgWave(:, rIndex) = mean(meanWave(IgIndex, :), 1)';

        % FFT
        plotLFP(pIndex).f = f;
        plotLFP(pIndex).FFT = P;
        plotLFP(pIndex).AllFFT(:, rIndex) = mean(PMean, 1)';
        plotLFP(pIndex).SgFFT(:, rIndex) = mean(PMean(SgIndex, :), 1)';
        plotLFP(pIndex).GrFFT(:, rIndex) = mean(PMean(GrIndex, :), 1)';
        plotLFP(pIndex).IgFFT(:, rIndex) = mean(PMean(IgIndex, :), 1)';
    end

    for dIndex = 1 : length(correspFreq)
        % LFP
        SgIndex = str2double(string(strsplit(string(popConfig(rIndex).Sg), ",")));
        GrIndex = str2double(string(strsplit(string(popConfig(rIndex).Gr), ",")));
        IgIndex = str2double(string(strsplit(string(popConfig(rIndex).Ig), ",")));

        [tarMean, idx] = findWithinWindow(plotLFP(dIndex).SgFFT', f, [0.9, 1.1] * correspFreq(dIndex));
        [~, targetIndex] = max(tarMean, [], 2);
        targetIdx = mode(targetIndex) + idx(1) - 1;
        [H, P] = waveFFTPower_pValue(plotLFP(dIndex).FFT, plotLFP(6).FFT, [{f}, {f}], targetIdx, 2);
        ttestLFP(dIndex).fMax = f(targetIdx);
        ttestLFP(dIndex).pVal = P;
        ttestLFP(dIndex).hVal = H;
        ttestLFP(dIndex).SgIndex = SgIndex;
        ttestLFP(dIndex).GrIndex = GrIndex;
        ttestLFP(dIndex).IgIndex = IgIndex;

        % CSD
        SgIndex = str2double(string(strsplit(string(popConfig(rIndex).Sg), ",")))-1; SgIndex(1) = [];
        GrIndex = str2double(string(strsplit(string(popConfig(rIndex).Gr), ",")))-1;
        IgIndex = str2double(string(strsplit(string(popConfig(rIndex).Ig), ",")))-1; IgIndex(end) = [];

        [tarMean, idx] = findWithinWindow(plotCSD(dIndex).SgFFT', f, [0.9, 1.1] * correspFreq(dIndex));
        [~, targetIndex] = max(tarMean, [], 2);
        targetIdx = mode(targetIndex) + idx(1) - 1;
        [H, P] = waveFFTPower_pValue(plotCSD(dIndex).FFT, plotCSD(6).FFT, [{f}, {f}], targetIdx, 2);
        ttestCSD(dIndex).fMax = f(targetIdx);
        ttestCSD(dIndex).pVal = P;
        ttestCSD(dIndex).hVal = H;
        ttestCSD(dIndex).SgIndex = SgIndex;
        ttestCSD(dIndex).GrIndex = GrIndex;
        ttestCSD(dIndex).IgIndex = IgIndex;

        % MUA
        SgIndex = str2double(string(strsplit(string(popConfig(rIndex).Sg), ",")));
        GrIndex = str2double(string(strsplit(string(popConfig(rIndex).Gr), ",")));
        IgIndex = str2double(string(strsplit(string(popConfig(rIndex).Ig), ",")));

        [tarMean, idx] = findWithinWindow(plotMUA(dIndex).SgFFT', f, [0.9, 1.1] * correspFreq(dIndex));
        [~, targetIndex] = max(tarMean, [], 2);
        targetIdx = mode(targetIndex) + idx(1) - 1;
        [H, P] = waveFFTPower_pValue(plotMUA(dIndex).FFT, plotMUA(6).FFT, [{f}, {f}], targetIdx, 2);
        ttestMUA(dIndex).fMax = f(targetIdx);
        ttestMUA(dIndex).pVal = P;
        ttestMUA(dIndex).hVal = H;
        ttestMUA(dIndex).SgIndex = SgIndex;
        ttestMUA(dIndex).GrIndex = GrIndex;
        ttestMUA(dIndex).IgIndex = IgIndex;
    end
    ttestRes(rIndex).LFP = ttestLFP;
    ttestRes(rIndex).CSD = ttestCSD;
    ttestRes(rIndex).MUA = ttestMUA;
end

%% sig ratio
clear H
for rIndex = 1 : length(ttestRes)
    for dIndex = 1 : length(ttestRes(rIndex).MUA)
        H(dIndex).info = plotCSD(dIndex).info;
        % MUA
        SgIndex = ttestRes(rIndex).MUA(1).SgIndex;
        GrIndex = ttestRes(rIndex).MUA(1).GrIndex;
        IgIndex = ttestRes(rIndex).MUA(1).IgIndex;
        H(dIndex).MUA(1).info = "SgIndex";
        H(dIndex).MUA(1).data{rIndex, 1} = ttestRes(rIndex).MUA(dIndex).hVal(SgIndex);
        H(dIndex).MUA(2).info = "GrIndex";
        H(dIndex).MUA(2).data{rIndex, 1} = ttestRes(rIndex).MUA(dIndex).hVal(GrIndex);
        H(dIndex).MUA(3).info = "IgIndex";
        H(dIndex).MUA(3).data{rIndex, 1} = ttestRes(rIndex).MUA(dIndex).hVal(IgIndex);

        % LFP
        SgIndex = ttestRes(rIndex).LFP(1).SgIndex;
        GrIndex = ttestRes(rIndex).LFP(1).GrIndex;
        IgIndex = ttestRes(rIndex).LFP(1).IgIndex;
        H(dIndex).LFP(1).info = "SgIndex";
        H(dIndex).LFP(1).data{rIndex, 1} = ttestRes(rIndex).LFP(dIndex).hVal(SgIndex);
        H(dIndex).LFP(2).info = "GrIndex";
        H(dIndex).LFP(2).data{rIndex, 1} = ttestRes(rIndex).LFP(dIndex).hVal(GrIndex);
        H(dIndex).LFP(3).info = "IgIndex";
        H(dIndex).LFP(3).data{rIndex, 1} = ttestRes(rIndex).LFP(dIndex).hVal(IgIndex);

        % CSD
        SgIndex = ttestRes(rIndex).CSD(1).SgIndex;
        GrIndex = ttestRes(rIndex).CSD(1).GrIndex;
        IgIndex = ttestRes(rIndex).CSD(1).IgIndex;
        H(dIndex).CSD(1).info = "SgIndex";
        H(dIndex).CSD(1).data{rIndex, 1} = ttestRes(rIndex).CSD(dIndex).hVal(SgIndex);
        H(dIndex).CSD(2).info = "GrIndex";
        H(dIndex).CSD(2).data{rIndex, 1} = ttestRes(rIndex).CSD(dIndex).hVal(GrIndex);
        H(dIndex).CSD(3).info = "IgIndex";
        H(dIndex).CSD(3).data{rIndex, 1} = ttestRes(rIndex).CSD(dIndex).hVal(IgIndex);
    end
end


for dIndex = 1 : length(ttestRes(rIndex).MUA)
    for lIndex = 1 : length(H(dIndex).MUA)
        H(dIndex).CSD(lIndex).poolData = cell2mat(H(dIndex).CSD(lIndex).data);
        H(dIndex).CSD(lIndex).ratio = sum(H(dIndex).CSD(lIndex).poolData>0)/length(H(dIndex).CSD(lIndex).poolData);
  
        H(dIndex).MUA(lIndex).poolData = cell2mat(H(dIndex).MUA(lIndex).data);
        H(dIndex).MUA(lIndex).ratio = sum(H(dIndex).MUA(lIndex).poolData>0)/length(H(dIndex).MUA(lIndex).poolData);

        H(dIndex).LFP(lIndex).poolData = cell2mat(H(dIndex).LFP(lIndex).data);
        H(dIndex).LFP(lIndex).ratio = sum(H(dIndex).LFP(lIndex).poolData>0)/length(H(dIndex).LFP(lIndex).poolData);
    end
end









