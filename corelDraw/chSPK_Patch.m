function chSPK = chSPK_Patch(chSPK)
    badIdx = find([chSPK.frMean_0]' == 0);
    for bIndex = 1 : length(badIdx)
        idx = badIdx(bIndex);
        chSPK(idx).countRaw_0(end) = 0.0001;
        chSPK(idx).TBI_Raw = 0;
        chSPK(idx).TBI_Mean = chSPK(idx).frMean_1;
        chSPK(idx).TBI_SE = 0;
        [chSPK(idx).p_ranksum, chSPK(idx).h_ranksum] = ranksum(chSPK(idx).countRaw_0, chSPK(idx).countRaw_1); 
        [chSPK(idx).h_ttest, chSPK(idx).p_ttest] = ttest(chSPK(idx).countRaw_0, chSPK(idx).countRaw_1);
    end
end