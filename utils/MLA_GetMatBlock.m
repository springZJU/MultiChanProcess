function BLOCK = MLA_GetMatBlock(MATPATH)

%% select excel
if contains(MATPATH, "DDZ")
    recordPath = strcat(fileparts(fileparts(mfilename("fullpath"))), "\utils\MLA_New_DDZ_Recording.xlsx");
elseif contains(MATPATH, "DD")
    recordPath = strcat(fileparts(fileparts(mfilename("fullpath"))), "\utils\MLA_New_DD_Recording.xlsx");
elseif contains(MATPATH, "CM")
    recordPath = strcat(fileparts(fileparts(mfilename("fullpath"))), "\utils\MLA_New_CM_Recording.xlsx");
end
%% read excel
recordInfo = table2struct(readtable(recordPath));
BLOCKPATH = {recordInfo.BLOCKPATH}';
paradigm = {recordInfo.paradigm}';

%% split MATPATH
temp = string(strsplit(MATPATH, "\"));
protocol = temp(end - 2);
dateTemp = strsplit(temp(end - 1), "_");
DateStr = dateTemp(end - 1);

%% find corresponding block
pIndex = contains(BLOCKPATH, DateStr) & matches(paradigm, protocol);
BLOCK = recordInfo(pIndex).BLOCKPATH;
end