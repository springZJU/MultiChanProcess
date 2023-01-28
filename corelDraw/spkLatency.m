function latency = spkLatency(spikes, baseWin, calWin, trials)
[frMean, ~, ~, frSD] = calFR(spikes, baseWin, trials);
psthPara.binsize = 5; % ms
psthPara.binstep = 0.5; % ms
PSTH = calPsth(spikes(:, 1), psthPara, 1e3, 'EDGE', calWin, 'NTRIAL', length(trials));
smthPSTH = mGaussionFilter(PSTH(:, 2), 0.5, 11);
%     PSTH(:, 2) = smoothdata(PSTH(:, 2),'gaussian',5);
thr = frMean + 3*frSD;
evokeIdx = find(smthPSTH >= thr);
if ~isempty(evokeIdx)
    firstIdx = mConsecutive(evokeIdx, 3);
    latency = PSTH(evokeIdx(firstIdx), 1);
else
    latency = calWin(2);
end
end
