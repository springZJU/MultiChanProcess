monkeyName = "DDZ";
recordPath = strcat("E:\MonkeyLinearArray\MultiChanProcess\corelDraw\MLA_", monkeyName, "_NeuronSelect.xlsx");
recordInfo = table2struct(readtable(recordPath));
siteCF = uniqueRowsCA([{recordInfo.Date}', {recordInfo.CF}', {recordInfo.SitePos}']);
dSitePos = getPosAxis(cellfun(@(x) strsplit(x, {'A', 'R'}), siteCF(:, 3), "UniformOutput", false));
dSitePos(:, 3) = cell2mat(siteCF(:, 2));


Fig = figure;
maximizeFig(Fig);
mkrSize = 100;
scatter(dSitePos(:, 2), dSitePos(:, 1), mkrSize,'black', "filled"); hold on
set(gca,'XDir','reverse')
set(gca,'YDir','reverse')
xWin = [10, 18];
yWin = [42, 54];
xlim(xWin);
ylim(yWin);

% add CF inf
for i = 1 : size(dSitePos, 1)
    text(dSitePos(i, 2) - diff(xWin) / 50, dSitePos(i, 1) + diff(yWin) * (0.01 + mkrSize / 8000), num2str(siteCF{i, 2}), 'fontSize', 12);
end

%% color map
posCF = dSitePos;
posCF(10,:) = [];
posCF(isnan(posCF(:, 3)), :) = [];
mapX = [min(posCF(:, 2))-1, max(posCF(:, 2))+1];
mapY = [min(posCF(:, 1))-1, max(posCF(:, 1))+1];
%%
mapArray = ones(mapY(2), mapX(2));
for i = 1 : size(posCF, 1)
    mapArray(posCF(i, 1), posCF(i, 2)) = posCF(i, 3)/200;
end
mapArray = log10(mapArray)/log10(1.2);
% mapArray(:, 1:mapX(1)) = [];
% mapArray(1:mapX(2), :) = [];
% mapArray = interp2(mapArray, 3);
mapArray(mapArray==0) = nan;
% mapArray = inpaint_nans(mapArray, 0);
figure
h = imagesc(mapArray);
xlim(mapX);
ylim(mapY);
set(h,'alphadata',~isnan(mapArray));
set(gca,'XDir','reverse');
set(gca,'YDir','reverse');
set(gca,'CLim',[1, max(max(mapArray))]);
colormap("jet")
colorbar
%%
cfArray = mapArray;
splitBlock = 50;
filterSize = 10;
[m,n] = size(cfArray);
res = zeros(m*splitBlock,n*splitBlock);
for row = 1:m
for col = 1:n
    res((row-1)*splitBlock+1:row*splitBlock,(col-1)*splitBlock+1:col*splitBlock) = cfArray(row,col);
end
end

[resM, resN] = size(res);
filterRes = zeros(resM+2*filterSize,resN+2*filterSize)*nan;
filterRes(filterSize+1:filterSize+resM,filterSize+1:filterSize+resN) = res;
filterRes(isnan(filterRes)) = 0.1;
%     k = 1/(filterSize*filterSize)*ones(filterSize);
%     fff = conv2(filterRes,k,'same');
fff = imgaussfilt(filterRes,50,'FilterSize',201);
cfImage = fff;
figure
h = imagesc(cfImage);
% xlim(mapX*splitBlock);
% ylim(mapY*splitBlock);
set(h,'alphadata',cfImage>0.3);
set(gca,'XDir','reverse');
set(gca,'YDir','reverse');
% colormap("jet");