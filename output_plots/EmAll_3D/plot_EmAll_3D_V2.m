close all
clear all

%plot species listed in the PlotSpec array at all altitudes (contour plot
%of time, altitude, and species conc - KBT 11/16/18

ncid = '..\..\output\emissions.nc';
finfo = ncinfo(ncid)
varNames = {finfo.Variables.Name};
spec_list = varNames(5:end);
n_spec = length(spec_list);
BOXCH=ncread(ncid,'BOXCH');
n_lev = length(BOXCH);
Times=ncread(ncid,'Times');
time=datenum(Times');

%--- Check for unfinished run, only use available times-----
spec_data=ncread(ncid,spec_list{1});
temp=squeeze(spec_data(1,:));
idx=find(temp == 9.9e36 | isnan(temp));
if(isempty(idx))
    time_length=length(temp)
else
    time_length=idx(1)-1;
end

%only plot species above a certain concentration limit 
conc_lim=100;
counter=1;
for j = 1:n_spec
    spec_data=ncread(ncid,spec_list{j});
    max(max(spec_data(:,1:time_length)))
    if(max(max(spec_data(:,1:time_length))) > conc_lim) 
        spec_list2(counter)=spec_list(j);
        counter=counter + 1;
    end    
end

n_spec=counter;

plotsPerPg = 8;
n_pg = ceil(n_spec/plotsPerPg);

for j = 0:n_pg-1
        for k = 1:plotsPerPg
            if (k + plotsPerPg*j) < n_spec
                spec_data = ncread(ncid,spec_list2{k + plotsPerPg*j});
                spec_name = spec_list2{k+8*j};
                figure(j+1)
                subplot(4,2,k)
                [  p_handle, f_handle ] = Plot_all3D(time(1:time_length), BOXCH, spec_data(:,1:time_length),spec_name,k);
            end
        end
        set(findall(gcf,'-property','FontSize'),'FontSize',9);
        set(figure(j+1),'PaperOrientation','landscape', 'PaperUnits','normalized' );
        print(figure(j+1),'-dpdf','-bestfit');
end


