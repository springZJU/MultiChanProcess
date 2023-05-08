clear spikeCounts H frMean 
for pIndex = 1 : length(temp)
    spikes = {temp(pIndex).sig.spikePlot}';
    trials = {temp(pIndex).sig.trialsRaw}';
    if pIndex == 1
        spikesPrior = {temp(end).sig.spikePlot}';
        trialsPrior = {temp(end).sig.trialsRaw}';
    else
        spikesPrior = {temp(pIndex-1).sig.spikePlot}';
        trialsPrior = {temp(pIndex-1).sig.trialsRaw}';
    end

    if pIndex == length(temp)
        spikesLater = {temp(1).sig.spikePlot}';
        trialsLater = {temp(1).sig.trialsRaw}';
    else
        spikesLater = {temp(pIndex+1).sig.spikePlot}';
        trialsLater = {temp(pIndex+1).sig.trialsRaw}';
    end

    winSize = 25;
    winON = 0:winSize:1400-winSize;
    winOFF = winON + winSize;
    win = [winON', winOFF'];
    for wIndex = 1 : size(win, 1)
        spikeCounts(wIndex).window = win(wIndex, :);
        [tempFR, TempSE, spikeCounts(wIndex).self.(['p', num2str(pIndex)])] = cellfun(@(x, y)  calFR(x, win(wIndex, :), y), spikes, trials, "UniformOutput", false);
        frMean{pIndex, 1}(:, wIndex) = cell2mat(tempFR);
        frSE{pIndex, 1}(:, wIndex) = cell2mat(TempSE);
        [~, ~, spikeCounts(wIndex).prior.(['p', num2str(pIndex)])] = cellfun(@(x, y)  calFR(x, win(wIndex, :), y), spikesPrior, trialsPrior, "UniformOutput", false);
        [~, ~, def] = cellfun(@(x, y)  calFR(x, win(wIndex, :), y), spikes, trials, "UniformOutput", false);
        [~, ~, spikeCounts(wIndex).later.(['p', num2str(pIndex)])] = cellfun(@(x, y)  calFR(x, win(wIndex, :), y), spikesLater, trialsLater, "UniformOutput", false);
    end
end


%% H
dateStr = {toPlot.CH}';
for pIndex = 1:length(temp)-1

    [rspMean(pIndex, :), rspSE(pIndex, :), countRaw_Rsp] = cellfun(@(x, y) calFR(x, rspWin+Offset(pIndex), y), {temp(pIndex).sig.spikePlot}', {temp(pIndex).sig.trialsRaw}' , "UniformOutput", false);
    H(pIndex).stimStr = popAll(pIndex).stimStr;
    selfData = cellfun(@(x) x.(['p',num2str(pIndex)]), {spikeCounts.self}', "UniformOutput", false);
    priorData = cellfun(@(x) x.(['p',num2str(pIndex)]), {spikeCounts.prior}', "UniformOutput", false);
    laterData = cellfun(@(x) x.(['p',num2str(pIndex)]), {spikeCounts.later}', "UniformOutput", false);

    H_prior = cellfun(@(x, y) cell2mat(cellfun(@(m, n) replaceNaN(ttest2(m, n),0) & mean(m) > mean(n), x, y, "UniformOutput", false)), selfData, priorData, "UniformOutput", false);
    H_later = cellfun(@(x, y) cell2mat(cellfun(@(m, n) replaceNaN(ttest2(m, n),0) & mean(m) > mean(n), x, y, "UniformOutput", false)), selfData, laterData, "UniformOutput", false);
    H_all = cellfun(@(x, y, z) double(cell2mat(cellfun(@(m, n) replaceNaN(ttest2(m, n),0) & mean(m) > mean(n), x, y, "UniformOutput", false)) & cell2mat(cellfun(@(m, n) replaceNaN(ttest2(m, n),0)& mean(m) > mean(n), x, z, "UniformOutput", false))), selfData, priorData, laterData, "UniformOutput", false);
    H(pIndex).prior = cell2struct(changeCellRowNum(H_prior), dateStr, 1);
    H(pIndex).later = cell2struct(changeCellRowNum(H_later), dateStr, 1);
    H(pIndex).all = cell2struct(changeCellRowNum(H_all), dateStr, 1);
    checkWin = [max([0, Offset(pIndex)-100]), Offset(pIndex)+300];
    checkIdx = [find(win(:, 1) <= checkWin(1), 1, "last"), find(win(:, 1) >= checkWin(2), 1, "first")];
    H_all = changeCellRowNum(H_all);
    H_check = cell2mat(cellfun(@(x) any(x(checkIdx(1):checkIdx(end))), H_all, "UniformOutput", false));
%     if pIndex ==1
%        H_check = sum([popAll(1:2).sigIdxHigh],2) == 0 & H_check;
%     end
    H(pIndex).check = H_check;
end

%% frplot of window
for pIndex = 1:length(temp)
    frPlot(pIndex).time = win(:, 1)+winSize;
    frPlot(pIndex).frMean = frMean{pIndex, 1};
    frPlot(pIndex).frSE = frSE{pIndex, 1};
end




%% Threshold

if strcmpi(protSel, "Offset_Duration_Effect_4ms_Reg_New")
    H_Check = [H.check];
    H_Check(sum(H_Check(:, [1,2]), 2)==0, :) = false;
    H_Check(H_Check(:, end) == 1 & H_Check(:, end-1) == 0, end) = 0;
    H_Check(H_Check(:, end-1) == 1 & H_Check(:, end-2) == 0, end-1) = 0;
    minimal_ICI.all = cell2mat(cellfun(@(x) 10-max([0, find(x, 1, "last")]), num2cell(H_Check, 2), "UniformOutput", false));
    minimal_ICI.all(minimal_ICI.all == 10) = 11;
else
    H_Check = [H.check];
    H_Check(~any([popAll(1:3).sigOnsetHighIdx],2)) = false;
    H_Check(H_Check(:, end) == 1 & H_Check(:, end-1) == 0, end) = 0;
    minimal_ICI.all = cell2mat(cellfun(@(x) 8-max([0, find(x, 1, "last")]), num2cell(H_Check, 2), "UniformOutput", false));
    minimal_ICI.all(minimal_ICI.all == 8) = 11;
end
minimal_ICI.all(15) = 7;
minimal_ICI.all(28) = 8;
minimal_ICI.all(99) = 7;

minimal_ICI.nonOffset = minimal_ICI.all(minimal_ICI.all == 11);
minimal_ICI.withOffset = minimal_ICI.all(minimal_ICI.all < 11);
nonOffset_Idx = find(minimal_ICI.all == 11);
offset_Idx = find(minimal_ICI.all < 11);

% fr tuning
clear frRawMean 
frRawMean.all = cell2mat(rspMean);
frRawMean.sig = frRawMean.all(:, offset_Idx);
frRawMean.noSig = frRawMean.all(:, nonOffset_Idx);
frMeanOff.all = [mean(frRawMean.all, 2), SE(frRawMean.all, 2)];
frMeanOff.sig = [mean(frRawMean.sig, 2), SE(frRawMean.sig, 2)];
frMeanOff.noSig = [mean(frRawMean.noSig, 2), SE(frRawMean.noSig, 2)];

