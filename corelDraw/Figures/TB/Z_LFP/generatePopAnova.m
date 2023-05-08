clear bufferAnova anovaP
layers = ["Sg", "Gr", "Ig"];
sigString = ["LFP", "CSD", "MUA"];
for sIdx = 1 : length(sigString)
for i = 1 : length(anovaIdx)
    bufferAnova.(sigString(sIdx))(1).data{i,1} = TBIs(anovaIdx(i)).(sigString(sIdx))(1).poolData; % Sg
    bufferAnova.(sigString(sIdx))(1).n{i,1} = ones(length(TBIs(anovaIdx(i)).(sigString(sIdx))(1).poolData), 1)*i; % Sg
    bufferAnova.(sigString(sIdx))(2).data{i,1} = TBIs(anovaIdx(i)).(sigString(sIdx))(2).poolData; % Gr
    bufferAnova.(sigString(sIdx))(2).n{i,1} = ones(length(TBIs(anovaIdx(i)).(sigString(sIdx))(2).poolData), 1)*i; % Sg
    bufferAnova.(sigString(sIdx))(3).data{i,1} = TBIs(anovaIdx(i)).(sigString(sIdx))(3).poolData; % Ig
    bufferAnova.(sigString(sIdx))(3).n{i,1} = ones(length(TBIs(anovaIdx(i)).(sigString(sIdx))(3).poolData), 1)*i; % Sg
end

for lIndex = 1 : length(layers)
anovaP.(sigString(sIdx))(lIndex).info = layers(lIndex);
anovaP.(sigString(sIdx))(lIndex).p = anova1(cell2mat(bufferAnova.(sigString(sIdx))(lIndex).data), cell2mat(bufferAnova.(sigString(sIdx))(lIndex).n), "off");
end
end