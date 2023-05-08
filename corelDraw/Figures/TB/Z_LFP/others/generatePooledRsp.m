PooledRsp.SgCSD = vertcat(plotCSD(idx).SgRspPool);
PooledRsp.GrCSD = vertcat(plotCSD(idx).GrRspPool);
PooledRsp.IgCSD = vertcat(plotCSD(idx).IgRspPool);
PooledRsp.AllCSD = vertcat(plotCSD(idx).AllRspPool);

PooledRsp.SgMUA = vertcat(plotMUA(idx).SgRspPool);
PooledRsp.GrMUA = vertcat(plotMUA(idx).GrRspPool);
PooledRsp.IgMUA = vertcat(plotMUA(idx).IgRspPool);
PooledRsp.AllMUA = vertcat(plotMUA(idx).AllRspPool);

% MUA
PooledRsp.SgMUARaw = [plotMUA.SgRsp];
PooledRsp.SgMUARaw = PooledRsp.SgMUARaw(:, idx);
PooledRsp.GrMUARaw = [plotMUA.GrRsp];
PooledRsp.GrMUARaw = PooledRsp.GrMUARaw(:, idx);
PooledRsp.IgMUARaw = [plotMUA.IgRsp];
PooledRsp.IgMUARaw = PooledRsp.IgMUARaw(:, idx);
PooledRsp.AllMUARaw = [plotMUA.AllRsp];
PooledRsp.AllMUARaw = PooledRsp.AllMUARaw(:, idx);
% CSD
PooledRsp.SgCSDRaw = [plotCSD.SgRsp];
PooledRsp.SgCSDRaw = PooledRsp.SgCSDRaw(:, idx);
PooledRsp.GrCSDRaw = [plotCSD.GrRsp];
PooledRsp.GrCSDRaw = PooledRsp.GrCSDRaw(:, idx);
PooledRsp.IgCSDRaw = [plotCSD.IgRsp];
PooledRsp.IgCSDRaw = PooledRsp.IgCSDRaw(:, idx);
PooledRsp.AllCSDRaw = [plotCSD.AllRsp];
PooledRsp.AllCSDRaw = PooledRsp.AllCSDRaw(:, idx);