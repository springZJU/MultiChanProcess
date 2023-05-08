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
tempCSD = popRes(2).chCSD;  %20221216
tempMUA = popRes(2).chMUA;  %20221216
% CSD
for pIndex = 1 : length(tempCSD)
    temp = tempCSD(pIndex).chCSD;
    Window = [temp.tWave(pIndex), temp.tWave(end)];
    meanWave = cell2mat(cellfun(@(x) mean(x, 1), changeCellRowNum(temp.Wave), "UniformOutput", false));
    imageCSD = interp2(meanWave, 3);
    imageCSD = imageCSD(:, 1:4:end);
    plotCSD(pIndex).info = tempCSD(pIndex).info;
    plotCSD(pIndex).tWave = temp.tWave;
    plotCSD(pIndex).Wave = meanWave;
    plotCSD(pIndex).tImage = linspace(Window(1), Window(2), size(imageCSD, 2));
    plotCSD(pIndex).image = imageCSD;
end

% MUA
for pIndex = 1 : length(tempMUA)
    temp = tempMUA(pIndex).chMUA;
    Window = [temp.tWave(pIndex), temp.tWave(end)];
    rawWave = temp.rawWave;
    rawWave = cellfun(@(x) x-mean(findWithinWindow(x, temp.tWave, baseWin), 2), rawWave, "UniformOutput", false);
    meanWave = cell2mat(cellfun(@(x) mean(x, 1), rawWave,  "UniformOutput", false));
    imageMUA = interp2(meanWave, 3);
    imageMUA = imageMUA(:, 1:4:end);
    plotMUA(pIndex).info = tempMUA(pIndex).info;
    plotMUA(pIndex).tWave = temp.tWave(1:4:end);
    plotMUA(pIndex).Wave = meanWave(1:4:end);
    plotMUA(pIndex).tImage = linspace(Window(1), Window(2), size(imageMUA, 2));
    plotMUA(pIndex).image = imageMUA;
end
%% plot figures
stimCode = [1:5, 7,8];
Fig = figure;
maximizeFig(Fig);
% raw
for dIndex = 1 : length(stimCode)
    % plot CSD
    AxesCSD(dIndex) = mSubplot(Fig, 2, length(stimCode), dIndex, [1, 1]);
    CData = flipud(plotCSD(stimCode(dIndex)).image);
    tImage = plotCSD(stimCode(dIndex)).tImage;
    imagesc('XData', tImage, 'CData', CData);
    colormap(AxesCSD(dIndex), "jet");
    ylim([1, size(CData, 1)]);
    xlim(plotWin);
    if dIndex == 1
        yTick = linspace(1, size(CData, 1), 14);
        set(AxesCSD(dIndex), "ytick", yTick);
        set(AxesCSD(dIndex), "yticklabel", string(num2cell(flip(2:15))'));
    else
        set(AxesCSD(dIndex), "yticklabel", "");
    end

    % plot MUA
    AxesMUA(dIndex) = mSubplot(Fig, 2, length(stimCode), length(stimCode)+dIndex, [1, 1]);
    CData = flipud(plotMUA(stimCode(dIndex)).image);
    tImage = plotMUA(stimCode(dIndex)).tImage;
    imagesc('XData', tImage, 'CData', CData);
    colormap(AxesMUA(dIndex), "hot");
    ylim([1, size(CData, 1)]);
    xlim(plotWin);
    if dIndex == 1
        yTick = linspace(1, size(CData, 1), 16);
        set(AxesMUA(dIndex), "ytick", yTick);
        set(AxesMUA(dIndex), "yticklabel", string(num2cell(flip(1:16))'));
    else
        set(AxesMUA(dIndex), "yticklabel", "");
    end
end

% % plot diff CSD
% AxesCSD(length(stimCode)+1) = mSubplot(Fig, 2, length(stimCode)+1, length(stimCode)+1, [1, 1]);
% CData = flipud(plotCSD(stimCode(1)).image - plotCSD(stimCode(2)).image);
% tImage = plotCSD(stimCode(dIndex)).tImage;
% imagesc('XData', tImage, 'CData', CData);
% colormap(AxesCSD(length(stimCode)+1), "jet");
% ylim([1, size(CData, 1)]);
% xlim(plotWin);
% yticklabels("");
% 
% % plot diff MUA
% AxesMUA(length(stimCode)+1) = mSubplot(Fig, 2, length(stimCode)+1, 2*(length(stimCode)+1), [1, 1]);
% CData = flipud(plotMUA(stimCode(1)).image - plotMUA(stimCode(2)).image);
% tImage = plotMUA(stimCode(dIndex)).tImage;
% imagesc('XData', tImage, 'CData', CData);
% colormap(AxesMUA(length(stimCode)+1), "hot");
% ylim([1, size(CData, 1)]);
% xlim(plotWin);
% yticklabels("");

% scale axes
cScaleCSD = 2*scaleAxes(AxesCSD, "c", "on", "symOpts", "max");
scaleAxes(AxesCSD, "c", cScaleCSD);
cScaleMUA = 2*scaleAxes(AxesMUA, "c", "on");
scaleAxes(AxesMUA, "c", [0, cScaleMUA(2)]);

% add vertical line
lines(1).X = 0;
lines(1).width = 1.5;
lines(1).color = "black";
addLines2Axes(AxesCSD, lines);

lines(1).color = "white";
addLines2Axes(AxesMUA, lines);


FIGNAME = strcat(SAVEPATH, "\Figure1_Oscillation");
print(Fig, FIGNAME, "-djpeg", "-r300");
close all;

%% mean CSD and MUA

