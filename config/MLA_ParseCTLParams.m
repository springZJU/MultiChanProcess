function [S1Duration, Window, Offset, trialTypes] = MLA_ParseCTLParams(protStr)

% load excel
configPath = strcat(fileparts(fileparts(mfilename("fullpath"))), "\config\MLA_CTLConfig.xlsx");
configTable = table2struct(readtable(configPath));
mProtocol = configTable(matches({configTable.paradigm}', protStr));

% parse CTLProt
S1Duration = str2double(string(strsplit(mProtocol.S1Duration, ",")));
Window = str2double(string(strsplit(mProtocol.Window, ",")));
Offset = str2double(string(strsplit(mProtocol.Offset, ",")));
trialTypes = strrep(string(strsplit(mProtocol.trialTypes, ",")), "_", "-");
end

