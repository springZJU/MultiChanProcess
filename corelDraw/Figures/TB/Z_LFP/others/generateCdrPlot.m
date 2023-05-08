cdrIdx = find(matches({popRes.Date}', selDate));
for i = 0 : length(idx)
    if i < 1
        % MUA
        cdrPlot(1).info = selDate;
        cdrPlot(1).SgMUA = plotMUA(1).tWave;
        cdrPlot(1).GrMUA = plotMUA(1).tWave;
        cdrPlot(1).IgMUA = plotMUA(1).tWave;
        cdrPlot(1).AllMUA = plotMUA(1).tWave;
        
        cdrPlot(2).info = "pop mean";
        cdrPlot(2).SgMUA = plotMUA(1).tWave;
        cdrPlot(2).GrMUA = plotMUA(1).tWave;
        cdrPlot(2).IgMUA = plotMUA(1).tWave;
        cdrPlot(2).AllMUA = plotMUA(1).tWave;
        
        % CSD
        cdrPlot(1).SgCSD = plotCSD(1).tWave;
        cdrPlot(1).GrCSD = plotCSD(1).tWave;
        cdrPlot(1).IgCSD = plotCSD(1).tWave;
        cdrPlot(1).AllCSD = plotCSD(1).tWave;

        cdrPlot(2).SgCSD = plotCSD(1).tWave;
        cdrPlot(2).GrCSD = plotCSD(1).tWave;
        cdrPlot(2).IgCSD = plotCSD(1).tWave;
        cdrPlot(2).AllCSD = plotCSD(1).tWave;
    else
        % MUA
        cdrPlot(1).SgMUA(:, 2*i) = plotMUA(idx(i)).SgWaveSmth(:, cdrIdx);
        cdrPlot(1).GrMUA(:, 2*i) = plotMUA(idx(i)).GrWaveSmth(:, cdrIdx);
        cdrPlot(1).IgMUA(:, 2*i) = plotMUA(idx(i)).IgWaveSmth(:, cdrIdx);
        cdrPlot(1).AllMUA(:, 2*i) = plotMUA(idx(i)).AllWaveSmth(:, cdrIdx);

        cdrPlot(2).SgMUA(:, [2*i, 2*i+1]) = plotMUA(idx(i)).SgMeanSmth;
        cdrPlot(2).GrMUA(:, [2*i, 2*i+1]) = plotMUA(idx(i)).GrMeanSmth;
        cdrPlot(2).IgMUA(:, [2*i, 2*i+1]) = plotMUA(idx(i)).IgMeanSmth;
        cdrPlot(2).AllMUA(:, [2*i, 2*i+1]) = plotMUA(idx(i)).AllMeanSmth;

        % CSD
        cdrPlot(1).SgCSD(:, 2*i) = plotCSD(idx(i)).SgWaveSmth(:, cdrIdx);
        cdrPlot(1).GrCSD(:, 2*i) = plotCSD(idx(i)).GrWaveSmth(:, cdrIdx);
        cdrPlot(1).IgCSD(:, 2*i) = plotCSD(idx(i)).IgWaveSmth(:, cdrIdx);
        cdrPlot(1).AllCSD(:, 2*i) = plotCSD(idx(i)).AllWaveSmth(:, cdrIdx);

        cdrPlot(2).SgCSD(:, [2*i, 2*i+1]) = plotCSD(idx(i)).SgMeanSmth;
        cdrPlot(2).GrCSD(:, [2*i, 2*i+1]) = plotCSD(idx(i)).GrMeanSmth;
        cdrPlot(2).IgCSD(:, [2*i, 2*i+1]) = plotCSD(idx(i)).IgMeanSmth;
        cdrPlot(2).AllCSD(:, [2*i, 2*i+1]) = plotCSD(idx(i)).AllMeanSmth;
    end
end
cdrPlot(1).MUARsp = {[PooledRsp.SgMUARaw(cdrIdx, :)', PooledRsp.GrMUARaw(cdrIdx, :)', PooledRsp.IgMUARaw(cdrIdx, :)', PooledRsp.AllMUARaw(cdrIdx, :)']};
cdrPlot(2).MUARsp = {[PooledRsp.SgMUA, PooledRsp.GrMUA, PooledRsp.IgMUA, PooledRsp.AllMUA]};
cdrPlot(1).CSDRsp = {[PooledRsp.SgCSDRaw(cdrIdx, :)', PooledRsp.GrCSDRaw(cdrIdx, :)', PooledRsp.IgCSDRaw(cdrIdx, :)', PooledRsp.AllCSDRaw(cdrIdx, :)']};
cdrPlot(2).CSDRsp = {[PooledRsp.SgCSD, PooledRsp.GrCSD, PooledRsp.IgCSD, PooledRsp.AllCSD]};