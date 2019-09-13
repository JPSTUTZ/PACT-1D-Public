function [ years, months, days, hours, seconds, minutes, datenum_val] = get_times( Times )


years=str2double(cellstr(num2str(Times(:,1:4))));
months=str2double(cellstr(num2str(Times(:,6:7))));
days=str2double(cellstr(num2str(Times(:,9:10))));
hours=str2double(cellstr(num2str(Times(:,12:13))));
minutes=str2double(cellstr(num2str(Times(:,15:16))));
seconds=str2double(cellstr(num2str(Times(:,18:19))));

datenum_val = datenum(years,months,days,hours,minutes,seconds);
%datestr(datenum_str)

end

