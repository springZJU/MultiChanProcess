clear res
data = [zeros(1, 100), 1, zeros(1,100)]';
res(:,1) = smoothdata(data, "gaussian", 101);
res(:, 2) = mGaussionFilter(data, 101/5, 101)*100;