%% CSD Construction
function h_main=CSD_construction(data_name,varargin)
for ii = 1:2:length(varargin)
    eval([varargin{ii} '=varargin{ii+1};']);
end
    
load(data_name)
lfp=lfp_mean;
MUA = MUA_mean;
% lfp - local field potential response to bar at center of receptive field
% depth - um 
% dz - spacing of channels
% tt - time from bar stimulus onset

depth = depth*cosd(0); %correct for manipulator angle (degree from vertical)

%% estimate CSD
% 5 point hamming filter from Ulbert et al. J Neurosci Methoods 2001 
% ('Multiple microelectrode-recording system for intracortical 
% applications') - equation 5 for spatial smoothing of signal
switch tradMethod
    case 'five point'
w = -1*[0.23, 0.08, -0.62, 0.08, .23];
for i = 1:size(lfp,1)
    if i-2>0 && i+2<size(lfp,1)+1
        u1 = lfp(i-2,:);
        u2 = lfp(i-1,:);
        u3 = lfp(i,:);
        u4 = lfp(i+1,:);
        u5 = lfp(i+2,:);
        CSD(i,:) = -(w(1)*u1 + w(2)*u2 + w(3)*u3 + w(4)*u4 +w(5)*u5)/(2*dz*2*dz);
    end
end
CSD = CSD(3:end,:);
    case 'three point'
w = -1*[ 0.23, -0.54, 0.23];
for i = 1:size(lfp,1)
    if i-1>0 && i+1<size(lfp,1)+1
       
        u1 = lfp(i-1,:);
        u2 = lfp(i,:);
        u3 = lfp(i+1,:);
      
        CSD(i,:) = -( w(1)*u1 + w(2)*u2 + w(3)*u3 )/(2*dz*2*dz);
    end
end

CSD = CSD(2:end,:);
end

%% plot LFP and CSD as function of depth
z = [depth-dz*15:dz:depth];
v=3; % interpolation factor
h_main=figure

subplot('position',[0.03 0.1 0.22 0.8])
y_max=max(max(lfp));
y_min=min(min(lfp));
y_abs=y_max-y_min;
for i=1:size(lfp,1)
    plot(tt*1000,(size(lfp,1)+1-i)*y_abs*ones(1,size(lfp,2)),'b--','linewidth',2); hold on
    plot(tt*1000,(size(lfp,1)+1-i)*y_abs+lfp(i,:),'k-','linewidth',3); hold on
end
% ylim([z(3) z(end-2)])
xlabel('time (ms)')
ylabel('depth')
    set(gca,'YTickLabel','');
%     set(gca,'XTickLabel','');
title('LFP (\muV)')



subplot('position',[0.27 0.1 0.22 0.8])
if isnan(z)
    z = [1:1:32];
end
imagesc(tt*1000, z, interp2(-1*lfp,v))
Ax = gca;
set(Ax,'CLim',[-abs(max(max(interp2(-1*lfp,v)))) abs(max(max(interp2(-1*lfp,v))))]);
ylim([z(3) z(end-2)])
xlabel('time (ms)')
ylabel('depth')
title('LFP (\muV)')
    set(gca,'YTickLabel','');
%     set(gca,'XTickLabel','');

switch tradMethod
    case 'five point'
    subplot('position',[0.53 0.2 0.22 0.6])
    plotMinus = 2;
    case 'three point'
    subplot('position',[0.53 0.15 0.22 0.7])
    plotMinus = 1;
end
imagesc(tt*1000, z(3:end-2), interp2(CSD,v)); hold on 
 set(gca,'YTickLabel','');
 Ax = gca;
set(Ax,'CLim',[-abs(max(max(interp2(CSD,v)))) abs(max(max(interp2(CSD,v))))]);

colorbar
xlabel('time (ms)')
ylabel('depth')
colormap('jet')
title('CSD')
    set(gca,'YTickLabel','');
%     set(gca,'XTickLabel','');

h = colorbar;
h.Ticks =  h.Limits;
h.TickLabels = {'sourse' 'sink'};
% 
%  % Plot spike firing rate
% subplot('position',[0.77 0.1 0.22 0.8])
% psthMax = max(cell2mat(cellfun(@(x) max(x),SpkPsth.res,'UniformOutput',false)));
% nullIdx = find(cellfun(@isempty,SpkPsth.res));
% for idx = 1:length(nullIdx)
%     SpkPsth.res{nullIdx(idx)} = zeros(length(SpkPsth.T{idx}(:,3)),1);
% end
% psthArray = cell2mat(SpkPsth.res);
% psthArray = psthArray';
% imagesc(tt*1000, z, interp2(psthArray,v));
% Ax = gca;
% set(Ax,'CLim',[-abs(max(max(interp2(psthArray,v)))) abs(max(max(interp2(psthArray,v))))]);
% ylim([z(3) z(end-2)])
% xlabel('time (ms)')
%  set(gca,'YTickLabel','');
%  title('Firing Rate')
% colormap(Ax,'hot')

%  %% Plot MUA
% subplot('position',[0.77 0.1 0.22 0.8])
% imagesc(mtt*1000, z, interp2(MUA,v))
% Ax = gca;
% % set(Ax,'CLim',[0 abs(max(max(interp2(MUA,v))))]);
% set(Ax,'CLim',[0 2e-6]);
% ylim([z(3) z(end-2)])
% xlabel('time (ms)')
% ylabel('depth')
%  title('MUA')
%     set(gca,'YTickLabel','');
% %     set(gca,'XTickLabel','');
% colormap(Ax,'hot')

subplot('position',[0.77 0.1 0.22 0.8])
y_max=max(max(MUA));
y_min=min(min(MUA));
y_abs=y_max-y_min;
for i=1:size(MUA,1)
    plot(tt*1000,(size(MUA,1)+1-i)*y_abs*ones(1,size(MUA,2)),'b--','linewidth',2); hold on
    plot(tt*1000,(size(MUA,1)+1-i)*y_abs+MUA(i,:),'k-','linewidth',3); hold on
end
% ylim([z(3) z(end-2)])
xlabel('time (ms)')
ylabel('depth')
    set(gca,'YTickLabel','');
%     set(gca,'XTickLabel','');
title('MUA (\muV)')

