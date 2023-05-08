clc;clear;

%% load data
protSel = "Offset_2_128_4s_New";
popResPath = "E:\MonkeyLinearArray\ProcessedData\";
DATAPATH = strcat(popResPath, protSel, "\popRes");
load(DATAPATH);

%% plot data
% RegSigIdx = logical(popAll(1).sigOnsetIdx);
RegSigIdx = true(length(popAll(1).chSPK), 1);
RegNoSigIdx = ~RegSigIdx;
Idx = 1:9;
x = [1, 2, 4, 8, 16, 32, 64, 128, 8]';
run("generalCodes_Offset.m");

%% anova
pAnova.frRaw = mAnova_Col(frRaw(1:end-1, :)');
pAnova.peak = mAnova_Col(peakRaw(1:end-1, :)');
pAnova.latency = mAnova_Col(latencyRaw(1:end-1, :)');
pAnova.AUCRaw = mAnova_Col(AUCRaw(1:end-1, :)');

%% 单调性
ICIs = [1, 2, 4, 8, 16, 32, 64, 128]';
[rho, p] = cellfun(@(x) corr([ICIs, x(:, 1)], 'type', 'Spearman'), {toPlot.frPlot}', "UniformOutput", false);
rhoPop = cell2mat(cellfun(@(x) x(2,1),rho, "UniformOutput", false));
pPop = cell2mat(cellfun(@(x) x(2,1),p, "UniformOutput", false));
monotoneIdx = find(rhoPop < -0.5 & pPop < 0.05);
non_monotoneIdx = find(~(rhoPop < -0.5 & pPop < 0.05));
monotone.sig_frMean = [mean(frRawMean(:, monotoneIdx), 2), SE(frRawMean(:, monotoneIdx), 2)];
monotone.nosig_frMean = [mean(frRawMean(:, non_monotoneIdx), 2), SE(frRawMean(:, non_monotoneIdx), 2)];

maxFR.monotone = maxFR.all(monotoneIdx, :);
maxFR.nonMonotone = maxFR.all(non_monotoneIdx, :);
FRMax.monotone = tabulate(maxFR.monotone(:, 1));
FRMax.nonMonotone = tabulate(maxFR.nonMonotone(:, 1));

%% PCA+K means
% frRawMean_Backup = frRawMean;
% frRawMean = frRawMean(:, ~offsetNANIdx);
% [coeff,score,latent] = pca((frRawMean./max(frRawMean, [], 1))');
[coeff,score,latent] = pca(frRawMean');

varRank = latent/sum(latent);
pc = score(:, [1, 2, 3]);
figure
% scatter3(pc(:, 1), pc(:, 2), pc(:, 3));
%  scatter(pc(:, 1), pc(:, 2));
idx = kmeans(pc(:, 2), 3, "Distance", "sqeuclidean");
cluster1 = idx==1;
scatter3(pc(cluster1, 1), pc(cluster1, 2), pc(cluster1, 3),  "red", "filled"); hold on

cluster2 = idx==2;
scatter3(pc(cluster2, 1), pc(cluster2, 2), pc(cluster2, 3), "blue", "filled"); hold on

cluster3 = idx==3;
scatter3(pc(cluster3, 1), pc(cluster3, 2), pc(cluster3, 3), "black", "filled"); hold on

frCluster(1).pc = pc(cluster1, :);
frCluster(1).firingRate = [mean(frRawMean(:, cluster1), 2), SE(frRawMean(:, cluster1), 2)];
frCluster(2).pc = pc(cluster2, :);
frCluster(2).firingRate = [mean(frRawMean(:, cluster2), 2), SE(frRawMean(:, cluster2), 2)];
frCluster(3).pc = pc(cluster3, :);
frCluster(3).firingRate = [mean(frRawMean(:, cluster3), 2), SE(frRawMean(:, cluster3), 2)];

figure
errorbar(1:size(frRawMean, 1), frCluster(1).firingRate(:, 1), frCluster(1).firingRate(:, 2), "r-"); hold on;
errorbar(1:size(frRawMean, 1), frCluster(2).firingRate(:, 1), frCluster(2).firingRate(:, 2), "b-"); hold on;
errorbar(1:size(frRawMean, 1), frCluster(3).firingRate(:, 1), frCluster(3).firingRate(:, 2), "k-"); hold on;





figure
fr.cluster1 = frRawMean(:, cluster1);
fr.cluster2 = frRawMean(:, cluster2);
fr.cluster3 = frRawMean(:, cluster3);
subplot(2,2,1)
plot(1:8, fr.cluster1, "color", "#AAAAAA", "LineStyle", "-"); hold on
plot(1:8, frCluster(1).firingRate(:,1), "color", "black", "LineStyle", "-", "LineWidth", 2);
title("Cluster3");
subplot(2,2,2)
plot(1:8, fr.cluster2, "color", "#AAAAAA", "LineStyle", "-"); hold on
plot(1:8, frCluster(2).firingRate(:,1), "color", "red", "LineStyle", "-", "LineWidth", 2);
title("Cluster1");
subplot(2,2,3)
plot(1:8, fr.cluster3, "color", "#AAAAAA", "LineStyle", "-"); hold on
plot(1:8, frCluster(3).firingRate(:,1), "color", "blue", "LineStyle", "-", "LineWidth", 2);
title("Cluster2");
