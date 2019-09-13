function [ ] = PlotTrace_Ind( PlotStruct, PlotLev )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here


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


spec_data=ncread(ncid,spec_list{1});
temp=squeeze(spec_data(1,:));
idx=find(temp == 9.9e36 | isnan(temp));
if(isempty(idx))
    time_length=length(temp)
else
    time_length=idx(1)-1;
end




% SpecInd = zeros(1,nPlotSpec);
% 
% for i = 1:nPlotSpec
%     idx = strcmp(PlotSpec(i),spec_list);
%     idx2 = find(idx);
%     SpecInd(1,i)=idx2;
% end

plotsPerPg = 8;
%n_pg = ceil(nPlotSpec/plotsPerPg);

for j = 1:length(PlotStruct);
        h=figure('Name',char(PlotStruct(j).Name));
        for k = 1:length(PlotStruct(j).Spec);
            idx=find(strcmp(PlotStruct(j).Spec(k),spec_list));
            spec_data = ncread(ncid,spec_list{idx});
            spec_name = PlotStruct(j).Spec(k);
            subplot(4,2,k)
            [  p_handle, f_handle ] = Plot_indAlt(time(1:time_length), BOXCH, PlotLev, spec_data(:,1:time_length),spec_name,k);
            end
        
        set(findall(gcf,'-property','FontSize'),'FontSize',10);
        set(h,'PaperOrientation','landscape', 'PaperUnits','normalized' );
        print(char(PlotStruct(j).Name),'-dpdf','-bestfit');
end



end

