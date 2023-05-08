%%
for rIndex = 1 : length(ttestRes)
    for dIndex = 1 : length(ttestRes(rIndex).MUA)
        H(dIndex).info = plotCSD(dIndex).info;
        TBIs(dIndex).info = plotCSD(dIndex).info;
        % MUA
        SgIndex = ttestRes(rIndex).MUA(1).SgIndex;
        GrIndex = ttestRes(rIndex).MUA(1).GrIndex;
        IgIndex = ttestRes(rIndex).MUA(1).IgIndex;
        H(dIndex).MUA(1).info = "SgIndex";
        H(dIndex).MUA(1).data{rIndex, 1} = ttestRes(rIndex).MUA(dIndex).h(SgIndex);
        H(dIndex).MUA(2).info = "GrIndex";
        H(dIndex).MUA(2).data{rIndex, 1} = ttestRes(rIndex).MUA(dIndex).h(GrIndex);
        H(dIndex).MUA(3).info = "IgIndex";
        H(dIndex).MUA(3).data{rIndex, 1} = ttestRes(rIndex).MUA(dIndex).h(IgIndex);

        TBIs(dIndex).MUA(1).info = "SgIndex";
        TBIs(dIndex).MUA(1).data{rIndex, 1} = ttestRes(rIndex).MUA(dIndex).TBIMean(SgIndex);
        TBIs(dIndex).MUA(2).info = "GrIndex";
        TBIs(dIndex).MUA(2).data{rIndex, 1} = ttestRes(rIndex).MUA(dIndex).TBIMean(GrIndex);
        TBIs(dIndex).MUA(3).info = "IgIndex";
        TBIs(dIndex).MUA(3).data{rIndex, 1} = ttestRes(rIndex).MUA(dIndex).TBIMean(IgIndex);

        RSPs(dIndex).MUA(1).info = "SgIndex";
        RSPs(dIndex).MUA(1).data{rIndex, 1} = ttestRes(rIndex).MUA(dIndex).rspMeanMUA(SgIndex);
        RSPs(dIndex).MUA(2).info = "GrIndex";
        RSPs(dIndex).MUA(2).data{rIndex, 1} = ttestRes(rIndex).MUA(dIndex).rspMeanMUA(GrIndex);
        RSPs(dIndex).MUA(3).info = "IgIndex";
        RSPs(dIndex).MUA(3).data{rIndex, 1} = ttestRes(rIndex).MUA(dIndex).rspMeanMUA(IgIndex);

        % LFP
        SgIndex = ttestRes(rIndex).LFP(1).SgIndex;
        GrIndex = ttestRes(rIndex).LFP(1).GrIndex;
        IgIndex = ttestRes(rIndex).LFP(1).IgIndex;
        H(dIndex).LFP(1).info = "SgIndex";
        H(dIndex).LFP(1).data{rIndex, 1} = ttestRes(rIndex).LFP(dIndex).h(SgIndex);
        H(dIndex).LFP(2).info = "GrIndex";
        H(dIndex).LFP(2).data{rIndex, 1} = ttestRes(rIndex).LFP(dIndex).h(GrIndex);
        H(dIndex).LFP(3).info = "IgIndex";
        H(dIndex).LFP(3).data{rIndex, 1} = ttestRes(rIndex).LFP(dIndex).h(IgIndex);

        TBIs(dIndex).LFP(1).info = "SgIndex";
        TBIs(dIndex).LFP(1).data{rIndex, 1} = ttestRes(rIndex).LFP(dIndex).TBIMean(SgIndex);
        TBIs(dIndex).LFP(2).info = "GrIndex";
        TBIs(dIndex).LFP(2).data{rIndex, 1} = ttestRes(rIndex).LFP(dIndex).TBIMean(GrIndex);
        TBIs(dIndex).LFP(3).info = "IgIndex";
        TBIs(dIndex).LFP(3).data{rIndex, 1} = ttestRes(rIndex).LFP(dIndex).TBIMean(IgIndex);

        RSPs(dIndex).LFP(1).info = "SgIndex";
        RSPs(dIndex).LFP(1).data{rIndex, 1} = ttestRes(rIndex).LFP(dIndex).rspMeanLFP(SgIndex);
        RSPs(dIndex).LFP(2).info = "GrIndex";
        RSPs(dIndex).LFP(2).data{rIndex, 1} = ttestRes(rIndex).LFP(dIndex).rspMeanLFP(GrIndex);
        RSPs(dIndex).LFP(3).info = "IgIndex";
        RSPs(dIndex).LFP(3).data{rIndex, 1} = ttestRes(rIndex).LFP(dIndex).rspMeanLFP(IgIndex);

        % CSD
        SgIndex = ttestRes(rIndex).CSD(1).SgIndex;
        GrIndex = ttestRes(rIndex).CSD(1).GrIndex;
        IgIndex = ttestRes(rIndex).CSD(1).IgIndex;
        H(dIndex).CSD(1).info = "SgIndex";
        H(dIndex).CSD(1).data{rIndex, 1} = ttestRes(rIndex).CSD(dIndex).h(SgIndex);
        H(dIndex).CSD(2).info = "GrIndex";
        H(dIndex).CSD(2).data{rIndex, 1} = ttestRes(rIndex).CSD(dIndex).h(GrIndex);
        H(dIndex).CSD(3).info = "IgIndex";
        H(dIndex).CSD(3).data{rIndex, 1} = ttestRes(rIndex).CSD(dIndex).h(IgIndex);

        TBIs(dIndex).CSD(1).info = "SgIndex";
        TBIs(dIndex).CSD(1).data{rIndex, 1} = ttestRes(rIndex).CSD(dIndex).TBIMean(SgIndex);
        TBIs(dIndex).CSD(2).info = "GrIndex";
        TBIs(dIndex).CSD(2).data{rIndex, 1} = ttestRes(rIndex).CSD(dIndex).TBIMean(GrIndex);
        TBIs(dIndex).CSD(3).info = "IgIndex";
        TBIs(dIndex).CSD(3).data{rIndex, 1} = ttestRes(rIndex).CSD(dIndex).TBIMean(IgIndex);

        RSPs(dIndex).CSD(1).info = "SgIndex";
        RSPs(dIndex).CSD(1).data{rIndex, 1} = ttestRes(rIndex).CSD(dIndex).rspMeanCSD(SgIndex);
        RSPs(dIndex).CSD(2).info = "GrIndex";
        RSPs(dIndex).CSD(2).data{rIndex, 1} = ttestRes(rIndex).CSD(dIndex).rspMeanCSD(GrIndex);
        RSPs(dIndex).CSD(3).info = "IgIndex";
        RSPs(dIndex).CSD(3).data{rIndex, 1} = ttestRes(rIndex).CSD(dIndex).rspMeanCSD(IgIndex);


    end
end


for dIndex = 1 : length(ttestRes(rIndex).MUA)
    for lIndex = 1 : length(TBIs(dIndex).MUA)
        TBIs(dIndex).CSD(lIndex).poolData = cell2mat(TBIs(dIndex).CSD(lIndex).data);
        TBIs(dIndex).CSD(lIndex).mean = mean(TBIs(dIndex).CSD(lIndex).poolData);
        TBIs(dIndex).CSD(lIndex).SE = std(TBIs(dIndex).CSD(lIndex).poolData)/sqrt(length(TBIs(dIndex).CSD(lIndex).poolData));
        RSPs(dIndex).CSD(lIndex).poolData = cell2mat(RSPs(dIndex).CSD(lIndex).data);
        RSPs(dIndex).CSD(lIndex).mean = mean(RSPs(dIndex).CSD(lIndex).poolData);
        RSPs(dIndex).CSD(lIndex).SE = std(RSPs(dIndex).CSD(lIndex).poolData)/sqrt(length(RSPs(dIndex).CSD(lIndex).poolData));
        H(dIndex).CSD(lIndex).poolData = cell2mat(H(dIndex).CSD(lIndex).data);
        H(dIndex).CSD(lIndex).ratio = sum(H(dIndex).CSD(lIndex).poolData>0)/length(H(dIndex).CSD(lIndex).poolData);

        TBIs(dIndex).MUA(lIndex).poolData = cell2mat(TBIs(dIndex).MUA(lIndex).data);
        TBIs(dIndex).MUA(lIndex).mean = mean(TBIs(dIndex).MUA(lIndex).poolData);
        TBIs(dIndex).MUA(lIndex).SE = std(TBIs(dIndex).MUA(lIndex).poolData)/sqrt(length(TBIs(dIndex).MUA(lIndex).poolData));
        RSPs(dIndex).MUA(lIndex).poolData = cell2mat(RSPs(dIndex).MUA(lIndex).data);
        RSPs(dIndex).MUA(lIndex).mean = mean(RSPs(dIndex).MUA(lIndex).poolData);
        RSPs(dIndex).MUA(lIndex).SE = std(RSPs(dIndex).MUA(lIndex).poolData)/sqrt(length(RSPs(dIndex).MUA(lIndex).poolData));
        H(dIndex).MUA(lIndex).poolData = cell2mat(H(dIndex).MUA(lIndex).data);
        H(dIndex).MUA(lIndex).ratio = sum(H(dIndex).MUA(lIndex).poolData>0)/length(H(dIndex).MUA(lIndex).poolData);

        TBIs(dIndex).LFP(lIndex).poolData = cell2mat(TBIs(dIndex).LFP(lIndex).data);
        TBIs(dIndex).LFP(lIndex).mean = mean(TBIs(dIndex).LFP(lIndex).poolData);
        TBIs(dIndex).LFP(lIndex).SE = std(TBIs(dIndex).LFP(lIndex).poolData)/sqrt(length(TBIs(dIndex).LFP(lIndex).poolData));
        RSPs(dIndex).LFP(lIndex).poolData = cell2mat(RSPs(dIndex).LFP(lIndex).data);
        RSPs(dIndex).LFP(lIndex).mean = mean(RSPs(dIndex).LFP(lIndex).poolData);
        RSPs(dIndex).LFP(lIndex).SE = std(RSPs(dIndex).LFP(lIndex).poolData)/sqrt(length(RSPs(dIndex).LFP(lIndex).poolData));
        H(dIndex).LFP(lIndex).poolData = cell2mat(H(dIndex).LFP(lIndex).data);
        H(dIndex).LFP(lIndex).ratio = sum(H(dIndex).LFP(lIndex).poolData>0)/length(H(dIndex).LFP(lIndex).poolData);
    end
end

