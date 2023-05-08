% amp regression
% [slope.Sg, intercept.Sg, R2.Sg, R2Adj.Sg, p.Sg] = cellfun(@(y) mFitlm(x,y), num2cell(PooledRsp.SgMUARaw(:, slopeIdx), 2), "UniformOutput", false);
% [slope.Gr, intercept.Gr, R2.Gr, R2Adj.Gr, p.Gr] = cellfun(@(y) mFitlm(x,y), num2cell(PooledRsp.GrMUARaw(:, slopeIdx), 2), "UniformOutput", false);
% [slope.Ig, intercept.Ig, R2.Ig, R2Adj.Ig, p.Ig] = cellfun(@(y) mFitlm(x,y), num2cell(PooledRsp.IgMUARaw(:, slopeIdx), 2), "UniformOutput", false);
% [slope.All, intercept.All, R2.All, R2Adj.All, p.All] = cellfun(@(y) mFitlm(x,y), num2cell(PooledRsp.AllMUARaw(:, slopeIdx), 2), "UniformOutput", false);

slope.Sg = {diff(PooledRsp.SgMUARaw(:, slopeIdx), 1, 2)};
slope.Gr = {diff(PooledRsp.GrMUARaw(:, slopeIdx), 1, 2)};
slope.Ig = {diff(PooledRsp.IgMUARaw(:, slopeIdx), 1, 2)};
slope.All = {diff(PooledRsp.AllMUARaw(:, slopeIdx), 1, 2)};

slope.meanSg = mean(cell2mat(slope.Sg));
slope.meanGr = mean(cell2mat(slope.Gr));
slope.meanIg = mean(cell2mat(slope.Ig));
slope.meanAll = mean(cell2mat(slope.All));

h(1).info = "slope";
p(1).info = "slope";
[h(1).Sg_Gr, p(1).Sg_Gr] = ttest(cell2mat(slope.Sg), cell2mat(slope.Gr));
[h(1).Sg_Ig, p(1).Sg_Ig] = ttest(cell2mat(slope.Sg), cell2mat(slope.Ig));
[h(1).Gr_Ig, p(1).Gr_Ig] = ttest(cell2mat(slope.Gr), cell2mat(slope.Ig));


% sum amp

Amp.Sg = [mean(PooledRsp.SgMUARaw(:, ampIdx), 2), std(PooledRsp.SgMUARaw(:, ampIdx), 1, 2)];
Amp.Gr = [mean(PooledRsp.GrMUARaw(:, ampIdx), 2), std(PooledRsp.GrMUARaw(:, ampIdx), 1, 2)];
Amp.Ig = [mean(PooledRsp.IgMUARaw(:, ampIdx), 2), std(PooledRsp.IgMUARaw(:, ampIdx), 1, 2)];
Amp.All = [mean(PooledRsp.AllMUARaw(:, ampIdx), 2), std(PooledRsp.AllMUARaw(:, ampIdx), 1, 2)];
h(2).info = "amp";
p(2).info = "amp";
[h(2).Sg_Gr, p(2).Sg_Gr] = ttest(Amp.Sg(:, 1), Amp.Gr(:, 1));
[h(2).Sg_Ig, p(2).Sg_Ig] = ttest(Amp.Sg(:, 1), Amp.Ig(:, 1));
[h(2).Gr_Ig, p(2).Gr_Ig] = ttest(Amp.Gr(:, 1), Amp.Ig(:, 1));



