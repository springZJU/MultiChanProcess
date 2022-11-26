function [badCh, dz] = CSD_Config(MATPATH)
if contains(MATPATH, "DDZ")
    recordPath = strcat(fileparts(fileparts(mfilename("fullpath"))), "\utils\MLA_New_DDZ_Recording.xlsx");
elseif contains(MATPATH, "DD")
    recordPath = strcat(fileparts(fileparts(mfilename("fullpath"))), "\utils\MLA_New_DD_Recording.xlsx");
end
recordInfo = table2struct(readtable(recordPath));

temp = strsplit(MATPATH, "\");
dateStr = string(temp{end - 1});
Date = string(strsplit(dateStr, "_"));
Date = Date(1);

BLOCKPATH = string({recordInfo.BLOCKPATH})';
dIndex = contains(BLOCKPATH, Date);
if any(dIndex)
    badCh = unique([recordInfo(dIndex).badChannel]);
    dz = unique([recordInfo(dIndex).dz])/1000;
else
    badCh = 9;
    dz = 0.15;
end
return
end


