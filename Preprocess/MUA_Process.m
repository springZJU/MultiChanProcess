function MUA = MUA_Process(trialsWave, window, selWin, fs, fd)
narginchk(4, 5);
trialsWave = cellfun(@(x) double(x), trialsWave, "UniformOutput", false);

bpFilt = designfilt('bandpassfir','FilterOrder',100, ...
    'CutoffFrequency1',500,'CutoffFrequency2',5000, ...
    'SampleRate', fs);

lpFilt = designfilt('lowpassfir','FilterOrder',50, ...
    'CutoffFrequency',200, 'SampleRate',fs);


temp = cellfun(@(x) MUA_Compute(x, bpFilt, lpFilt), trialsWave, "UniformOutput", false);
if nargin < 5
    fd = fs;
end
MUA.rawWave = ECOGResample(changeCellRowNum(temp), fd, fs);
t = linspace(window(1), window(2), size(MUA.rawWave{1}, 2));
tIndex = t < selWin(1);

meanWave = cell2mat(cellfun(@mean, MUA.rawWave, "uni", false));
% waveTemp = cellfun(@(x) interp2(x, 3), temp, "UniformOutput", false);
% MUA.Data = cell2mat(cellfun(@mean, changeCellRowNum(waveTemp), "uni", false));
temp = meanWave - repmat(mean(meanWave(:, tIndex), 2), 1, size(meanWave, 2));
MUA.Wave = meanWave;
MUA.Data = interp2(temp, 3);
MUA.Chs = 1 : size(trialsWave{1}, 1);
MUA.tImage = linspace(window(1), window(2), size(MUA.Data, 2));
MUA.tWave = linspace(window(1), window(2), size(MUA.Wave, 2));
MUA.fs =fs;
end