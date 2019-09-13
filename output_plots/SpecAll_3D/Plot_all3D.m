function [ p_handle, f_handle ] = Plot_3D(time, BOXCH, Conc, SpecName,SubplotNum)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


title_arr=[SpecName ' (ppb)'];

% figure('Name',PlotName);
f_handle=gcf;


colormap jet;
contourf(time,BOXCH,Conc/2.5e10,25,'ShowText','off','LineColor','none' );

%% shape structure
%--- Select time tick size ------
total_hours=(time(end)-time(1))*24;
if (total_hours > 6) 
    temp= floor(total_hours/6)+1; 
    time_tick=temp/24;
else
    time_tick=2/24;
end  

xlim([time(1) time(end)]);
ylabel('alt (m)');
title(title_arr);
colorbar;
t_tick=(time(1): time_tick : time(end));
    if SubplotNum == 7 | SubplotNum == 8
        xlabel('Local time');
        set(gca,'XTick',t_tick);
        set(gca,'TickDir','out');
        datetick('x','HH:MM','keepticks','keeplimits');
    else
        set(gca,'XTick',t_tick);
        set(gca,'TickDir','out');
        set(gca,'xticklabel',[])
% datetick('x','HH:MM','keepticks','keeplimits');
    end

% legend(leg_arr);

p_handle=gca;


end

