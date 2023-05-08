function [peak, width, latency, HalfEdge] = peakWidthLatency(spikes, baseWin, calWin, trials, protocol)
[~, ~, Raw, ~, trials1] = calFR(spikes, calWin, trials);
excludeIndex = Raw >= 2 & Raw > mean(Raw)+3*std(Raw);
spikes(ismember(spikes(:, 2),trials1(excludeIndex)), :) = [];
trials(excludeIndex) = [];
[frMean, ~, ~, frSD] = calFR(spikes, baseWin, trials);
if contains(protocol, ["Offset_2_128_4s_New", "Offset_Duration_Effect_16ms_Reg_New", "Offset_Variance_Effect_4ms_16ms_sigma250_2_500msReg"])
    psthPara.binsize = 10; % ms
else
    psthPara.binsize = 30; % ms
end
psthPara.binstep = 1; % ms
% change window
calWinRaw = calWin;
calWin(1) = calWin(1)-psthPara.binsize;
calWin(2) = calWin(2)+psthPara.binsize;
PSTH = calPsth(spikes(:, 1), psthPara, 1e3, 'EDGE', calWin, 'NTRIAL', length(trials));
PSTH = findWithinInterval(PSTH, calWinRaw, 1);
smthPSTH = PSTH(:, 2);
% smthPSTH = mGaussionFilter(PSTH(:, 2), 20, 101);
%     smthPSTH = smoothdata(PSTH(:, 2),'gaussian',11);
% figure;
% plot(PSTH(:, 1), smthPSTH);

%% peak and width
peak = max(smthPSTH);

thr = 0.5*peak;
evokeIdx = find(smthPSTH >= thr);
flag = 1;
while flag == 1
    temp = find([0; diff(evokeIdx)] > 25);
    if ~isempty(temp)
        if temp(1)>5
            evokeIdx(temp(1):end) = [];
            flag = 0;
        else
            evokeIdx(1:temp(1)) = [];
        end

    else
        flag = 0;
    end
end
[firstIdx, lastIdx] = mConsecutive(evokeIdx, 4);
if ~isempty(firstIdx)
    width = PSTH(evokeIdx(lastIdx), 1)- PSTH(evokeIdx(firstIdx), 1);
    HalfEdge = [PSTH(evokeIdx(firstIdx), 1), PSTH(evokeIdx(lastIdx), 1)];
else
    width = 0;
    HalfEdge = [0, 0];
end

%% latency
thr = max([frMean + 2*frSD, 500/psthPara.binsize]);
evokeIdx = find(smthPSTH >= thr);
if ~isempty(evokeIdx)
    firstIdx = mConsecutive(evokeIdx, 3);
    if ~isempty(firstIdx)
        latency = PSTH(evokeIdx(firstIdx), 1);
    else
        latency = calWinRaw(2);
    end
else
    latency = calWinRaw(2);
end

end
