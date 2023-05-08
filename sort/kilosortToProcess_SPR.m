close all; clc; clear;
% TANKPATHs = {'G:\ECoG\CM\cm20230322'; 'G:\ECoG\CM\cm20230323'; 'G:\ECoG\CM\cm20230324'; 'G:\ECoG\CM\cm20230327'; ...
%     'G:\ECoG\CM\cm20230328'; 'G:\ECoG\CM\cm20230329'; 'G:\ECoG\CM\cm20230330'; 'G:\ECoG\CM\cm20230401'; ...
%     'G:\ECoG\CM\cm20230402'; 'G:\ECoG\CM\cm20230403'; 'G:\ECoG\CM\cm20230404'; 'G:\ECoG\CM\cm20230405'};
% BLOCKNUMs = {[8:25], [6:23], [2:20], [2:20], ...
%     [2:20], [4:22], [3:22], [2:20], ...
%     [1:20], [2:20], [1:19], [2:20]};

TANKPATHs = {'G:\ECoG\CM\cm20230406'};
BLOCKNUMs = {[2:20]};
for tIndex = 1:length(TANKPATHs)
%% generate .bin file
TANKPATH = TANKPATHs{tIndex};  %tank路径
MergeFolder = 'Merge1'; %在tank路径下生成Merge1文件夹，存放ks结果
BLOCKNUM = num2cell(BLOCKNUMs{tIndex}); %选择要sort的block number
Block = 'Block-1';
BLOCKPATH = cellfun(@(x) fullfile(TANKPATH,['Block-' num2str(x)]),BLOCKNUM,'UniformOutput',false);
MERGEPATH = fullfile(TANKPATH,MergeFolder);


% data = TDTbin2mat(fullfile(TANKPATH,Block),'TYPE' ,{'EPOCS'});
% display(['the first sound of ' Block ' is: '  num2str(data.epocs.ordr.onset(1))]);

binPath = [MERGEPATH '\Wave.bin']; 
if ~exist(binPath,'file')
    TDT2binMerge(BLOCKPATH,MergeFolder);
end



%% kilosort
run('config\configFileRat.m');
% treated as linear probe if no chanMap file
ops.chanMap = 'config\chan16_1_kilosortChanMap.mat';
% total number of channels in your recording
ops.NchanTOT = 16;
% sample rate, Hz 
ops.fs = 12207.03125;
for th2 = [6 ]
    ops.Th = [7 th2];
    savePath = fullfile(MERGEPATH, ['th', num2str(ops.Th(1))  , '_', num2str(ops.Th(2))]);
    if ~exist([savePath '\params.py'])
        mKilosort(binPath, ops, savePath);
    end
%     display(['the first sound of ' Block ' is: '  num2str(data.epocs.ordr.onset(1))]);
    %     system('phy template-gui params.py');
end
end