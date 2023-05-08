layers = {'Sg', 'Gr', 'Ig'};

for layer = 1 : length(layers)
Fig = figure;
maximizeFig(Fig)
for i = 1 : length(popRes)
    mSubplot(5,5,i, [1, 1], [0.02, 0.02, 0.15, 0.15]);
    plot(plotCSD(2).tWave, plotCSD(5).([layers{layer}, 'Wave'])(:, i)); hold on
    plot(plotMUA(2).tWave, plotMUA(5).([layers{layer}, 'Wave'])(:, i), "r-");
    title([layers{layer}, '-' popRes(i).Date, '-', popRes(i).SitePos, '-', num2str(popRes(i).CF)]);
    xlim([-50, 300]);
    ylim([-10, 10]);
end
end
%%
figure
for i = 1 : 25
subplot(5,5,i);
temp = changeCellRowNum(popRes(16).chCSD(5).chCSD.Wave);
signal = temp{11, 1};
plot(plotCSD(2).tWave, signal(i, :));
title(num2str(i));
xlim([-50, 300]);
ylim([-200, 200]);
end

% %%
% figure
% for i = 1 : 25
% subplot(5,5,i);
% temp = rawWave;
% signal = temp{10, 1};
% plot(plotCSD(2).tWave, signal(i, :));
% title(num2str(i));
% xlim([-50, 300]);
% ylim([-200, 200]);
% end