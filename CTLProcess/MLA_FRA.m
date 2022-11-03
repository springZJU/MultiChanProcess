function MLA_FRA(MATPATH, FIGPATH)
%% Parameter setting

temp = strsplit(MATPATH, "\");
dateStr = string(temp{end - 1});
DATAPATH = strcat(MATPATH, "data.mat");
FIGPATH = strcat(FIGPATH, dateStr, "\");

%% plot FRA
[Fig, ch] = sFRA(DATAPATH);

%% save figures
mkdir(FIGPATH);
for cIndex = 1 : length(Fig)
    print(Fig(cIndex), strcat(FIGPATH,"ch", num2str(ch(cIndex) + 1)), "-djpeg", "-r200");
end

close all
end