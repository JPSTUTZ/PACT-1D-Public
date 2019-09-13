function [  ] = Plot3D_RXN( R_name1,R_name2 )

%close all
%clear all

%plot all reaction rates associated with a specified species. Make contour
%plot of time, altitude and rxn rate for each reaction - KBT 11/16/18

ncid = '..\..\output\rxn_rates.nc';
finfo = ncinfo(ncid);
% ncid2 = '..\..\rxn_rate_constants.nc';
% finfo2 = ncinfo(ncid2);

BOXCH=ncread(ncid,'BOXCH');
n_lev = length(BOXCH);
Times=ncread(ncid,'Times');
time=datenum(Times');

varNames = {finfo.Variables.Name};
nVar = length(varNames);

%create an array to fill with the long name for each variable in
%rxn_rates.nc
VarDescr = [];

for i=1:nVar
    [VarStr{i}]=varNames{i};
    [VarDescr{i}]=ncreadatt(ncid,VarStr{i},'long_name');
end

VarDescr = VarDescr';

%-----find all reaction descriptions that contain the specified species

%specIdx = ' MO2 ';
specIdx1=R_name1
specIdx_arr1 = strfind(VarDescr,specIdx1);

specIdx2=R_name2
specIdx_arr2 = strfind(VarDescr,specIdx2);

% specIdx_arr = specIdx_arr1+specIdx_arr2;

tf = cellfun('isempty',specIdx_arr1);
rxnIdx1 = find(tf==0);

tf = cellfun('isempty',specIdx_arr2);
rxnIdx2 = find(tf==0);

rxnIdx = [rxnIdx1;rxnIdx2];

n_rxns = length(rxnIdx)

%--- Check for unfinished run, only use available times-----

RxnRate=ncread(ncid,varNames{rxnIdx(1)});
temp=squeeze(RxnRate(1,:));
idx=find(temp == 9.9e36 | isnan(temp));
if(isempty(idx))
    time_length=length(temp)
else
    time_length=idx(1)-1;
end

%--- Sort reaction rates by importance
for i=1:n_rxns
    RxnRate=ncread(ncid,varNames{rxnIdx(i)});
    R_MAX(i)=max(max(RxnRate(:,1:time_length)));
end

[out,idx] = sort(R_MAX,'descend');
rxnIdxSort=rxnIdx(idx);

%-------------------------------------------------

plotsPerPg = 8;
n_pg = ceil(n_rxns/plotsPerPg);

for j = 0:n_pg-1
     FN=sprintf('%s_%i',strtrim(R_name1),j+1);
     figure('Name',FN);
    for k = 1:plotsPerPg
        if k+8*j <= n_rxns
            RxnRate=ncread(ncid,varNames{rxnIdxSort(k+8*j)});
            RxnName=char(strtrim(VarDescr{rxnIdxSort(k+8*j)}));
            if(length(RxnName)>30)
                RxnName=RxnName(1:30);
            end
           
            subplot(4,2,k)
            [  p_handle, f_handle ] = Plot_rate3D(time(1:time_length), BOXCH, RxnRate(:,1:time_length),RxnName,k);
        end
           end
        set(findall(gcf,'-property','FontSize'),'FontSize',9)
        set(gcf,'PaperOrientation','landscape', 'PaperUnits','normalized' );
        print(FN,'-dpdf','-bestfit');
end

end