function [ p_handle, f_handle ] = Plot_T(time, BOXCH, H_Idx, Conc, SpecName,SubplotNum)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


leg_arr='';
yAxix_arr=[SpecName ' (ppb)'];

%--- Select time tick size ------
total_hours=(time(end)-time(1))*24;
if (total_hours > 6) 
    temp= floor(total_hours/6)+1; 
    time_tick=temp/24;
else
    time_tick=2/24;
end  

% figure('Name',PlotName);
f_handle=gcf;

for i=1:1:length(H_Idx)
%     plot(time,Conc(H_Idx(i),:)/2.5e10);  
    plot(time,Conc(H_Idx(i),:)/2.5e10); 
    if SubplotNum == 2
        %    leg_arr=[leg_arr; sprintf('%6.1f m', BOXCH(height_counter))];
        leg_arr=[leg_arr; sprintf('%6.2f m', BOXCH(H_Idx(i)))];
        lgd = legend(leg_arr,'Location','best');
        set(lgd,'FontSize',6);
    end
hold on
    
end

%% shape structure
% width=2000;
% height=500;
% left=20;
% bottem=10;
% set(gcf,'position',[left,bottem,width,height]);
% Format plot --------------------------------------------------------
% title(PlotTitle);

xlim([time(1) time(end)]);
ylabel(yAxix_arr);
t_tick=(time(1): time_tick : time(end));
    if SubplotNum == 7 | SubplotNum == 8
        xlabel('Local time');
        set(gca,'XTick',t_tick);
        set(gca,'TickDir','out');
%         datetick('keepticks');
% datetick('x','mm/dd HH:MM','keeplimits');
datetick('x','HH:MM','keepticks','keeplimits');
    else
        set(gca,'XTick',t_tick);
        set(gca,'TickDir','out');
        set(gca,'xticklabel',[])
    end

% legend(leg_arr);

p_handle=gca;


end

