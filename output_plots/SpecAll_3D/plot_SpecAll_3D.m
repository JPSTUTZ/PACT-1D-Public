close all
clear all

%plot species listed in the PlotSpec array at all altitudes (contour plot
%of time, altitude, and species conc - KBT 11/16/18

ncid = '..\..\output\spec.nc';
finfo = ncinfo(ncid)
varNames = {finfo.Variables.Name};
spec_list = varNames(5:193);
n_spec = length(spec_list);
BOXCH=ncread(ncid,'BOXCH');
n_lev = length(BOXCH);
Times=ncread(ncid,'Times');
time=datenum(Times');

plotsPerPg = 8;
n_pg = ceil(n_spec/plotsPerPg);

for j = 0:n_pg-1
        for k = 1:plotsPerPg
            if k+8*j <= n_spec
            spec_data = ncread(ncid,spec_list{k+8*j});
            spec_name = spec_list{k+8*j};
            figure(j+1)
            subplot(4,2,k)
            [  p_handle, f_handle ] = Plot_all3D(time, BOXCH, spec_data',spec_name,k);
            end
        end
        set(figure(j+1),'PaperOrientation','landscape', 'PaperUnits','normalized' );
        print(figure(j+1),'-dpdf','-bestfit');
end

