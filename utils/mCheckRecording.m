clc; clear;
cd(fileparts(mfilename("fullpath")));
xlsxPath = ".\MLA_New_DDZ_Recording.xlsx";
xlsxContent = table2struct(readtable(xlsxPath));
recordNumber = length(unique({xlsxContent.sitePos}'));
