function MUA = MUA_Process(trialsWave, window, fs)
trialsWave = cellfun(@(x) double(x), trialsWave, "UniformOutput", false);

bpFilt = designfilt('bandpassfir','FilterOrder',100, ...
    'CutoffFrequency1',500,'CutoffFrequency2',5000, ...
    'SampleRate', fs);

lpFilt = designfilt('lowpassfir','FilterOrder',50, ...
    'CutoffFrequency',200, 'SampleRate',fs);

temp = cellfun(@(x) MUA_Compute(x, bpFilt, lpFilt), trialsWave, "UniformOutput", false);
waveTemp = cellfun(@(x) interp2(x, 3), temp, "UniformOutput", false);

MUA.Wave = cell2mat(cellfun(@mean, changeCellRowNum(temp), "uni", false));
MUA.Data = cell2mat(cellfun(@mean, changeCellRowNum(waveTemp), "uni", false));
MUA.Chs = 1 : size(trialsWave{1}, 1);
MUA.tImage = linspace(window(1), window(2), size(MUA.Data, 2));
MUA.tWave = linspace(window(1), window(2), size(MUA.Wave, 2));
end