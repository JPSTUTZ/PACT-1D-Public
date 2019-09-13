function [ output_args ] = PlotTraceAll( plot_lev )

%plot all species listed in the spec.nc file at altitudes specified in
%plot_lev array - KBT 11/16/18

%plot_lev = [5 7 9 11 14];  %BOXCH levels

ncid = '..\..\output\spec.nc';
finfo = ncinfo(ncid)
varNames = {finfo.Variables.Name};
spec_list = varNames(5:end);
n_spec = length(spec_list);
BOXCH=ncread(ncid,'BOXCH');
n_lev = length(BOXCH);
Times=ncread(ncid,'Times');
time=datenum(Times');
n_time = length(time);

%--- Check for unfinished run, only use available times-----
spec_data=ncread(ncid,spec_list{1});
% temp=squeeze(spec_data(:,1));
% idx=find(temp == 9.9e36);
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
%    max(max(spec_data(1:time_length,:)))
    if(max(max(spec_data(:,1:time_length))) > conc_lim)    
%     if(max(max(spec_data(1:time_length,:))) > conc_lim) 
        spec_list2(counter)=spec_list(j);
        counter=counter + 1;
    end    
end


n_spec=counter;

plotsPerPg = 8;
n_pg = ceil(n_spec/plotsPerPg);

    for j = 0:n_pg-1
    FN=sprintf('SpecTrace_%i',j+1);
     figure('Name',FN);
        for k = 1:plotsPerPg
            if (k + plotsPerPg*j) < n_spec
                spec_data = ncread(ncid,spec_list2{k + plotsPerPg*j});
                spec_name = spec_list2{k+plotsPerPg*j};
                subplot(4,2,k)
                [  p_handle, f_handle ] = Plot_allAlt(time(1:time_length), BOXCH, plot_lev, spec_data(:,1:time_length),spec_name,k);
            end
% %             if k+8*j <= n_spec
%             if (k + plotsPerPg*j) < n_spec
%             spec_data = ncread(ncid,spec_list{k+8*j});
%             spec_name = spec_list{k+8*j};
%             figure(j+1)
%             subplot(4,2,k)
%             [  p_handle, f_handle ] = Plot_allAlt(time(1:time_length), BOXCH, plot_lev, spec_data(1:time_length,:)',spec_name,k);
%             end
        end
        set(findall(gcf,'-property','FontSize'),'FontSize',10);
        set(gcf,'PaperOrientation','landscape', 'PaperUnits','normalized' );
        print(FN,'-dpdf','-bestfit');
    end
end
