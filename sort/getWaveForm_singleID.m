function wf = getWaveForm_singleID(fs, DataPath, NPYPATH, unitID, IDandCHANNEL)

gwfparams.dataDir = [DataPath, '\'];    % KiloSort/Phy output folder
gwfparams.fileName = 'temp_wh.dat';         % .dat file containing the raw
gwfparams.dataType = 'int16';            % Data type of .dat file (this should be BP filtered)
gwfparams.wfWin = [-16 16];              % Number of samples before and after spiketime to include in waveform

gwfparams.spikeTimeIdx =    readNPY([NPYPATH, '\spike_times.npy']); % Vector of cluster spike times (in samples) same length as .spikeClusters
gwfparams.spikeClusters = readNPY([NPYPATH, '\spike_clusters.npy']); % Vector of cluster IDs (Phy nomenclature)   same length as .spikeTimes
gwfparams.chMap = readNPY([NPYPATH, '\channel_map.npy']);               % Order in which data was streamed to disk; must be 1-indexed for Matlab


gwfparams.nCh = length(unique(gwfparams.chMap));
gwfparams.numUnits = size(unique(gwfparams.spikeClusters),1);

fileName = fullfile(gwfparams.dataDir,gwfparams.fileName);
filenamestruct = dir(fileName);
dataTypeNBytes = numel(typecast(cast(0, gwfparams.dataType), 'uint8')); % determine number of bytes per sample
nSamp = filenamestruct.bytes/(gwfparams.nCh*dataTypeNBytes);  % Number of samples per channel
wfNSamples = length(gwfparams.wfWin(1):gwfparams.wfWin(end));
mmf = memmapfile(fileName, 'Format', {gwfparams.dataType, [gwfparams.nCh nSamp], 'x'});


MChInID = IDandCHANNEL(IDandCHANNEL(:,1)==unitID, 3) + 1;
SpikeIndex = gwfparams.spikeTimeIdx(gwfparams.spikeClusters==unitID);
nWf = length(SpikeIndex);

SpikeTime = double(SpikeIndex - 1) / fs ;

% Read spike time-centered waveforms

waveForms = nan(nWf,wfNSamples);
for curSpikeTime = 1:nWf
    waveForms(curSpikeTime,:) = mmf.Data.x(MChInID,SpikeIndex(curSpikeTime)+gwfparams.wfWin(1):SpikeIndex(curSpikeTime)+gwfparams.wfWin(end));
end
waveFormsMean = mean(waveForms);
disp(['Completed ' int2str(unitID) ' units of ' int2str(gwfparams.numUnits) '.']);


% Package in wf struct
wf.fs =  fs;
wf.wfWin = [ 0 gwfparams.wfWin(end)- gwfparams.wfWin(1)];
wf.nWf = nWf;
wf.MChInID = MChInID;
wf.unitID = unitID;
wf.SpikeTime = SpikeTime;
wf.waveForms = waveForms;
wf.waveFormsMean = waveFormsMean;
