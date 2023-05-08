function [slope, intercept, R2, R2Adj, p] = mFitlm(x, y)
mdl = fitlm(x, y);
slope = mdl.Coefficients.Estimate(2);
intercept = mdl.Coefficients.Estimate(1);
R2 = mdl.Rsquared.Ordinary;
R2Adj = mdl.Rsquared.Adjusted;
if length(y) == 2
    p = 0;
else
p = coefTest(mdl);
end
end