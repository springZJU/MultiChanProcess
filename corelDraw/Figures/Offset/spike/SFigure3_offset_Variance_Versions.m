chSelect = "CH10";
regPath = "E:\MonkeyLinearArray\Figure\CTL_New\Offset_Variance_Effect_4ms_16ms_sigma250_2_500msReg\cm20230310_A49R17";
diffVarPath = "E:\MonkeyLinearArray\Figure\CTL_New\Offset_Variance_Effect_4ms_sigma50_2_500msReg\cm20230310_A49R17";
regData = load(strcat(regPath, "\res.mat"));
diffVarData = load(strcat(diffVarPath, "\res.mat"));
temp = regData.chSpikeLfp(10).chSPK;
chIdx = matches(string({temp.info}'), chSelect);
psth.Reg = temp(chIdx).PSTH;
for vIndex = 1 : length(diffVarData.chSpikeLfp)
    psth.Var(vIndex).info = diffVarData.chSpikeLfp(vIndex).stimStr;
    psth.Var(vIndex).psth = diffVarData.chSpikeLfp(vIndex).chSPK(chIdx).PSTH;
end


psth.VarMean(1).info = erase(psth.Var(1).info, "-v1");
temp = cell2mat(cellfun(@(x) x(:, 2), {psth.Var(1:2:9).psth}, "UniformOutput", false));
psth.VarMean(1).psth = [psth.Var(1).psth(:, 1), mean(temp, 2), SE(temp, 2)];
psth.VarMean(2).info = erase(psth.Var(2).info, "-v1");
temp = cell2mat(cellfun(@(x) x(:, 2), {psth.Var(2:2:10).psth}, "UniformOutput", false));
psth.VarMean(2).psth = [psth.Var(2).psth(:, 1), mean(temp, 2), SE(temp, 2)];
