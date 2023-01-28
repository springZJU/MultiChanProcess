CH = "CH4";
load("res.mat");

%% Reg4-4.06
stimCode = 1; % 1:reg4-4.06
chSPK = chSpikeLfp(stimCode).chSPK;

% spike
spikePlot = chSPK(strcmpi({chSPK.info}', CH)).spikePlot;
temp = unique(spikePlot(:, 2));
spikeReg = spikePlot;
for i = 1 : length(temp)
    idx = spikePlot(:,2)==temp(i);
    spikeReg(idx, 2) = i;
end
spikeReg(spikeReg(:, 1) < -2200, :) = [];

% psth
PSTHReg = chSPK(strcmpi({chSPK.info}', CH)).PSTH;
PSTHReg(:, 2) = smoothdata(PSTHReg(:, 2),'gaussian',25);

%% Irreg4-4.06
stimCode = 3; % 1:reg4-4.06; 3:irreg4-4.06s
chSPK = chSpikeLfp(stimCode).chSPK;
spikePlot = chSPK(strcmpi({chSPK.info}', CH)).spikePlot;
temp = unique(spikePlot(:, 2));
spikeIrreg = spikePlot;
for i = 1 : length(temp)
    idx = spikePlot(:,2)==temp(i);
    spikeIrreg(idx, 2) = i;
end
spikeIrreg(spikeIrreg(:, 1) < -2200, :) = [];
% psth
PSTHIrreg = chSPK(strcmpi({chSPK.info}', CH)).PSTH;
PSTHIrreg(:, 2) = smoothdata(PSTHIrreg(:, 2),'gaussian',25);

%% Tone250-246
stimCode = 7; % 7:Tone250-246
chSPK = chSpikeLfp(stimCode).chSPK;

% spike
spikePlot = chSPK(strcmpi({chSPK.info}', CH)).spikePlot;
temp = unique(spikePlot(:, 2));
spikeTone = spikePlot;
for i = 1 : length(temp)
    idx = spikePlot(:,2)==temp(i);
    spikeTone(idx, 2) = i;
end
spikeTone(spikeTone(:, 1) < -2200, :) = [];

% psth
PSTHTone = chSPK(strcmpi({chSPK.info}', CH)).PSTH;
PSTHTone(:, 2) = smoothdata(PSTHTone(:, 2),'gaussian',25);