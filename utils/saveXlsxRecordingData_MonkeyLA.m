function saveXlsxRecordingData_MonkeyLA(recordInfo, idx, recordPath)
e = [];
BLOCKPATH = recordInfo(idx).BLOCKPATH;
sitePos = recordInfo(idx).sitePos;
depth = recordInfo(idx).depth;
paradigm = recordInfo(idx).paradigm;
temp = strsplit(BLOCKPATH, "\");
animalID = temp{end - 2};
dateStr = temp{end - 1};

buffer=TDTbin2mat(BLOCKPATH);  %spike store name should be changed according to your real name

%% lfp sample rate patching
if matches(dateStr, ["cm20230329", "cm20230322"])
    buffer.streams.Llfp.fs = 2034.5052;
end

%% try to get epocs
try
    data.epocs = buffer.epocs;
catch e
    disp(e.message);
end

%% try to get raw spike data
try
    data.spikeRaw.snips = buffer.snips;
catch e
    disp(e.message);
end

%% try to get sort data
% sort data
SORTPATH = fullfile(BLOCKPATH, "sortdata.mat");
try
    load(SORTPATH);
    data.sortdata = sortdata;
catch e
    disp(e.message);
end

% spike waveform
try
    data.spkWave = spkWave;
catch e
    disp(e.message);
end
%% try to get lfp data
try
    data.lfp = ECOGResample(buffer.streams.Llfp, 1000);
catch e
    disp(e.message);
end

%% try to get Wave data for CSD
if contains(paradigm, 'CSD')
    try 
        data.Wave = buffer.streams.Wave;
    catch e
        disp(e.message);
    end
end


%% save params
params.BLOCKPATH = BLOCKPATH;
params.paradigm = paradigm;
params.sitePos = sitePos;
params.depth = depth;
params.animalID = animalID;
params.dateStr = dateStr;
data.params = params;

%% export result
if contains(paradigm, ["PEOdd7-10_Active", "PEOdd7-10_Passive"])
    SAVEPATH = strcat("E:\MonkeyLinearArray\MAT Data\", animalID, "\PEOdd_Behavior\", paradigm, "\", dateStr, "_", sitePos);
else
    SAVEPATH = strcat("E:\MonkeyLinearArray\MAT Data\", animalID, "\CTL_New\", paradigm, "\", dateStr, "_", sitePos);
end
mkdir(SAVEPATH);
save(fullfile(SAVEPATH, "data.mat"), "data", "-mat");
recordInfo(idx).exported = 1;
if isempty(e)
    writetable(struct2table(recordInfo), recordPath);
end
end
