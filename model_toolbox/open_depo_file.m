function [  ] = open_depo_file(model_path, Times, ntim, DateStrLen, depo, output_file_comment, output_file_created_by )
%Open file for vertical transport rates

%species names are a global variable
global spec_names;

%global fill value number set in the initialization routines
global fill_value_netcdf

%get model parameters
mech_Parameters;

%----------------------- write vertical transport rates to netcdf file --------------------
%write netcdf file with the vertical transport rates
ncid = netcdf.create([model_path '/output/depo_rates.nc'], 'CLOBBER');

% define dimensions
dateStrLen_dimid = netcdf.defDim(ncid,'DateStrLen',DateStrLen);
time_dimid = netcdf.defDim(ncid,'time',netcdf.getConstant('NC_UNLIMITED'));

%define global attributes
varid = netcdf.getConstant('GLOBAL');
netcdf.putAtt(ncid,varid,'creation_date',datestr(now));
netcdf.putAtt(ncid,varid,'created_by', output_file_created_by);
netcdf.putAtt(ncid,varid,'model_start',output_file_comment);
netcdf.putAtt(ncid,varid,'note','for 1D model on model levels');
clear varid;

% define variables
varid_timeStr = netcdf.defVar(ncid,'Times','char',[dateStrLen_dimid,time_dimid]);
netcdf.putAtt(ncid,varid_timeStr,'units','Time and date (local)')
netcdf.putAtt(ncid,varid_timeStr,'long_name','Character string - current time')

for j = 1:NVAR
  varid(j)  = netcdf.defVar(ncid,spec_names{j},'double',[time_dimid]); 
  netcdf.putAtt(ncid,varid(j),'units','molec/cm2/s')
  netcdf.putAtt(ncid,varid(j),'long_name',['deposition rate for species - ' spec_names{j}])
  netcdf.putAtt(ncid,varid(j),'_FillValue',fill_value_netcdf)
end

netcdf.endDef(ncid)
%done defining file format

% ----------WRITE DATA TO THE FILE - BOX HEIGHTS, Times, species concentraitons

%Time string for each value
netcdf.putVar(ncid,varid_timeStr,[0, 0],[DateStrLen, 1],Times(1,:)');

%add add depo rates
for j=1:NVAR
  ind = get_ind(spec_names{j});
  tmp = squeeze(depo(ind,1));
  netcdf.putVar(ncid,varid(j),[0],[1],tmp);
end

clear varid;

netcdf.close(ncid)



end

