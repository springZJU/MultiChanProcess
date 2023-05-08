clear ; clc
% %% DDZ
% recordPath = strcat(fileparts(fileparts(mfilename("fullpath"))), "\utils\MLA_New_DDZ_Recording.xlsx");
% recordInfo = table2struct(readtable(recordPath));
% sort = [recordInfo.sort]';
% exported = [recordInfo.exported]';
% isECoG = [recordInfo.isECoG]';
% iIndex = find(sort == 1 & exported == 0 & isECoG == 0);  % export sorted and unprocessed spike data
% 
% % export sorted and unprocessed spike data 
% for i = iIndex'
%     disp(strcat("processing ", recordInfo(i).BLOCKPATH, "... (", num2str(i), "/", num2str(max(iIndex)), ")"));
%     recordInfo = table2struct(readtable(recordPath));
%     saveXlsxRecordingData_MonkeyLA(recordInfo, i, recordPath);
% end
% 
% %% DD
% recordPath = strcat(fileparts(fileparts(mfilename("fullpath"))), "\utils\MLA_New_DD_Recording.xlsx");
% recordInfo = table2struct(readtable(recordPath));
% sort = [recordInfo.sort]';
% exported = [recordInfo.exported]';
% isECoG = [recordInfo.isECoG]';
% iIndex = find(sort == 1 & exported == 0 & isECoG == 0);  % export sorted and unprocessed spike data
% 
% % export sorted and unprocessed spike data 
% for i = iIndex'
%     disp(strcat("processing ", recordInfo(i).BLOCKPATH, "... (", num2str(i), "/", num2str(max(iIndex)), ")"));
%     recordInfo = table2struct(readtable(recordPath));
%     saveXlsxRecordingData_MonkeyLA(recordInfo, i, recordPath);
% end

%% CM
recordPath = strcat(fileparts(fileparts(mfilename("fullpath"))), "\utils\MLA_New_CM_Recording.xlsx");
recordInfo = table2struct(readtable(recordPath));
sort = [recordInfo.sort]';
exported = [recordInfo.exported]';
isECoG = [recordInfo.isECoG]';
iIndex = find(sort == 1 & exported == 0 & isECoG == 0);  % export sorted and unprocessed spike data

% export sorted and unprocessed spike data 
for i = iIndex'
    disp(strcat("processing ", recordInfo(i).BLOCKPATH, "... (", num2str(i), "/", num2str(max(iIndex)), ")"));
    recordInfo = table2struct(readtable(recordPath));
    saveXlsxRecordingData_MonkeyLA(recordInfo, i, recordPath);
end




