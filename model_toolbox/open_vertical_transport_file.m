function [  ] = open_vertical_transport_file( model_path, Times, nlev, ntim, DateStrLen, VT, BOX_WALL, BOXCH, output_file_comment, output_file_created_by )
%Open file for vertical transport rates

%species names are a global variable
global spec_names;

%global fill value number set in the initialization routines
global fill_value_netcdf

%get model parameters
mech_Parameters;


%----------------------- write vertical transport rates to netcdf file --------------------
%write netcdf file with the vertical transport rates
ncid = netcdf.create([model_path '/output/vt_rates.nc'], 'CLOBBER');

% define dimensions
z_dimid = netcdf.defDim(ncid,'z_levels',nlev);
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

varid_box = netcdf.defVar(ncid,'BOX_WALL','double',[z_dimid]);
netcdf.putAtt(ncid,varid_box,'units','m')
netcdf.putAtt(ncid,varid_box,'long_name','Vertical grid spacing, upper boundary of model grid box in meters')

for j = 1:NVAR
  varid(j)  = netcdf.defVar(ncid,spec_names{j},'double', [z_dimid, time_dimid]); 
  netcdf.putAtt(ncid,varid(j),'units','molec/cm3/s')
  netcdf.putAtt(ncid,varid(j),'long_name',['vertical transport rate for species - ' spec_names{j}])
  netcdf.putAtt(ncid,varid(j),'_FillValue',fill_value_netcdf)
end

varid_boxch = netcdf.defVar(ncid,'BOXCH','double',[z_dimid]);
netcdf.putAtt(ncid,varid_boxch,'units','m')
netcdf.putAtt(ncid,varid_boxch,'long_name','Vertical grid spacing, center point of model grid box in meters')

netcdf.endDef(ncid)
%done defining file format

% ----------WRITE DATA TO THE FILE - BOX HEIGHTS, Times, species concentraitons

% box center points
netcdf.putVar(ncid,varid_box,[0],[nlev],BOX_WALL);
netcdf.putVar(ncid,varid_boxch,[0],[nlev],BOXCH);

%Time string for each value
netcdf.putVar(ncid,varid_timeStr,[0, 0],[DateStrLen, 1],Times(1,:)');

%add add vertical transport rates
for j=1:NVAR
  ind = get_ind(spec_names{j});
  tmp = squeeze(VT(ind,:,1));
  netcdf.putVar(ncid,varid(j),[0,0],[nlev,1],tmp);
end

clear varid;

netcdf.close(ncid)



end

