for lIndex = 1 : 3
    compare.LFP(lIndex).Data(:, 1) = TBIs(compareIdx(1)).LFP(lIndex).poolData;
    compare.LFP(lIndex).Data(:, 2) = TBIs(compareIdx(2)).LFP(lIndex).poolData;
    compare.CSD(lIndex).Data(:, 1) = TBIs(compareIdx(1)).CSD(lIndex).poolData;
    compare.CSD(lIndex).Data(:, 2) = TBIs(compareIdx(2)).CSD(lIndex).poolData;
    compare.MUA(lIndex).Data(:, 1) = TBIs(compareIdx(1)).MUA(lIndex).poolData;
    compare.MUA(lIndex).Data(:, 2) = TBIs(compareIdx(2)).MUA(lIndex).poolData;

    DIFF.TBI(lIndex).info =  TBIs(compareIdx(1)).MUA(lIndex).info;
    DIFF.TBI(lIndex).LFP = diff(compare.LFP(lIndex).Data, 1, 2);
    DIFF.TBI(lIndex).LFPMean = [mean(DIFF.TBI(lIndex).LFP), std(DIFF.TBI(lIndex).LFP)/sqrt(length(DIFF.TBI(lIndex).LFP))];
    DIFF.TBI(lIndex).CSD = diff(compare.CSD(lIndex).Data, 1, 2);
    DIFF.TBI(lIndex).CSDMean = [mean(DIFF.TBI(lIndex).CSD), std(DIFF.TBI(lIndex).CSD)/sqrt(length(DIFF.TBI(lIndex).CSD))];
    DIFF.TBI(lIndex).MUA = diff(compare.MUA(lIndex).Data, 1, 2);
    DIFF.TBI(lIndex).MUAMean = [mean(DIFF.TBI(lIndex).MUA), std(DIFF.TBI(lIndex).MUA)/sqrt(length(DIFF.TBI(lIndex).MUA))];

    DIFF.sigRatio(lIndex).info =  TBIs(compareIdx(1)).MUA(lIndex).info;
    DIFF.sigRatio(lIndex).LFP = H(compareIdx(2)).LFP(lIndex).ratio - H(compareIdx(1)).LFP(lIndex).ratio;
    DIFF.sigRatio(lIndex).CSD = H(compareIdx(2)).CSD(lIndex).ratio - H(compareIdx(1)).CSD(lIndex).ratio;
    DIFF.sigRatio(lIndex).MUA = H(compareIdx(2)).MUA(lIndex).ratio - H(compareIdx(1)).MUA(lIndex).ratio;
end

[~, DIFF.ampSig.LFP.SgGr] = ttest2(DIFF.TBI(1).LFP, DIFF.TBI(2).LFP);
[~, DIFF.ampSig.LFP.SgIg] = ttest2(DIFF.TBI(1).LFP, DIFF.TBI(3).LFP);
[~, DIFF.ampSig.LFP.GrIg] = ttest2(DIFF.TBI(2).LFP, DIFF.TBI(3).LFP);
[DIFF.ampSig.LFP.ANOVA, ~, stats] = anova1([DIFF.TBI(1).LFP; DIFF.TBI(2).LFP; DIFF.TBI(3).LFP], [ones(length(DIFF.TBI(1).LFP), 1); 2*ones(length(DIFF.TBI(2).LFP), 1); 3*ones(length(DIFF.TBI(3).LFP), 1)], "off");
DIFF.ampSig.LFP.postHoc = multcompare(stats, "Display", "off", "CType","tukey-kramer");

[~, DIFF.ampSig.CSD.SgGr] = ttest2(DIFF.TBI(1).CSD, DIFF.TBI(2).CSD);
[~, DIFF.ampSig.CSD.SgIg] = ttest2(DIFF.TBI(1).CSD, DIFF.TBI(3).CSD);
[~, DIFF.ampSig.CSD.GrIg] = ttest2(DIFF.TBI(2).CSD, DIFF.TBI(3).CSD);
[DIFF.ampSig.CSD.ANOVA, ~,  stats] = anova1([DIFF.TBI(1).CSD; DIFF.TBI(2).CSD; DIFF.TBI(3).CSD], [ones(length(DIFF.TBI(1).CSD), 1); 2*ones(length(DIFF.TBI(2).CSD), 1); 3*ones(length(DIFF.TBI(3).CSD), 1)], "off");
DIFF.ampSig.CSD.postHoc = multcompare(stats, "Display", "off", "CType","tukey-kramer");

[~, DIFF.ampSig.MUA.SgGr] = ttest2(DIFF.TBI(1).MUA, DIFF.TBI(2).MUA);
[~, DIFF.ampSig.MUA.SgIg] = ttest2(DIFF.TBI(1).MUA, DIFF.TBI(3).MUA);
[~, DIFF.ampSig.MUA.GrIg] = ttest2(DIFF.TBI(2).MUA, DIFF.TBI(3).MUA);
[DIFF.ampSig.MUA.ANOVA, ~,  stats] = anova1([DIFF.TBI(1).MUA; DIFF.TBI(2).MUA; DIFF.TBI(3).MUA], [ones(length(DIFF.TBI(1).MUA), 1); 2*ones(length(DIFF.TBI(2).MUA), 1); 3*ones(length(DIFF.TBI(3).MUA), 1)], "off");
DIFF.ampSig.MUA.postHoc = multcompare(stats, "Display", "off", "CType","tukey-kramer");
