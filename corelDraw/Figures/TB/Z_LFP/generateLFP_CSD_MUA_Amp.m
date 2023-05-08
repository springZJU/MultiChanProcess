plotWin = [-50, 300];
baseWin = [-300, 0];
rspWin = [0, 300];
for rIndex = 1 : length(popRes)
    ttestRes(rIndex).Date = popRes(rIndex).Date;
    tempCSD = popRes(rIndex).chCSD;
    tempMUA = popRes(rIndex).chMUA;
    tempLFP = popRes(rIndex).rawLFP;
    
    % MUA
    SgIndex = str2double(string(strsplit(string(popConfig(rIndex).Sg), ",")));
    GrIndex = str2double(string(strsplit(string(popConfig(rIndex).Gr), ",")));
    IgIndex = str2double(string(strsplit(string(popConfig(rIndex).Ig), ",")));
    for pIndex = 1 : length(tempMUA)
        temp = tempMUA(pIndex).chMUA;
        Window = [temp.tWave(1), temp.tWave(end)];
        rawWave = changeCellRowNum(excludeTrialsChs(changeCellRowNum(temp.rawWave), 0.1));
        
        % rawWave smooth
        rawWaveSmth = cellfun(@(x) smoothdata(x', "gaussian", 15)', rawWave, "UniformOutput", false);
        if exist("excludeTrial", "var")
            excludeIdx = find(matches({excludeTrial.Date}', popRes(rIndex).Date));
            if ~isempty(excludeIdx) &&  pIndex == excludeTrial(excludeIdx).Prot
                rawWaveSmth = cellfun(@(x) x(~ismember(1:size(rawWaveSmth{1}, 1), excludeTrial(excludeIdx).Trial), :), rawWaveSmth, "UniformOutput", false);
            end
        end
        baseWaveSmth = cellfun(@(x) findWithinWindow(x, temp.tWave, baseWin), rawWaveSmth, "UniformOutput", false);
        rawWaveSmth = cellfun(@(x, y) (x-mean(y, 2))./std(y,1,2), rawWaveSmth, baseWaveSmth, "UniformOutput", false);
        meanWaveSmth = cell2mat(cellfun(@(x) mean(x, 1), rawWaveSmth,  "UniformOutput", false));

        % rawWave amplitude
        baseWave = cellfun(@(x) findWithinWindow(x, temp.tWave, baseWin), rawWave, "UniformOutput", false);
%         rawWave = cellfun(@(x, y) (x), rawWave, baseWave, "UniformOutput", false);
%         rawWave = cellfun(@(x, y) (x-mean(y, 2))./std(x, 1, 2), rawWave, baseWave, "UniformOutput", false);
        base = cellfun(@(x) mean(findWithinWindow(x, temp.tWave, baseWin), 2), rawWave, "UniformOutput", false);
        rsp = cellfun(@(x) mean(findWithinWindow(x, temp.tWave, rspWin), 2), rawWave, "UniformOutput", false);
        TBI = cellfun(@(x, y) (y-x)./x, base, rsp, "UniformOutput", false);
        [h, p] = cellfun(@(x, y) ttest(x, y), base, rsp, "UniformOutput", false);

        rawWave = cellfun(@(x, y) (x-mean(y, 2))./std(x, 1, 2), rawWave, baseWave, "UniformOutput", false);
        baseMUA = cellfun(@(x) mean(findWithinWindow(x, temp.tWave, baseWin), 2), rawWave, "UniformOutput", false);
        rspMUA = cellfun(@(x) mean(findWithinWindow(x, temp.tWave, rspWin), 2), rawWave, "UniformOutput", false);
        
        meanMUA = cellfun(@mean, rspMUA);
        stdMUA = cell2mat(cellfun(@(x) std(x)/sqrt(length(x)), rspMUA, "UniformOutput", false));
        meanBaseMUA = cellfun(@mean, baseMUA);
        ttestMUA(pIndex).info = tempMUA(pIndex).info;
        ttestMUA(pIndex).rspMUA = rspMUA;
        ttestMUA(pIndex).rspMeanMUA = meanMUA;
        ttestMUA(pIndex).rspSEMUA = stdMUA;
        ttestMUA(pIndex).baseMeanMUA = meanBaseMUA;
        ttestMUA(pIndex).baseMUA = baseMUA;
        ttestMUA(pIndex).TBI = TBI;
        ttestMUA(pIndex).TBIMean = cellfun(@mean, TBI);
        ttestMUA(pIndex).TBISE = cell2mat(cellfun(@(x) std(x)/sqrt(length(x)), TBI, "UniformOutput", false));
        ttestMUA(pIndex).h = cell2mat(h);
        ttestMUA(pIndex).p = cell2mat(p);
        ttestMUA(pIndex).SgIndex = SgIndex;
        ttestMUA(pIndex).GrIndex = GrIndex;
        ttestMUA(pIndex).IgIndex = IgIndex;

        % plotMUA smooth
        plotMUA(pIndex).info = tempMUA(pIndex).info;
        plotMUA(pIndex).tWave = temp.tWave';
        plotMUA(pIndex).chWaveSmth{rIndex,1} = meanWaveSmth';
        plotMUA(pIndex).SgWaveSmth(:, rIndex) = mean(meanWaveSmth(SgIndex, :), 1)';
        plotMUA(pIndex).GrWaveSmth(:, rIndex) = mean(meanWaveSmth(GrIndex, :), 1)';
        plotMUA(pIndex).IgWaveSmth(:, rIndex) = mean(meanWaveSmth(IgIndex, :), 1)';
        plotMUA(pIndex).AllWaveSmth(:, rIndex) = mean(meanWaveSmth, 1)';
        plotMUA(pIndex).recordDate(:, rIndex) = string(popRes(rIndex).Date);
    end
    ttestRes(rIndex).MUA = ttestMUA;

    % CSD
    SgIndex = str2double(string(strsplit(string(popConfig(rIndex).Sg), ",")))-1;
    SgIndex(1) = [];
    GrIndex = str2double(string(strsplit(string(popConfig(rIndex).Gr), ",")))-1;
    IgIndex = str2double(string(strsplit(string(popConfig(rIndex).Ig), ",")))-1;
    IgIndex(end) = [];
    for pIndex = 1 : length(tempCSD)
        temp = tempCSD(pIndex).chCSD;
        Window = [temp.tWave(1), temp.tWave(end)];
        rawWave = changeCellRowNum(excludeTrialsChs(temp.Wave, 0.1));

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

        % rawWave amplitude
        baseWave = cellfun(@(x) findWithinWindow(x, temp.tWave, baseWin), rawWave, "UniformOutput", false);
%         rawWave = cellfun(@(x, y) (x), rawWave, baseWave, "UniformOutput", false);
%         rawWave = cellfun(@(x, y) (x-mean(y, 2))./std(x, 1, 2), rawWave, baseWave, "UniformOutput", false);
        base = cellfun(@(x) rms(findWithinWindow(x, temp.tWave, baseWin), 2), rawWave, "UniformOutput", false);
        rsp = cellfun(@(x) rms(findWithinWindow(x, temp.tWave, rspWin), 2), rawWave, "UniformOutput", false);
        TBI = cellfun(@(x, y) (y-x)./x, base, rsp, "UniformOutput", false);
        [h, p] = cellfun(@(x, y) ttest(x, y), base, rsp, "UniformOutput", false);

        rawWave = cellfun(@(x, y) (x-mean(y, 2))./std(x, 1, 2), rawWave, baseWave, "UniformOutput", false);
        baseCSD = cellfun(@(x) rms(findWithinWindow(x, temp.tWave, baseWin), 2), rawWave, "UniformOutput", false);
        rspCSD = cellfun(@(x) rms(findWithinWindow(x, temp.tWave, rspWin), 2), rawWave, "UniformOutput", false);

        
        meanCSD = cellfun(@mean, rspCSD);
        stdCSD = cell2mat(cellfun(@(x) std(x)/sqrt(length(x)), rspCSD, "UniformOutput", false));
        meanBaseCSD = cellfun(@mean, baseCSD);
        ttestCSD(pIndex).info = tempCSD(pIndex).info;
        ttestCSD(pIndex).rspCSD = rspCSD;
        ttestCSD(pIndex).baseCSD = baseCSD;
        ttestCSD(pIndex).rspMeanCSD = meanCSD;
        ttestCSD(pIndex).rspSECSD = stdCSD;
        ttestCSD(pIndex).baseMeanCSD = meanBaseCSD;
        ttestCSD(pIndex).TBI = TBI;
        ttestCSD(pIndex).TBIMean = cellfun(@mean, TBI);
        ttestCSD(pIndex).TBISE = cell2mat(cellfun(@(x) std(x)/sqrt(length(x)), TBI, "UniformOutput", false));
        ttestCSD(pIndex).h = cell2mat(h);
        ttestCSD(pIndex).p = cell2mat(p);
        ttestCSD(pIndex).SgIndex = SgIndex;
        ttestCSD(pIndex).GrIndex = GrIndex;
        ttestCSD(pIndex).IgIndex = IgIndex;

        % plotCSD smooth
        plotCSD(pIndex).info = tempCSD(pIndex).info;
        plotCSD(pIndex).tWave = temp.tWave';
        plotCSD(pIndex).chWaveSmth{rIndex,1} = meanWaveSmth';
        plotCSD(pIndex).SgWaveSmth(:, rIndex) = mean(meanWaveSmth(SgIndex, :), 1)';
        plotCSD(pIndex).GrWaveSmth(:, rIndex) = mean(meanWaveSmth(GrIndex, :), 1)';
        plotCSD(pIndex).IgWaveSmth(:, rIndex) = mean(meanWaveSmth(IgIndex, :), 1)';
        plotCSD(pIndex).AllWaveSmth(:, rIndex) = mean(meanWaveSmth, 1)';
        plotCSD(pIndex).recordDate(:, rIndex) = string(popRes(rIndex).Date);
    end
    ttestRes(rIndex).CSD = ttestCSD;

    % LFP
    SgIndex = str2double(string(strsplit(string(popConfig(rIndex).Sg), ",")));
    GrIndex = str2double(string(strsplit(string(popConfig(rIndex).Gr), ",")));
    IgIndex = str2double(string(strsplit(string(popConfig(rIndex).Ig), ",")));

    for pIndex = 1 : length(tempLFP)
        temp = tempLFP(pIndex).rawLFP;
        Window = [temp.t(1), temp.t(end)];
        rawWave = changeCellRowNum(excludeTrialsChs(temp.rawWave, 0.1));
        % rawWave smooth
        rawWaveSmth = cellfun(@(x) smoothdata(x', "gaussian", 15)', rawWave, "UniformOutput", false);
        if exist("excludeTrial", "var")
            excludeIdx = find(matches({excludeTrial.Date}', popRes(rIndex).Date));
            if ~isempty(excludeIdx) &&  pIndex == excludeTrial(excludeIdx).Prot
                rawWaveSmth = cellfun(@(x) x(~ismember(1:size(rawWaveSmth{1}, 1), excludeTrial(excludeIdx).Trial), :), rawWaveSmth, "UniformOutput", false);
            end
        end
        baseWaveSmth = cellfun(@(x) findWithinWindow(x, temp.t, baseWin), rawWaveSmth, "UniformOutput", false);
        rawWaveSmth = cellfun(@(x, y) (x-mean(y, 2))./std(y,1,2), rawWaveSmth, baseWaveSmth, "UniformOutput", false);
        meanWaveSmth = cell2mat(cellfun(@(x) mean(x, 1), rawWaveSmth,  "UniformOutput", false));

        % rawWave amplitude
        baseWave = cellfun(@(x) findWithinWindow(x, temp.t, baseWin), rawWave, "UniformOutput", false);
%         rawWave = cellfun(@(x, y) (x), rawWave, baseWave, "UniformOutput", false);
%         rawWave = cellfun(@(x, y) (x-mean(y, 2))./std(x, 1, 2), rawWave, baseWave, "UniformOutput", false);
        base = cellfun(@(x) rms(findWithinWindow(x, temp.t, baseWin), 2), rawWave, "UniformOutput", false);
        rsp = cellfun(@(x) rms(findWithinWindow(x, temp.t, rspWin), 2), rawWave, "UniformOutput", false);
        TBI = cellfun(@(x, y) (y-x)./x, base, rsp, "UniformOutput", false);
        [h, p] = cellfun(@(x, y) ttest(x, y), base, rsp, "UniformOutput", false);

        rawWave = cellfun(@(x, y) (x-mean(y, 2))./std(x, 1, 2), rawWave, baseWave, "UniformOutput", false);
        baseLFP = cellfun(@(x) rms(findWithinWindow(x, temp.t, baseWin), 2), rawWave, "UniformOutput", false);
        rspLFP = cellfun(@(x) rms(findWithinWindow(x, temp.t, rspWin), 2), rawWave, "UniformOutput", false);
        
        
        meanLFP = cellfun(@mean, rspLFP);
        stdLFP = cell2mat(cellfun(@(x) std(x)/sqrt(length(x)), rspLFP, "UniformOutput", false));
        meanBaseLFP = cellfun(@mean, baseLFP);
        ttestLFP(pIndex).info = tempLFP(pIndex).info;
        ttestLFP(pIndex).rspLFP = rspLFP;
        ttestLFP(pIndex).baseLFP = baseLFP;
        ttestLFP(pIndex).rspMeanLFP = meanLFP;
        ttestLFP(pIndex).rspSELFP = stdLFP;
        ttestLFP(pIndex).baseMeanLFP = meanBaseLFP;
        ttestLFP(pIndex).TBI = TBI;
        ttestLFP(pIndex).TBIMean = cellfun(@mean, TBI);
        ttestLFP(pIndex).TBISE = cell2mat(cellfun(@(x) std(x)/sqrt(length(x)), TBI, "UniformOutput", false));
        ttestLFP(pIndex).h = cell2mat(h);
        ttestLFP(pIndex).p = cell2mat(p);
        ttestLFP(pIndex).SgIndex = SgIndex;
        ttestLFP(pIndex).GrIndex = GrIndex;
        ttestLFP(pIndex).IgIndex = IgIndex;

        % plotLFP smooth
        plotLFP(pIndex).info = tempLFP(pIndex).info;
        plotLFP(pIndex).t = temp.t';
        plotLFP(pIndex).chWaveSmth{rIndex,1} = meanWaveSmth';
        plotLFP(pIndex).SgWaveSmth(:, rIndex) = mean(meanWaveSmth(SgIndex, :), 1)';
        plotLFP(pIndex).GrWaveSmth(:, rIndex) = mean(meanWaveSmth(GrIndex, :), 1)';
        plotLFP(pIndex).IgWaveSmth(:, rIndex) = mean(meanWaveSmth(IgIndex, :), 1)';
        plotLFP(pIndex).AllWaveSmth(:, rIndex) = mean(meanWaveSmth, 1)';
        plotLFP(pIndex).recordDate(:, rIndex) = string(popRes(rIndex).Date);

    end
     ttestRes(rIndex).LFP = ttestLFP;
end



%% pooled response and mean wave
for pIndex = 1 : length(plotMUA)
    plotMUA(pIndex).SgMeanSmth = [mean(plotMUA(pIndex).SgWaveSmth, 2), std(plotMUA(pIndex).SgWaveSmth, 1, 2)/sqrt(size(plotMUA(pIndex).SgWaveSmth, 2))];

    plotMUA(pIndex).GrMeanSmth = [mean(plotMUA(pIndex).GrWaveSmth, 2), std(plotMUA(pIndex).GrWaveSmth, 1, 2)/sqrt(size(plotMUA(pIndex).GrWaveSmth, 2))];

    plotMUA(pIndex).IgMeanSmth = [mean(plotMUA(pIndex).IgWaveSmth, 2), std(plotMUA(pIndex).IgWaveSmth, 1, 2)/sqrt(size(plotMUA(pIndex).IgWaveSmth, 2))];

    plotMUA(pIndex).AllMeanSmth = [mean(plotMUA(pIndex).AllWaveSmth, 2), std(plotMUA(pIndex).AllWaveSmth, 1, 2)/sqrt(size(plotMUA(pIndex).AllWaveSmth, 2))];
end
for pIndex = 1 : length(plotCSD)
    plotCSD(pIndex).SgMeanSmth = [mean(plotCSD(pIndex).SgWaveSmth, 2), std(plotCSD(pIndex).SgWaveSmth, 1, 2)/sqrt(size(plotCSD(pIndex).SgWaveSmth, 2))];

    plotCSD(pIndex).GrMeanSmth = [mean(plotCSD(pIndex).GrWaveSmth, 2), std(plotCSD(pIndex).GrWaveSmth, 1, 2)/sqrt(size(plotCSD(pIndex).GrWaveSmth, 2))];

    plotCSD(pIndex).IgMeanSmth = [mean(plotCSD(pIndex).IgWaveSmth, 2), std(plotCSD(pIndex).IgWaveSmth, 1, 2)/sqrt(size(plotCSD(pIndex).IgWaveSmth, 2))];

    plotCSD(pIndex).AllMeanSmth = [mean(plotCSD(pIndex).AllWaveSmth, 2), std(plotCSD(pIndex).AllWaveSmth, 1, 2)/sqrt(size(plotCSD(pIndex).AllWaveSmth, 2))];
end
for pIndex = 1 : length(plotLFP)
    plotLFP(pIndex).SgMeanSmth = [mean(plotLFP(pIndex).SgWaveSmth, 2), std(plotLFP(pIndex).SgWaveSmth, 1, 2)/sqrt(size(plotLFP(pIndex).SgWaveSmth, 2))];

    plotLFP(pIndex).GrMeanSmth = [mean(plotLFP(pIndex).GrWaveSmth, 2), std(plotLFP(pIndex).GrWaveSmth, 1, 2)/sqrt(size(plotLFP(pIndex).GrWaveSmth, 2))];

    plotLFP(pIndex).IgMeanSmth = [mean(plotLFP(pIndex).IgWaveSmth, 2), std(plotLFP(pIndex).IgWaveSmth, 1, 2)/sqrt(size(plotLFP(pIndex).IgWaveSmth, 2))];

    plotLFP(pIndex).AllMeanSmth = [mean(plotLFP(pIndex).AllWaveSmth, 2), std(plotLFP(pIndex).AllWaveSmth, 1, 2)/sqrt(size(plotLFP(pIndex).AllWaveSmth, 2))];
end