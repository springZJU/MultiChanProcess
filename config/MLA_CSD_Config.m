function [badCh, dz] = MLA_CSD_Config(MATPATH)
if contains(MATPATH, "DDZ")
    recordPath = strcat(fileparts(fileparts(mfilename("fullpath"))), "\utils\MLA_New_DDZ_Recording.xlsx");
elseif contains(MATPATH, "DD")
    recordPath = strcat(fileparts(fileparts(mfilename("fullpath"))), "\utils\MLA_New_DD_Recording.xlsx");
elseif contains(MATPATH, "CM")
    recordPath = strcat(fileparts(fileparts(mfilename("fullpath"))), "\utils\MLA_New_CM_Recording.xlsx");

end
[~, opts] = getTableValType(recordPath, "0");
recordInfo = table2struct(readtable(recordPath, opts));


temp = strsplit(MATPATH, "\");
dateStr = string(temp{end - 1});
Date = string(strsplit(dateStr, "_"));
Date = Date(1);

BLOCKPATH = string({recordInfo.BLOCKPATH})';
dIndex = contains(BLOCKPATH, Date);
if any(dIndex)
    string([recordInfo(dIndex).badChannel]);
    badCh = unique([recordInfo(dIndex).badChannel]);
    badCh = str2double(strsplit(badCh, ","));
    if badCh <= 0
        badCh = [];
    end
    dz = unique([recordInfo(dIndex).dz])/1000;
else
    badCh = 13;
    dz = 0.15;
end
return
end


