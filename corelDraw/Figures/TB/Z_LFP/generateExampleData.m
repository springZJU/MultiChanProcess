dateCode = find(matches({popRes.Date}', selDate));

layerIdx = ["SgIndex", "GrIndex", "IgIndex"];
for sIndex = 1 : length(idx)
% CSD
temp = ttestRes(dateCode).CSD(idx(sIndex));
for lIndex = 1 : 3
rspRaw(sIndex).info = plotCSD(idx(sIndex)).info;
rspRaw(sIndex).CSD(lIndex).layer = layers(lIndex);
rspRaw(sIndex).CSD(lIndex).rspAll = cell2mat(temp.rspCSD(temp.(layerIdx(lIndex))));
rspRaw(sIndex).CSD(lIndex).mean = mean(rspRaw(sIndex).CSD(lIndex).rspAll);
rspRaw(sIndex).CSD(lIndex).SE = std(rspRaw(sIndex).CSD(lIndex).rspAll)/sqrt(length(rspRaw(sIndex).CSD(lIndex).rspAll));
end

% MUA
temp = ttestRes(dateCode).MUA(idx(sIndex));
for lIndex = 1 : 3
rspRaw(sIndex).info = plotMUA(idx(sIndex)).info;
rspRaw(sIndex).MUA(lIndex).layer = layers(lIndex);
rspRaw(sIndex).MUA(lIndex).rspAll = cell2mat(temp.rspMUA(temp.(layerIdx(lIndex))));
rspRaw(sIndex).MUA(lIndex).mean = mean(rspRaw(sIndex).MUA(lIndex).rspAll);
rspRaw(sIndex).MUA(lIndex).SE = std(rspRaw(sIndex).MUA(lIndex).rspAll)/sqrt(length(rspRaw(sIndex).MUA(lIndex).rspAll));
end

% LFP
temp = ttestRes(dateCode).LFP(idx(sIndex));
for lIndex = 1 : 3
rspRaw(sIndex).info = plotLFP(idx(sIndex)).info;
rspRaw(sIndex).LFP(lIndex).layer = layers(lIndex);
rspRaw(sIndex).LFP(lIndex).rspAll = cell2mat(temp.rspLFP(temp.(layerIdx(lIndex))));
rspRaw(sIndex).LFP(lIndex).mean = mean(rspRaw(sIndex).LFP(lIndex).rspAll);
rspRaw(sIndex).LFP(lIndex).SE = std(rspRaw(sIndex).LFP(lIndex).rspAll)/sqrt(length(rspRaw(sIndex).LFP(lIndex).rspAll));
end
end

%% TBI

for sIndex = 1 : length(idx)
% CSD
temp = ttestRes(dateCode).CSD(idx(sIndex));
for lIndex = 1 : 3
TBIRaw(sIndex).info = plotCSD(idx(sIndex)).info;
TBIRaw(sIndex).CSD(lIndex).layer = layers(lIndex);
TBIRaw(sIndex).CSD(lIndex).TBIAll = cell2mat(temp.TBI(temp.(layerIdx(lIndex))));
TBIRaw(sIndex).CSD(lIndex).mean = mean(TBIRaw(sIndex).CSD(lIndex).TBIAll);
TBIRaw(sIndex).CSD(lIndex).SE = std(TBIRaw(sIndex).CSD(lIndex).TBIAll)/sqrt(length(TBIRaw(sIndex).CSD(lIndex).TBIAll));
end

% MUA
temp = ttestRes(dateCode).MUA(idx(sIndex));
for lIndex = 1 : 3
TBIRaw(sIndex).info = plotMUA(idx(sIndex)).info;
TBIRaw(sIndex).MUA(lIndex).layer = layers(lIndex);
TBIRaw(sIndex).MUA(lIndex).TBIAll = cell2mat(temp.TBI(temp.(layerIdx(lIndex))));
TBIRaw(sIndex).MUA(lIndex).mean = mean(TBIRaw(sIndex).MUA(lIndex).TBIAll);
TBIRaw(sIndex).MUA(lIndex).SE = std(TBIRaw(sIndex).MUA(lIndex).TBIAll)/sqrt(length(TBIRaw(sIndex).MUA(lIndex).TBIAll));
end

% LFP
temp = ttestRes(dateCode).LFP(idx(sIndex));
for lIndex = 1 : 3
TBIRaw(sIndex).info = plotLFP(idx(sIndex)).info;
TBIRaw(sIndex).LFP(lIndex).layer = layers(lIndex);
TBIRaw(sIndex).LFP(lIndex).TBIAll = cell2mat(temp.TBI(temp.(layerIdx(lIndex))));
TBIRaw(sIndex).LFP(lIndex).mean = mean(TBIRaw(sIndex).LFP(lIndex).TBIAll);
TBIRaw(sIndex).LFP(lIndex).SE = std(TBIRaw(sIndex).LFP(lIndex).TBIAll)/sqrt(length(TBIRaw(sIndex).LFP(lIndex).TBIAll));
end
end
    

%% ttest between groups by layers
for lIndex = 1 : 3
    % LFP
    for sIndex = 1 : length(idx)
%         temp = double(rspRaw(sIndex).LFP(lIndex).rspAll);
        temp = double(TBIRaw(sIndex).LFP(lIndex).TBIAll);
        buffer{sIndex, 1} = [temp, ones(length(temp), 1)*sIndex];
    end
    anovaBuffer = cell2mat(buffer);
    stimP.layers.LFP(lIndex, 1) = anova1(anovaBuffer(:, 1), anovaBuffer(:, 2), "off");

    % CSD
    for sIndex = 1 : length(idx)
%         temp = double(rspRaw(sIndex).CSD(lIndex).rspAll);
        temp = double(TBIRaw(sIndex).CSD(lIndex).TBIAll);
        buffer{sIndex, 1} = [temp, ones(length(temp), 1)*sIndex];
    end
    anovaBuffer = cell2mat(buffer);
    stimP.layers.CSD(lIndex, 1) = anova1(anovaBuffer(:, 1), anovaBuffer(:, 2), "off");

    % MUA
    for sIndex = 1 : length(idx)
%         temp = double(rspRaw(sIndex).MUA(lIndex).rspAll);
        temp = double(TBIRaw(sIndex).MUA(lIndex).TBIAll);
        buffer{sIndex, 1} = [temp, ones(length(temp), 1)*sIndex];
    end
    anovaBuffer = cell2mat(buffer);
    stimP.layers.MUA(lIndex, 1) = anova1(anovaBuffer(:, 1), anovaBuffer(:, 2), "off");

end

%% ttest between groups by channels
% LFP
for cIndex = 1 : length(ttestRes(1).LFP(1).rspLFP) 
for sIndex = 1 : length(idx)
%     temp = double(ttestRes(dateCode).LFP(idx(sIndex)).rspLFP{cIndex,1 });
    temp = double(ttestRes(dateCode).LFP(idx(sIndex)).TBI{cIndex,1 });
    buffer{sIndex, 1} = [temp, ones(length(temp), 1)*sIndex];
end
anovaBuffer = cell2mat(buffer);
stimP.chs.LFP(cIndex, 1) = anova1(anovaBuffer(:, 1), anovaBuffer(:, 2), "off");
end

% CSD
for cIndex = 1 : length(ttestRes(1).CSD(1).rspCSD) 
for sIndex = 1 : length(idx)
%     temp = double(ttestRes(dateCode).CSD(idx(sIndex)).rspCSD{cIndex,1 });
    temp = double(ttestRes(dateCode).CSD(idx(sIndex)).TBI{cIndex,1 });
    buffer{sIndex, 1} = [temp, ones(length(temp), 1)*sIndex];
end
anovaBuffer = cell2mat(buffer);
stimP.chs.CSD(cIndex, 1) = anova1(anovaBuffer(:, 1), anovaBuffer(:, 2), "off");
end

% MUA
for cIndex = 1 : length(ttestRes(1).MUA(1).rspMUA) 
for sIndex = 1 : length(idx)
%     temp = double(ttestRes(dateCode).MUA(idx(sIndex)).rspMUA{cIndex,1 });
    temp = double(ttestRes(dateCode).MUA(idx(sIndex)).TBI{cIndex,1 });
    buffer{sIndex, 1} = [temp, ones(length(temp), 1)*sIndex];
end
anovaBuffer = cell2mat(buffer);
stimP.chs.MUA(cIndex, 1) = anova1(anovaBuffer(:, 1), anovaBuffer(:, 2), "off");
end
%% ttest between layers
for sIndex = 1 : length(idx)
    pLayer(sIndex).info = plotLFP(idx(sIndex)).info;
    % LFP
    [~, pLayer(sIndex).LFPSgGr] = ttest2(double(rspRaw(sIndex).LFP(1).rspAll), double(rspRaw(sIndex).LFP(2).rspAll));
    [~, pLayer(sIndex).LFPGrIg] = ttest2(double(rspRaw(sIndex).LFP(2).rspAll), double(rspRaw(sIndex).LFP(3).rspAll));
    [~, pLayer(sIndex).LFPSgIg] = ttest2(double(rspRaw(sIndex).LFP(1).rspAll), double(rspRaw(sIndex).LFP(3).rspAll));
    % MUA
    [~, pLayer(sIndex).MUASgGr] = ttest2(double(rspRaw(sIndex).MUA(1).rspAll), double(rspRaw(sIndex).MUA(2).rspAll));
    [~, pLayer(sIndex).MUAGrIg] = ttest2(double(rspRaw(sIndex).MUA(2).rspAll), double(rspRaw(sIndex).MUA(3).rspAll));
    [~, pLayer(sIndex).MUASgIg] = ttest2(double(rspRaw(sIndex).MUA(1).rspAll), double(rspRaw(sIndex).MUA(3).rspAll));
    % CSD
    [~, pLayer(sIndex).CSDSgGr] = ttest2(double(rspRaw(sIndex).CSD(1).rspAll), double(rspRaw(sIndex).CSD(2).rspAll));
    [~, pLayer(sIndex).CSDGrIg] = ttest2(double(rspRaw(sIndex).CSD(2).rspAll), double(rspRaw(sIndex).CSD(3).rspAll));
    [~, pLayer(sIndex).CSDSgIg] = ttest2(double(rspRaw(sIndex).CSD(1).rspAll), double(rspRaw(sIndex).CSD(3).rspAll));
end