function [trialAll, WaveDataset] = MUA_Preprocess(MATPATH)
%% Parameter settings
processFcn = @PassiveProcess_NoiseTone;

%% Validation
if isempty(processFcn)
    error("Process function is not specified");
end

%% Loading data
try
    disp("Try loading data from MAT");
    load(strcat(MATPATH, "data.mat"));
    WaveDataset = data.Wave;
    epocs = data.epocs;
    trialAll = processFcn(epocs);
catch e
    disp(e.message);
    disp("Try loading data from TDT BLOCK...");
    temp = TDTbin2mat(char(MATPATH), 'TYPE', {'epocs'});
    epocs = temp.epocs;
    trialAll = processFcn(epocs);
    temp = TDTbin2mat(char(MATPATH), 'TYPE', {'streams'});
    streams = temp.streams;
    WaveDataset = streams.Wave;
end
return;
end