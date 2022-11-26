function MLA_CSD(MATPATH, FIGPATH)

% csd paramters config
temp = strsplit(MATPATH, "\");
dateStr = string(temp{end - 1});
DATAPATH = strcat(MATPATH, "data.mat");
CSD_Methods = ["three point", "five point", "kCSD"];
mkdir(strcat(FIGPATH, dateStr));

for mIndex = 1 : length(CSD_Methods)

    CSD_Method = CSD_Methods(mIndex);
    FIGNAME = strcat(FIGPATH, dateStr, "\", CSD_Method);
    if exist(strcat(FIGNAME, ".jpg"), "file")
        continue
    end
    [badCh, dz] = CSD_Config(MATPATH);

    % get lfp and wave data
    [trialAll, LFPDataset] = CSD_Preprocess(DATAPATH);
    trialAll(1) = [];
    [~, WAVEDataset] = MUA_Preprocess(DATAPATH);
    window = [-100 500];
    selWin = [-20 , 150];
    trialsLFP = selectEcog(LFPDataset, trialAll, "trial onset", window);
    trialsWAVE = selectEcog(WAVEDataset, trialAll, "trial onset", window);

    % compute CSD and MUA
    [CSD, LFP] = CSD_Process(trialsLFP, window, CSD_Method, badCh, dz);
    MUA = MUA_Process(trialsWAVE, window, WAVEDataset.fs);

    % plot LFP_Wave, LFP_Image, CSD and MUA
    FigCSD = MLA_Plot_LFP_CSD_MUA(LFP, CSD, MUA, selWin);
    print(FigCSD, FIGNAME, "-djpeg", "-r300");

    close all;
end

end