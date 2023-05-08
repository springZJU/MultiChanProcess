for dIndex = 1 : length(popAll)
[~, ~, ~, HalfEdge{dIndex}] = cellfun(@(x, y) peakWidthLatency(x, [-150, 0], [0, 150], y, protSel), {temp(1).sig.spikePlot}', {temp(1).sig.trialsRaw}', "UniformOutput", false);
end
HalfEdgeMean = cellfun(@(x, y, z) mean([x;y;z], 1), HalfEdge{1}, HalfEdge{2}, HalfEdge{3}, "uni", false);
maskIdx = cellfun(@(x) find(Offset< x(2), 1, "first")-1, HalfEdgeMean, "UniformOutput", false);
h_Mask = cell2mat(cellfun(@(x) [ones(1, x), zeros(1, length(popAll)-1-x)], maskIdx, "UniformOutput", false));
for pIndex = 1 : length(temp)-1

%% 8个click及以上与clcik train期间比较，8个click以内与single click比较
%     if pIndex == 1
%         [~, ~, countRaw_Spon] = cellfun(@(x, y) calFR(x, rspWin+Offset(pIndex), y), {temp(pIndex).sig.spikePlot}', {temp(pIndex).sig.trialsRaw}' , "UniformOutput", false);
%         [~, ~, countRaw_Rsp] = cellfun(@(x, y) calFR(x, [-100, 0]+Offset(pIndex), y), {temp(pIndex).sig.spikePlot}', {temp(pIndex).sig.trialsRaw}' , "UniformOutput", false);
%     elseif pIndex <=6
%         [~, ~, countRaw_Spon] = cellfun(@(x, y) calFR(x, rspWin+Offset(pIndex), y), {temp(1).sig.spikePlot}', {temp(1).sig.trialsRaw}' , "UniformOutput", false);
%         [~, ~, countRaw_Rsp] = cellfun(@(x, y) calFR(x, rspWin+Offset(pIndex), y), {temp(pIndex).sig.spikePlot}', {temp(pIndex).sig.trialsRaw}' , "UniformOutput", false);
%     else
%         [~, ~, countRaw_Spon] = cellfun(@(x, y) calFR(x, rspWin+Offset(pIndex), y), {temp(end).sig.spikePlot}', {temp(end).sig.trialsRaw}' , "UniformOutput", false);
%         [~, ~, countRaw_Rsp] = cellfun(@(x, y) calFR(x, rspWin+Offset(pIndex), y), {temp(pIndex).sig.spikePlot}', {temp(pIndex).sig.trialsRaw}' , "UniformOutput", false);
%     end
%         [H, P]= cellfun(@(x, y) ttest2(x, y), countRaw_Spon, countRaw_Rsp, "UniformOutput", false);


%% 8个click及以上与onset前100ms比较，8个click以内与single click比较
%     if pIndex <=6 %32ms
        [~, ~, countRaw_Spon] = cellfun(@(x, y) calFR(x, [-100, 0], y), {temp(pIndex).sig.spikePlot}', {temp(pIndex).sig.trialsRaw}' , "UniformOutput", false);
        [rspMean(pIndex, :), rspSE(pIndex, :), countRaw_Rsp] = cellfun(@(x, y) calFR(x, rspWin+Offset(pIndex), y), {temp(pIndex).sig.spikePlot}', {temp(pIndex).sig.trialsRaw}' , "UniformOutput", false);
%     else
%         [~, ~, countRaw_Spon] = cellfun(@(x, y) calFR(x, rspWin+Offset(pIndex), y), {temp(end).sig.spikePlot}', {temp(end).sig.trialsRaw}' , "UniformOutput", false);
%         [rspMean(pIndex, :), rspSE(pIndex, :), countRaw_Rsp] = cellfun(@(x, y) calFR(x, rspWin+Offset(pIndex), y), {temp(pIndex).sig.spikePlot}', {temp(pIndex).sig.trialsRaw}' , "UniformOutput", false);
%     end
        [H, P]= cellfun(@(x, y) ttest2(x, y), countRaw_Spon, countRaw_Rsp, "UniformOutput", false);
        h_High = double(cell2mat(cellfun(@(x, y) mean(x) < mean(y), countRaw_Spon, countRaw_Rsp, "UniformOutput", false)));

%% 假设反应包含onset和offset两个部分，因此分别选取onset反应和offset反应加在一起，与single比较
%         [~, ~, countRaw_Single] = cellfun(@(x, y) calFR(x, [0, 100], y), {temp(end).sig.spikePlot}', {temp(end).sig.trialsRaw}' , "UniformOutput", false);
% 
%         [~, ~, countRaw_Onset] = cellfun(@(x, y) calFR(x, [0, 100], y), {temp(pIndex).sig.spikePlot}', {temp(pIndex).sig.trialsRaw}' , "UniformOutput", false);
%         [~, ~, countRaw_Offset] = cellfun(@(x, y) calFR(x, [0, 100]+Offset(pIndex), y), {temp(pIndex).sig.spikePlot}', {temp(pIndex).sig.trialsRaw}' , "UniformOutput", false);
%         countRaw_Rsp = cellfun(@(x, y) (x+y)/2, countRaw_Onset, countRaw_Offset, "UniformOutput", false);
%         [H, P]= cellfun(@(x, y) ttest2(x, y), countRaw_Single, countRaw_Rsp, "UniformOutput", false);


    h_Offset(:, pIndex) = cell2mat(H).*h_High;
    p_Offset(:, pIndex) = log(cell2mat(P))/log(0.05);

end
h_Offset(isnan(h_Offset)) = 0;
h_Offset = h_Offset.*h_Mask;


%% PSTH 判断与相邻情况是否同时存在差异
for pIndex = 1 : length(temp)-1
    
end

%% significant neurons
sigIdx = find(sum(h_Offset(:, 3)>0, 2));
h_Offset_Sig = h_Offset(sigIdx, :);
h_Offset_Ratio = sum(h_Offset_Sig, 1);

%%
ThrIdxRaw = cell2mat(cellfun(@(x) length(popAll)+1-max([find(x, 1, "last"), -1]), num2cell(h_Offset, 2), "UniformOutput", false));
NAIdx = ThrIdxRaw == length(popAll) + 2;
NA_Idx = ThrIdxRaw(ThrIdxRaw == length(popAll) + 2);
ThrIdx = ThrIdxRaw(ThrIdxRaw < length(popAll) + 2);

% Offset_ThrVal = [Offset, 1300];

ThrIdxTime.all = cell2mat(cellfun(@(x) Offset_ThrVal(min([find(x, 1, "last"), length(popAll)+1])), num2cell(h_Offset, 2), "UniformOutput", false));
onsetEdge.width.all = cell2mat(cellfun(@(x) diff(x), HalfEdgeMean, "UniformOutput", false));
onsetEdge.rise.all = cell2mat(cellfun(@(x) x(1), HalfEdgeMean, "UniformOutput", false));
ThrIdxTime.sig = ThrIdxTime.all(~NAIdx);
onsetEdge.width.sig = onsetEdge.width.all(~NAIdx);
onsetEdge.rise.sig = onsetEdge.rise.all(~NAIdx);
ThrIdxTime.noSig = ThrIdxTime.all(NAIdx);
onsetEdge.width.noSig = onsetEdge.width.all(NAIdx);
onsetEdge.rise.noSig = onsetEdge.rise.all(NAIdx);

%% firing rate
clear frRawMean
frRawMean.all = cell2mat(rspMean);
frRawMean.sig = frRawMean.all(:, ~NAIdx);
frRawMean.noSig = frRawMean.all(:, NAIdx);
frMean.all = [mean(frRawMean.all, 2), SE(frRawMean.all, 2)];
frMean.sig = [mean(frRawMean.sig, 2), SE(frRawMean.sig, 2)];
frMean.noSig = [mean(frRawMean.noSig, 2), SE(frRawMean.noSig, 2)];


%% anova
pAnova.frRaw = mAnova_Col(frRaw(1:end-1, :)');
pAnova.peak = mAnova_Col(peakRaw(1:end-1, :)');
pAnova.latency = mAnova_Col(latencyRaw(1:end-1, :)');
pAnova.AUCRaw = mAnova_Col(AUCRaw(1:end-1, :)');