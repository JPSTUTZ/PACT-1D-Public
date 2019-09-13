function [ ] = open_spec_file( model_path, Times, nlev, ntim, DateStrLen,...
    spec_conc, spec_conc_fixed, temperature, pressure, relative_humidity, BOX_WALL, ...
    BOXCH, output_file_comment, output_file_created_by)
%Open file to write the species concentrations, write the initial spec
%concentraitons

global spec_names;

% add model parameters
mech_Parameters;

%get model species names
spec_names = get_spec_names( model_path );

%----------------------- write concentrations to netcdf file --------------------
disp(['------>Creating netcdf output files - spec.nc, rxn_rates.nc, and vt_rates.nc']);
%write netcdf file with concentration values
ncid = netcdf.create([model_path '/output/spec.nc'], 'CLOBBER');

% define dimensions
z_dimid = netcdf.defDim(ncid,'z_levels',nlev);
dateStrLen_dimid = netcdf.defDim(ncid,'DateStrLen',DateStrLen);
%time_dimid = netcdf.defDim(ncid,'time',ntim);
time_dimid = netcdf.defDim(ncid,'time',netcdf.getConstant('NC_UNLIMITED'));

%define global attributes
varid = netcdf.getConstant('GLOBAL');
netcdf.putAtt(ncid,varid,'creation_date',datestr(now));
netcdf.putAtt(ncid,varid,'created_by',output_file_created_by);
netcdf.putAtt(ncid,varid,'model_comment',output_file_comment);
netcdf.putAtt(ncid,varid,'note','concentrations for 1D model on model levels');
clear varid;

% define variables
varid_timeStr = netcdf.defVar(ncid,'Times','char',[dateStrLen_dimid, time_dimid]);
netcdf.putAtt(ncid,varid_timeStr,'units','Time and date (local)')
netcdf.putAtt(ncid,varid_timeStr,'long_name','Character string - current time')

varid_box = netcdf.defVar(ncid,'BOX_WALL','double',z_dimid);
netcdf.putAtt(ncid,varid_box,'units','m')
netcdf.putAtt(ncid,varid_box,'long_name','Vertical grid spacing, upper boundary of model grid box in meters')

varid_boxch = netcdf.defVar(ncid,'BOXCH','double',z_dimid);
netcdf.putAtt(ncid,varid_boxch,'units','m')
netcdf.putAtt(ncid,varid_boxch,'long_name','Vertical grid spacing, center point of model grid box in meters')

%make space for both variable concentraiton and fixed concentraiton species
%1 to NSPEC
for j = 1:NSPEC
  varid(j)  = netcdf.defVar(ncid,spec_names{j},'double',[z_dimid,time_dimid]); 
  netcdf.putAtt(ncid,varid(j),'units','molec cm-3')
  netcdf.putAtt(ncid,varid(j),'long_name',['Concentration for species - ' spec_names{j}])
end

%write temperature, pressure, rh
%temperature
varid_t  = netcdf.defVar(ncid,'temp','double',[z_dimid, time_dimid]); 
netcdf.putAtt(ncid,varid_t,'units','K')
netcdf.putAtt(ncid,varid_t,'long_name',['Temperature Kelvin'])
%pressure
varid_p  = netcdf.defVar(ncid,'press','double',[z_dimid, time_dimid]); 
netcdf.putAtt(ncid,varid_p,'units','Pa')
netcdf.putAtt(ncid,varid_p,'long_name',['Pressure in Pa'])
%rh
varid_rh  = netcdf.defVar(ncid,'rh','double',[z_dimid, time_dimid]); 
netcdf.putAtt(ncid,varid_rh,'units','Percent')
netcdf.putAtt(ncid,varid_rh,'long_name',['RH in percent'])

netcdf.endDef(ncid)
%done defining file format

% ----------WRITE DATA TO THE FILE - BOX HEIGHTS, Times, species concentraitons

% box upper boundary 
netcdf.putVar(ncid,varid_box,0,nlev,BOX_WALL);
netcdf.putVar(ncid,varid_boxch,0,nlev,BOXCH);

%Time string for each value
%disp(Times(1,:))
netcdf.putVar(ncid,varid_timeStr,[0,0],[DateStrLen,1],Times(1,:)');

%add temperature, pressure, RH to file
netcdf.putVar(ncid,varid_t,[0,0],[nlev,1],temperature(:,1));
netcdf.putVar(ncid,varid_p,[0,0],[nlev,1],pressure(:,1));
netcdf.putVar(ncid,varid_rh,[0,0],[nlev,1],relative_humidity(:,1));

%add add concentrations - variable concentration species
for j=1:NVAR
  ind = get_ind(spec_names{j});
  tmp = squeeze(spec_conc(ind,:,1));
  netcdf.putVar(ncid,varid(j),[0,0],[nlev,1],tmp);
  clearvars tmp;
end
%add add concentrations - fixed concentration species
for j=NVAR+1:NSPEC
  ind = get_indf(spec_names{j});
%  size(spec_conc_fixed(ind,:,:))
%  size(spec_conc(1,:,:))
  tmp = squeeze(spec_conc_fixed(ind,:,1));
  netcdf.putVar(ncid,varid(j),[0,0],[nlev,1],tmp);
  clearvars tmp;
end

clear varid;

netcdf.close(ncid)

end

