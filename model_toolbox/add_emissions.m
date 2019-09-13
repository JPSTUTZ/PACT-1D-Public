
function  [emissions, error_msg] = add_emissions(emission_rates_file,NLEV, Times, BOX_WALL)
% read the list of species from the mech.spc file, look for these in the
% netcdf file with the model input concentrations in initial_spec_profiles.nc
% If the species is not in initial_spec_profiles.nc, this routine will
% initialize it to a very small concentration

%add model parameters
mech_Parameters;

error_msg = [];

%spec_names = get_spec_names( );

%-------------------------  Read the inital emission file ------------------------------------

%read inital emission_rates netcdf file
ncid = netcdf.open(emission_rates_file,'NOWRITE');
varid = netcdf.inqVarID(ncid,'BOX_WALL');
BOX_WALL_initE = netcdf.getVar(ncid,varid);
[ntimes ~] = size(Times);

%all initial emissions 
%pick a minimum concentration value, set all initial concentations to this
emissions    = zeros(NVAR,NLEV,ntimes);  %non zero initial concentraitons

%get the times of the initial concentration file
varid      = netcdf.inqVarID(ncid,'Times');
Time_initE = netcdf.getVar(ncid,varid);
Time_initE = Time_initE.';

%if the initial concentraiton time is not equal to the master time file
%initial time, exit with an error message
if Times(1:ntimes,:) ~= Time_initE
  error_msg = ['Emission initial time in Emissions_rates.nc not the same as the run start time.'];
  return
end

%get the Box hights from the initial concentration file
varid          = netcdf.inqVarID(ncid,'BOX_WALL');
BOX_WALL_initE = netcdf.getVar(ncid,varid);

%if the model levels are different - then  send an error message
if BOX_WALL_initE ~= BOX_WALL 
  error_msg = ['The model levels in the master initialization file master_time_lev.nc are different from the Emissions_rates.nc file.'];
  return
end

%get list of varIDs in the files
varIDs = netcdf.inqVarIDs(ncid);
[~, nvarIDs] = size(varIDs);

for i=2:nvarIDs-1  %skip the first value, it's the model grid
  var = netcdf.inqVar(ncid,i);                              %species name from the netcdf file
  disp(['reading emissions & setting intial value for - ' var]);
  var=var(3:end);
%  ind = get_ind(var);  % Replace 8/11/17 JPS finding this species name in the mechanism
  ind = eval(['ind_' var]);
  emissions(ind,:,:) = netcdf.getVar(ncid,i);                   %use ind for the spec array always!!!!, i is for the loop over the netcdf file
  %disp(spec_t0(ind,:))
end

%Divide the emissions by the boxwall between two levels in order to get a
%concentration/time in mol/s/m3
%mutliply by the avogadro factor so I get emissions in molec/m3/s
%Do the conversion from m3 to cm3 so that concentrations given in molec/cm3
%and emissions are consistent

Avogadro = 6.02*10^(23);
Convert_cm = 10^(6);

for l=1:NLEV-1
emissions(:,l,:) = emissions(:,l,:)*Avogadro/(Convert_cm*(BOX_WALL(l+1)-BOX_WALL(l)));
end
%emissions_t0(:,NLEV) = emissions_t0(:,NLEV-1)

netcdf.close(ncid);

