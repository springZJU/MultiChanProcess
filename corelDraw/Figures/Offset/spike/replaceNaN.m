function data = replaceNaN(data, val)
idx = isnan(data);
data(idx) = val;
end