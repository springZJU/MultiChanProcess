clear all; clc
recordPath = "E:\MonkeyLinearArray\LAProcess\utils\LinearArrayRecording.xlsx";
recordInfo = table2struct(readtable(recordPath));
sort = [recordInfo.sort]';
processed = [recordInfo.processed]';
validated = [recordInfo.validateSounds]';
isECoG = [recordInfo.isECoG]';
iIndex = find(sort == 1 & processed == 0 & isECoG == 0);  % export sorted and unprocessed spike data

%% export sorted and unprocessed spike data 
for i = iIndex'
    disp(strcat("processing ", recordInfo(i).BLOCKPATH, "... (", num2str(i), "/", num2str(max(iIndex)), ")"));
    recordInfo = table2struct(readtable(recordPath));
    saveXlsxRecordingData_MonkeyLA(recordInfo, i, recordPath);
end





