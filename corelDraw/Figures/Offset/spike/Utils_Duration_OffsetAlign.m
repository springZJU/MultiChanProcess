temp = toPlot(96).raster;
% dur = num2cell([1021.1, 508.5, 252.2, 124, 60.1, 28, 12, 4, 0])';
dur = num2cell([1008.3, 496.2, 240.1, 112, 48, 16, 0])';
cellfun(@(x, y) x(:, 1)-y, temp(:, 2), dur, "UniformOutput", false);