%% settings
% replaceFig: set 1 if you want to replace old same-name figures; if you don't want to plot processed figures again, set it as 0;
% badCh & blockPaths: you can easily add a new string/vector for any new data to process, since previous data will be skipped if replaceFig is set 0
% 
clear all

% savepath='G:\Monkey_LA\CSD_Result\DDZ'; % floor 4 left
savepath='G:\Monkey_LA\CSD_Result\DD'; % floor 4 left

%% TO SET
% blockPaths = {'G:\DATA\DDZ\ddz20221028\Block-1'};
blockPaths = {'G:\DATA\DD\dd20221124\Block-6'};
% blockPaths = {'D:\DATA\spr\ddz\ddz20220326\Block-12'};

badCh = {[9]};
replaceFig = 1;
isOdd = 1;
tradMethods = {'three point'};
chSelect = 1:1:16;
saveName = '';


%% 
date = regexpi(blockPaths,'\d{3,}','match');
blockName = regexpi(blockPaths,'Block-\d+','match');
sound_type=cell(length(blockPaths),1);
sound_type(:,1)= cellstr('Tone_4437_2s');


for methodN = 1:length(tradMethods)
    clear data MUA waveBuffer mT T MUA_Trial lfp_trial
    tradMethod = tradMethods{methodN};
savefolder = check_mkdir_SPR(savepath,tradMethod);
cd(savefolder)
files = dir('*.jpg');
fileNames = {files.name};

for bN = 1:length(blockPaths)
if ~replaceFig && any(~cellfun(@isempty,regexpi(fileNames,['.*' date{bN}{1} '.*' blockName{bN}{1} '.*' ])))
    continue
end
path = blockPaths{bN};
saveStr = [saveName  date{bN}{1}];
data=TDTbin2mat(path);%C:\TDT\OpenEx\Tanks\gym\gym20190626
sweeptimes=length(data.epocs.Swep);

analyse_win=[0 0.15];
depth=34679;
lfp_raw=data.streams.Llfp.data*10^6;
lfp_raw = lfp_raw(chSelect,:);

%% SpkPSTH setting
clear SpkPsth
SpkPsth.binsize = 30;
SpkPsth.binstep = 1;
intervalCh = 1;
for ch = 1:intervalCh:(length(chSelect)-intervalCh+1)
spikesBuffer = data.snips.eNeu.ts;
onsetBuffer = data.epocs.Swep.onset;
offsetBuffer = data.epocs.Swep.offset;
for swepN = 1:length(onsetBuffer)
   spikesBuffer(spikesBuffer>onsetBuffer(swepN) & spikesBuffer<offsetBuffer(swepN)) = spikesBuffer(spikesBuffer>onsetBuffer(swepN) & spikesBuffer<offsetBuffer(swepN)) - onsetBuffer(swepN);
end
chBuffer = double(data.snips.eNeu.chan);
spikesRaw{ch} = spikesBuffer(ismember(chBuffer,[ch:ch+intervalCh-1]))*1000;
buffer = calPsth(spikesRaw{ch},SpkPsth,1000/SpkPsth.binsize,'Edge',[0 150]-SpkPsth.binsize/2,'Edgemismatch',false);
SpkPsth.res{ch} =  [buffer.y]'/swepN;
SpkPsth.T{ch} =  [buffer.edges]';
end


%% MUA
waveBuffer = (double(data.streams.Wave.data)).^2;
MUAfs = 2001;
d = designfilt('lowpassfir','PassbandFrequency',100, ...
    'StopbandFrequency',120,'PassbandRipple',0.8, ...
    'StopbandAttenuation',60,'SampleRate',500);
MUA = sqrt(waveBuffer);
for chN = 1:size(waveBuffer,1)
MUA(chN,:) = filtfilt(d,waveBuffer(chN,:));
end


% lfp_raw(8,:)=[];
for badN = 1:length(badCh{bN})
    lfp_raw(badCh{bN}(badN),:) = mean(lfp_raw([badCh{bN}(badN)-1 badCh{bN}(badN)+1],:));
end
fs=data.streams.Llfp.fs;
T=(0:1:length(lfp_raw)-1)/fs;
mT = (0:1:length(MUA)-1)/MUAfs;
dz=150;
%LFP
lfp_all=[];
% stimBuffer = data.epocs.Stim.onset;
stimBuffer = data.epocs.Swep.onset;
sampleN = 10*floor((analyse_win(2)-analyse_win(1))*fs/10);
for i=1:length(stimBuffer)-1
    swep_on=stimBuffer(i);
    select_index=(T>=swep_on&T<=swep_on+analyse_win(2));
    tt=T(select_index);
    tt = tt(1:sampleN);
    buffer = double(lfp_raw(:,select_index));
    lfp_trial{i} = buffer(:,1:sampleN);
    if i==1
        lfp_all=lfp_trial{i};
    else
        lfp_all=lfp_all+lfp_trial{i};
    end
end
lfp_mean=lfp_all/i;
% lfp_mean = flipud(lfp_mean);
tt=tt-tt(1);

%MUA
MUA_all=[];
% stimBuffer = data.epocs.Stim.onset;
stimBuffer = data.epocs.Swep.onset;
MUAsampleN = 10*floor((analyse_win(2)-analyse_win(1))*MUAfs/10);
for i=1:length(stimBuffer)-1
    swep_on=stimBuffer(i);
    select_index=(mT>=swep_on&mT<=swep_on+analyse_win(2));
    mtt=mT(select_index);
    mtt = mtt(1:MUAsampleN);
    buffer = double(MUA(:,select_index));
    MUA_trial{i} = buffer(:,1:MUAsampleN);
    if i==1
        MUA_all=MUA_trial{i};
    else
        MUA_all=MUA_all+MUA_trial{i};
    end
end
MUA_mean = MUA_all/i;
mtt = mtt - mtt(1);

cd(path);
saved_data=['example_dataset' blockName{bN}{1} '.mat'];

save(saved_data, 'dz', 'fs' , 'tt', 'depth','lfp_mean','lfp_trial',...
     'MUAfs' , 'mtt','MUA_mean','MUA_trial','tradMethod');

h=CSD_construction(saved_data,'SpkPsth',SpkPsth,'MUA',MUA);
set(gcf,'outerposition',get(0,'screensize'));

Img=getframe(h);

    imwrite(Img.cdata,[savefolder '\'  saveStr  '_' blockName{bN}{1} '_' sound_type{bN} '.jpg']);
    close
end
end
