clear; clc
% TANKPATH = 'G:\ECoG\DDZ\ddz20221227';
% TANKPATH = 'G:\ECoG\DD\dd20221130';
TANKPATH = 'G:\ECoG\CM\cm20230406';

%% 
MERGEPATH = check_mkdir(TANKPATH,'Merge1'); 
load (fullfile(MERGEPATH,'mergePara.mat'));
chAll = 16;
fs = 12207.031250;

NPYPATH = fullfile(MERGEPATH, 'th7_6'); % the path including ks_result
ch = [9, 11, 12, 13, 1013]; % channels index of kilosort, that means chKs = chTDT - 1;
idx = [7, 9, 8, 11, 10]; % t he corresponding id


kiloSpikeAll = cell(max([chAll ch]),1);

[spikeIdx, clusterIdx, templates, spikeTemplateIdx] = parseNPY(NPYPATH);

nTemplates = size(templates, 1);
%% Plot template
Fig = figure;
maximizeFig(Fig);
plotIdx = 0;
for chN = 1:length(ch)
    kiloClusters = idx(chN);
    kiloSpikeTimeIdx = [];
    for index = 1:length(kiloClusters)
        kiloSpikeTimeIdx = [kiloSpikeTimeIdx; spikeIdx(clusterIdx == kiloClusters(index))];
        plotIdx = plotIdx + 1; 
        subplot(8, ceil(nTemplates / 8), plotIdx);
        plot(templates(kiloClusters(index)+1, :, mod(ch(chN),200)+1));
        xticklabels('');
        yticklabels('');
        title(['Ch' num2str(ch(chN)+1) 'Idx' num2str(kiloClusters(index))]);
    end

    %     kiloSpikeTimeIdx = kiloSpikeTimeIdx(kiloSpikeTimeIdx <= max(t) * fs);
    kiloSpikeTime = double(kiloSpikeTimeIdx - 1) / fs;
    kiloSpikeAll{ch(chN)+1} = [kiloSpikeTime ch(chN)*ones(length(kiloSpikeTime),1)];
end
saveas(Fig,[NPYPATH  '\cluster templates.jpg']);
save([NPYPATH, '\selectCh.mat'], 'ch', 'idx', '-mat');

%% split sort data into different blocks
T = cellfun(@sum,waveLength);

for blks = 1:length(BLOCKPATH)
    if blks == length(BLOCKPATH)
        t = [sum(T(1:blks-1)) inf];
    else
        t = [sum(T(1:blks-1)) sum(T(1:blks))];
    end
sortdataBuffer = cell2mat(kiloSpikeAll);
[~,selectIdx] = findWithinInterval(sortdataBuffer(:,1),t);
sortdata = sortdataBuffer(selectIdx,:);
sortdata(:,1) = sortdata(:,1) - t(1);

onsetIdx = ceil(t(1) * fs);
wfWin = [-30, 30];
IDandCHANNEL = [idx; zeros(1, length(idx)); mod(ch, 1000)]';
disp(strcat("Processing blocks (", num2str(blks), "/", num2str(length(BLOCKPATH)), ") ..."));
spkWave = getWaveForm_singleID_v2(fs, BLOCKPATH{blks}, NPYPATH, idx, IDandCHANNEL, wfWin, onsetIdx);
save([BLOCKPATH{blks} '\sortdata.mat'], 'sortdata', 'spkWave');
end


%% update recording excel
[mPath,mName]=fileparts(mfilename('fullpath'));
cd(mPath);
if contains(TANKPATH, "DDZ")
    recordPath = "..\utils\MLA_New_DDZ_Recording.xlsx";
elseif contains(TANKPATH, "DD")
    recordPath = "..\utils\MLA_New_DD_Recording.xlsx";
elseif contains(TANKPATH, "CM")
    recordPath = "..\utils\MLA_New_CM_Recording.xlsx";
end
recordInfo = table2struct(readtable(recordPath));
changeIdx = find(matches({recordInfo.BLOCKPATH}', BLOCKPATH'));
for i = changeIdx'
    recordInfo(i).sort = 1;
    recordInfo(i).ks_ChSel = strjoin(string(ch), ",");
    recordInfo(i).ks_ID = strjoin(string(idx), ",");
end
writetable(struct2table(recordInfo), recordPath);



function [resVal,idx] = findWithinInterval(value,range)
    idx = find(value>range(1) & value<range(2));
    resVal = value(idx);
end
