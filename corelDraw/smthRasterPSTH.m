function chSpikeLfp = smthRasterPSTH(chSpikeLfp, stimCode)
% stimCode = 3; % 1:reg4-4.06; 3:irreg4-4.06s
chSPK = chSpikeLfp(stimCode).chSPK;
for chIndex = 1:length(chSPK)
    spikePlot = chSPK(chIndex).spikePlot;
    temp = unique(spikePlot(:, 2));
    spike = spikePlot;
    for i = 1 : length(temp)
        idx = spikePlot(:,2)==temp(i);
        spike(idx, 2) = i;
    end
    chSpikeLfp(stimCode).chSPK(chIndex).spikePlotNew = spike;
    % spike(spike(:, 1) < -2200, :) = [];
    % psth
%     psthPara.binsize = 30; % ms
%     psthPara.binstep = 1; % ms
%     PSTH = calPsth(spike(:, 1), psthPara, 1e3, 'EDGE', [-2500, 2500], 'NTRIAL', length(chSpikeLfp(stimCode).trialsRaw));

        PSTH = chSPK(chIndex).PSTH;
      PSTH(:, 2) = smoothdata(PSTH(:, 2),'gaussian',5);
    chSpikeLfp(stimCode).chSPK(chIndex).PSTH = PSTH;
end
end
