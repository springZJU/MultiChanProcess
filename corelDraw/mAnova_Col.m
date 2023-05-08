function p = mAnova_Col(data)
    for cIndex = 1 : size(data, 2)
        buffer{cIndex, 1} = [data(:, cIndex), (cIndex-1)*ones(size(data, 1), 1)];
    end
    temp = cell2mat(buffer);
    p = anova1(temp(:, 1), temp(:, 2),"off");
end