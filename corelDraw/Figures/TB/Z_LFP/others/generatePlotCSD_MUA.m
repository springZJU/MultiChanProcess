baseWin = [-200, 0];
plotWin = [-50, 300];
rspWin = [0, 200];
for rIndex = 1 : length(popRes)
    tempCSD = popRes(rIndex).chCSD;
    tempMUA = popRes(rIndex).chMUA;
    SgIndex = str2double(string(strsplit(string(popConfig(rIndex).Sg), ",")));
    GrIndex = str2double(string(strsplit(string(popConfig(rIndex).Gr), ",")));
    IgIndex = str2double(string(strsplit(string(popConfig(rIndex).Ig), ",")));

    % MUA
    for pIndex = 1 : length(tempMUA)
        temp = tempMUA(pIndex).chMUA;
        Window = [temp.tWave(pIndex), temp.tWave(end)];
        rawWave = temp.rawWave;

        % rawWave smooth
        rawWaveSmth = cellfun(@(x) smoothdata(x', "gaussian", 15)', rawWave, "UniformOutput", false);
        if exist("excludeTrial", "var")
            excludeIdx = find(matches({excludeTrial.Date}', popRes(rIndex).Date));
            if ~isempty(excludeIdx) &&  pIndex == excludeTrial(excludeIdx).Prot
                rawWaveSmth = cellfun(@(x) x(~ismember(1:size(rawWaveSmth{1}, 1), excludeTrial(excludeIdx).Trial), :), rawWaveSmth, "UniformOutput", false);
            end
        end
        baseWaveSmth = cellfun(@(x) findWithinWindow(x, temp.tWave, baseWin), rawWaveSmth, "UniformOutput", false);
        rawWaveSmth = cellfun(@(x, y) x-mean(y, 2), rawWaveSmth, baseWaveSmth, "UniformOutput", false);
        meanWaveSmth = cell2mat(cellfun(@(x) mean(x, 1), rawWaveSmth,  "UniformOutput", false));

        % rawWave
        if exist("excludeTrial", "var")
            excludeIdx = find(matches({excludeTrial.Date}', popRes(rIndex).Date));
            if ~isempty(excludeIdx) &&  pIndex == excludeTrial(excludeIdx).Prot
                rawWave = cellfun(@(x) x(~ismember(1:size(rawWave{1}, 1), excludeTrial(excludeIdx).Trial), :), rawWave, "UniformOutput", false);
            end
        end
        baseWave = cellfun(@(x) findWithinWindow(x, temp.tWave, baseWin), rawWave, "UniformOutput", false);
        rawWave = cellfun(@(x, y) (x-mean(y, 2))./std(x, 1, 2), rawWave, baseWave, "UniformOutput", false);
        meanWave = cell2mat(cellfun(@(x) mean(x, 1), rawWave,  "UniformOutput", false));

        % plotMUA raw
        plotMUA(pIndex).info = tempMUA(pIndex).info;
        plotMUA(pIndex).tWave = temp.tWave';
        plotMUA(pIndex).SgWave(:, rIndex) = mean(meanWave(SgIndex, :), 1)';
        plotMUA(pIndex).GrWave(:, rIndex) = mean(meanWave(GrIndex, :), 1)';
        plotMUA(pIndex).IgWave(:, rIndex) = mean(meanWave(IgIndex, :), 1)';
        plotMUA(pIndex).AllWave(:, rIndex) = mean(meanWave, 1)';
        plotMUA(pIndex).recordDate(:, rIndex) = string(popRes(rIndex).Date);

        % plotMUA smooth
        plotMUA(pIndex).SgWaveSmth(:, rIndex) = mean(meanWaveSmth(SgIndex, :), 1)';
        plotMUA(pIndex).GrWaveSmth(:, rIndex) = mean(meanWaveSmth(GrIndex, :), 1)';
        plotMUA(pIndex).IgWaveSmth(:, rIndex) = mean(meanWaveSmth(IgIndex, :), 1)';
        plotMUA(pIndex).AllWaveSmth(:, rIndex) = mean(meanWaveSmth, 1)';
    end

    % CSD
        SgIndex = str2double(string(strsplit(string(popConfig(rIndex).SgSel), ",")))-1;
        GrIndex = str2double(string(strsplit(string(popConfig(rIndex).GrSel), ",")))-1;
        IgIndex = str2double(string(strsplit(string(popConfig(rIndex).IgSel), ",")))-1;
    for pIndex = 1 : length(tempCSD)
        temp = tempCSD(pIndex).chCSD;
        Window = [temp.tWave(pIndex), temp.tWave(end)];
        rawWave = changeCellRowNum(temp.Wave);
        
        % rawWave smooth
        rawWaveSmth = cellfun(@(x) smoothdata(x', "gaussian", 15)', rawWave, "UniformOutput", false);
        if exist("excludeTrial", "var")
            excludeIdx = find(matches({excludeTrial.Date}', popRes(rIndex).Date));
            if ~isempty(excludeIdx) &&  pIndex == excludeTrial(excludeIdx).Prot
                rawWaveSmth = cellfun(@(x) x(~ismember(1:size(rawWaveSmth{1}, 1), excludeTrial(excludeIdx).Trial), :), rawWaveSmth, "UniformOutput", false);
            end
        end
        baseWaveSmth = cellfun(@(x) findWithinWindow(x, temp.tWave, baseWin), rawWaveSmth, "UniformOutput", false);
        zWaveSmth = cellfun(@(x, y) -1*(x-mean(y, 2))./std(y, 1, 2), rawWaveSmth, baseWaveSmth, "UniformOutput", false);
        meanWaveSmth = cell2mat(cellfun(@(x) mean(x, 1), zWaveSmth, "UniformOutput", false));
        
        % rawWave
        if exist("excludeTrial", "var")
            excludeIdx = find(matches({excludeTrial.Date}', popRes(rIndex).Date));
            if ~isempty(excludeIdx) &&  pIndex == excludeTrial(excludeIdx).Prot
                rawWave = cellfun(@(x) x(~ismember(1:size(rawWave{1}, 1), excludeTrial(excludeIdx).Trial), :), rawWave, "UniformOutput", false);
            end
        end
        baseWave = cellfun(@(x) findWithinWindow(x, temp.tWave, baseWin), rawWave, "UniformOutput", false);
        zWave = cellfun(@(x, y) -1*(x-mean(y, 2))./std(y, 1, 2), rawWave, baseWave, "UniformOutput", false);
        meanWave = cell2mat(cellfun(@(x) mean(x, 1), zWave, "UniformOutput", false));

        % plotCSD raw
        plotCSD(pIndex).info = tempCSD(pIndex).info;
        plotCSD(pIndex).tWave = temp.tWave';
        plotCSD(pIndex).SgWave(:, rIndex) = mean(meanWave(SgIndex, :), 1)';
        plotCSD(pIndex).GrWave(:, rIndex) = mean(meanWave(GrIndex, :), 1)';
        plotCSD(pIndex).IgWave(:, rIndex) = mean(meanWave(IgIndex, :), 1)';
        plotCSD(pIndex).AllWave(:, rIndex) = mean(meanWave, 1)';
        plotCSD(pIndex).recordDate(:, rIndex) = string(popRes(rIndex).Date);

        % plotCSD smooth
        plotCSD(pIndex).SgWaveSmth(:, rIndex) = mean(meanWaveSmth(SgIndex, :), 1)';
        plotCSD(pIndex).GrWaveSmth(:, rIndex) = mean(meanWaveSmth(GrIndex, :), 1)';
        plotCSD(pIndex).IgWaveSmth(:, rIndex) = mean(meanWaveSmth(IgIndex, :), 1)';
        plotCSD(pIndex).AllWaveSmth(:, rIndex) = mean(meanWaveSmth, 1)';
    end

end
%% pooled response and mean wave
for pIndex = 1 : length(plotMUA)
    plotMUA(pIndex).SgRsp = mean(findWithinWindow(plotMUA(pIndex).SgWave', plotMUA(pIndex).tWave',  rspWin), 2);
    plotMUA(pIndex).SgRspPool = [mean(plotMUA(pIndex).SgRsp), std(plotMUA(pIndex).SgRsp)/sqrt(length(plotMUA(pIndex).SgRsp))];
    plotMUA(pIndex).SgMean = [mean(plotMUA(pIndex).SgWave, 2), std(plotMUA(pIndex).SgWave, 1, 2)/sqrt(size(plotMUA(pIndex).SgWave, 2))];
    plotMUA(pIndex).SgMeanSmth = [mean(plotMUA(pIndex).SgWaveSmth, 2), std(plotMUA(pIndex).SgWaveSmth, 1, 2)/sqrt(size(plotMUA(pIndex).SgWaveSmth, 2))];

    plotMUA(pIndex).GrRsp = mean(findWithinWindow(plotMUA(pIndex).GrWave', plotMUA(pIndex).tWave',  rspWin), 2);
    plotMUA(pIndex).GrRspPool = [mean(plotMUA(pIndex).GrRsp), std(plotMUA(pIndex).GrRsp)/sqrt(length(plotMUA(pIndex).GrRsp))];
    plotMUA(pIndex).GrMean = [mean(plotMUA(pIndex).GrWave, 2), std(plotMUA(pIndex).GrWave, 1, 2)/sqrt(size(plotMUA(pIndex).GrWave, 2))];
    plotMUA(pIndex).GrMeanSmth = [mean(plotMUA(pIndex).GrWaveSmth, 2), std(plotMUA(pIndex).GrWaveSmth, 1, 2)/sqrt(size(plotMUA(pIndex).GrWaveSmth, 2))];

    plotMUA(pIndex).IgRsp = mean(findWithinWindow(plotMUA(pIndex).IgWave', plotMUA(pIndex).tWave',  rspWin), 2);
    plotMUA(pIndex).IgRspPool = [mean(plotMUA(pIndex).IgRsp), std(plotMUA(pIndex).IgRsp)/sqrt(length(plotMUA(pIndex).IgRsp))];
    plotMUA(pIndex).IgMean = [mean(plotMUA(pIndex).IgWave, 2), std(plotMUA(pIndex).IgWave, 1, 2)/sqrt(size(plotMUA(pIndex).IgWave, 2))];
    plotMUA(pIndex).IgMeanSmth = [mean(plotMUA(pIndex).IgWaveSmth, 2), std(plotMUA(pIndex).IgWaveSmth, 1, 2)/sqrt(size(plotMUA(pIndex).IgWaveSmth, 2))];

    plotMUA(pIndex).AllRsp = mean(findWithinWindow(plotMUA(pIndex).AllWave', plotMUA(pIndex).tWave',  rspWin), 2);
    plotMUA(pIndex).AllRspPool = [mean(plotMUA(pIndex).AllRsp), std(plotMUA(pIndex).AllRsp)/sqrt(length(plotMUA(pIndex).AllRsp))];
    plotMUA(pIndex).AllMean = [mean(plotMUA(pIndex).AllWave, 2), std(plotMUA(pIndex).AllWave, 1, 2)/sqrt(size(plotMUA(pIndex).AllWave, 2))];
    plotMUA(pIndex).AllMeanSmth = [mean(plotMUA(pIndex).AllWaveSmth, 2), std(plotMUA(pIndex).AllWaveSmth, 1, 2)/sqrt(size(plotMUA(pIndex).AllWaveSmth, 2))];
end
for pIndex = 1 : length(plotCSD)
    plotCSD(pIndex).SgRsp = mean(findWithinWindow(plotCSD(pIndex).SgWave', plotCSD(pIndex).tWave',  rspWin), 2);
    plotCSD(pIndex).SgRspPool = [mean(plotCSD(pIndex).SgRsp), std(plotCSD(pIndex).SgRsp)/sqrt(length(plotCSD(pIndex).SgRsp))];
    plotCSD(pIndex).SgMean = [mean(plotCSD(pIndex).SgWave, 2), std(plotCSD(pIndex).SgWave, 1, 2)/sqrt(size(plotCSD(pIndex).SgWave, 2))];
    plotCSD(pIndex).SgMeanSmth = [mean(plotCSD(pIndex).SgWaveSmth, 2), std(plotCSD(pIndex).SgWaveSmth, 1, 2)/sqrt(size(plotCSD(pIndex).SgWaveSmth, 2))];

    plotCSD(pIndex).GrRsp = mean(findWithinWindow(plotCSD(pIndex).GrWave', plotCSD(pIndex).tWave',  rspWin), 2);
    plotCSD(pIndex).GrRspPool = [mean(plotCSD(pIndex).GrRsp), std(plotCSD(pIndex).GrRsp)/sqrt(length(plotCSD(pIndex).GrRsp))];
    plotCSD(pIndex).GrMean = [mean(plotCSD(pIndex).GrWave, 2), std(plotCSD(pIndex).GrWave, 1, 2)/sqrt(size(plotCSD(pIndex).GrWave, 2))];
    plotCSD(pIndex).GrMeanSmth = [mean(plotCSD(pIndex).GrWaveSmth, 2), std(plotCSD(pIndex).GrWaveSmth, 1, 2)/sqrt(size(plotCSD(pIndex).GrWaveSmth, 2))];

    plotCSD(pIndex).IgRsp = mean(findWithinWindow(plotCSD(pIndex).IgWave', plotCSD(pIndex).tWave',  rspWin), 2);
    plotCSD(pIndex).IgRspPool = [mean(plotCSD(pIndex).IgRsp), std(plotCSD(pIndex).IgRsp)/sqrt(length(plotCSD(pIndex).IgRsp))];
    plotCSD(pIndex).IgMean = [mean(plotCSD(pIndex).IgWave, 2), std(plotCSD(pIndex).IgWave, 1, 2)/sqrt(size(plotCSD(pIndex).IgWave, 2))];
    plotCSD(pIndex).IgMeanSmth = [mean(plotCSD(pIndex).IgWaveSmth, 2), std(plotCSD(pIndex).IgWaveSmth, 1, 2)/sqrt(size(plotCSD(pIndex).IgWaveSmth, 2))];

    plotCSD(pIndex).AllRsp = mean(findWithinWindow(plotCSD(pIndex).AllWave', plotCSD(pIndex).tWave',  rspWin), 2);
    plotCSD(pIndex).AllRspPool = [mean(plotCSD(pIndex).AllRsp), std(plotCSD(pIndex).AllRsp)/sqrt(length(plotCSD(pIndex).AllRsp))];
    plotCSD(pIndex).AllMean = [mean(plotCSD(pIndex).AllWave, 2), std(plotCSD(pIndex).AllWave, 1, 2)/sqrt(size(plotCSD(pIndex).AllWave, 2))];
    plotCSD(pIndex).AllMeanSmth = [mean(plotCSD(pIndex).AllWaveSmth, 2), std(plotCSD(pIndex).AllWaveSmth, 1, 2)/sqrt(size(plotCSD(pIndex).AllWaveSmth, 2))];

end