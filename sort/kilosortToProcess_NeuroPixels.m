close all; clc; clear;
cd(fileparts(mfilename("fullpath")));
%% kilosort
DATAPATH = "G:\OpenEphys\001_2023-03-22_11-13-29\Record Node 117\experiment1\recording1\continuous\Neuropix-PXI-122.ProbeA-AP";
binFile = strcat(DATAPATH, "\continuous.dat");
run('config\configFile385.m');
% treated as linear probe if no chanMap file
ops.chanMap = 'config\neuropix385_kilosortChanMap.mat';
% total number of channels in your recording
ops.NchanTOT = 385; %384 CHs + 1 sync
% sample rate, Hz 
ops.fs = 30000;
for th2 = [6 ]
    ops.Th = [7 th2];
    SAVEPATH = fullfile(MERGEPATH, ['th', num2str(ops.Th(1))  , '_', num2str(ops.Th(2))]);
    if ~exist([SAVEPATH '\params.py'], "file")
        mKilosort(binFile, ops, savePath);
    end
end
