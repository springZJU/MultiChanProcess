function [slope, intercept, R2, R2Adj, p] = mFitlm(x, y)
mdl = fitlm(x, y);
slope = mdl.Coefficients.Estimate(2);
intercept = mdl.Coefficients.Estimate(1);
R2 = mdl.Rsquared.Ordinary;
R2Adj = mdl.Rsquared.Adjusted;
p = coefTest(mdl);
end