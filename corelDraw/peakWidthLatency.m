function [peak, width, latency] = peakWidthLatency(spikes, baseWin, calWin, trials)
[~, ~, Raw, ~, trials1] = calFR(spikes, calWin, trials);
spikes(ismember(spikes(:, 2),trials1(Raw > mean(Raw)+3*std(Raw))), :) = [];
trials(trials1(Raw > mean(Raw)+3*std(Raw))) = [];
[frMean, ~, ~, frSD] = calFR(spikes, baseWin, trials);
psthPara.binsize = 10; % ms
psthPara.binstep = 1; % ms
PSTH = calPsth(spikes(:, 1), psthPara, 1e3, 'EDGE', calWin, 'NTRIAL', length(trials));
smthPSTH = mGaussionFilter(PSTH(:, 2), 20, 101);
%     smthPSTH = smoothdata(PSTH(:, 2),'gaussian',1);
% figure;
% plot(PSTH(:, 1), smthPSTH);

%% peak and width
peak = max(smthPSTH);
thr = 0.5*peak;
evokeIdx = find(smthPSTH >= thr);
temp = find([0; diff(evokeIdx)] > 25);
if ~isempty(temp)
    evokeIdx(temp(1):end) = [];
end
[firstIdx, lastIdx] = mConsecutive(evokeIdx, 5);
if ~isempty(firstIdx)
    width = PSTH(evokeIdx(lastIdx), 1)- PSTH(evokeIdx(firstIdx), 1);
else
    width = 0;
    peak = 0;
end

%% latency
thr = max([frMean + 2*frSD, 0.2*peak, 10]);
evokeIdx = find(smthPSTH >= thr);
if ~isempty(evokeIdx)
    firstIdx = mConsecutive(evokeIdx, 3);
    if ~isempty(firstIdx)
        latency = PSTH(evokeIdx(firstIdx), 1);
    else
        latency = calWin(2);
    end
else
    latency = calWin(2);
end

end
