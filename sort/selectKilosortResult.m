clear; clc

TANKPATH = 'G:\ECoG\DDZ\ddz20221021';
% Block = 'Block-6';
% data = TDTbin2mat(fullfile(TANKPATH,Block),'TYPE',{'EPOCS'});
% display(['the first sound of ' Block 'is: '  num2str(data.epocs.ordr.onset(1))]);

%% 
MERGEPATH = check_mkdir(TANKPATH,'Merge1');
load (fullfile(MERGEPATH,'mergePara.mat'));
chAll = 16;
fs = 12207.031250;

savePath = fullfile(MERGEPATH, 'th7_6');
ch = [1	2	3	4	6	7	207	8 8	9	10	11	13	14] ; % channels index of kilosort, that means chKs = chTDT - 1;
idx = {1	0	2	3	6	5	7	4 9	10	8	11	12	13};
kiloSpikeAll = cell(max([chAll ch]),1);
NPYPATH = savePath;

[spikeIdx, clusterIdx, templates, spikeTemplateIdx] = parseNPY(NPYPATH);

nTemplates = size(templates, 1);
%% Plot template
Fig = figure;
maximizeFig(Fig);
plotIdx = 0;
for chN = 1:length(ch)
%     kiloClusters = input(['Input clusters of channel ', num2str(chN), ': ']);
    kiloClusters = idx{chN};

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
saveas(Fig,[savePath  '\cluster templates.jpg']);
save([savePath, '\selectCh.mat'], 'ch', 'idx', '-mat');

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
save([BLOCKPATH{blks} '\sortdata.mat'], 'sortdata');
end


%% update recording excel
[mPath,mName]=fileparts(mfilename('fullpath'));
cd(mPath);
recordPath = "..\utils\LinearArrayRecording.xlsx";
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
