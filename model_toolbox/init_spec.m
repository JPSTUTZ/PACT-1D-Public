function  [spec, spec_fixed, error_msg] = init_spec(initial_spec_conc_file,...
    NLEV, spec, spec_fixed, Times, BOX_WALL, temperature, pressure, relative_humidity)
% read the list of species from the mech.spc file, look for these in the
% netcdf file with the model input concentrations in initial_spec_profiles.nc
% If the species is not in initial_spec_profiles.nc, this routine will
% initialize it to a very small concentration

%add model parameters
mech_Parameters;

error_msg = [];

%spec_names = get_spec_names( );

%-------------------------  Read the inital concentration file ------------------------------------
%read inital concentration species netcdf file
ncid = netcdf.open(initial_spec_conc_file,'NOWRITE');
varid = netcdf.inqVarID(ncid,'BOX_WALL');
BOX_WALL_spec = netcdf.getVar(ncid,varid);

%all initial concentrations 
%pick a minimum concentration value, set all initial concentations to this
minConcVal = 1e-20;                       %minimum concentration values
spec_t0    = ones(NVAR,NLEV)*minConcVal;  %non zero initial concentraitons

%get the times of the initial concentration file
varid      = netcdf.inqVarID(ncid,'Times');
Time_initC = netcdf.getVar(ncid,varid);
Time_initC = Time_initC.';

%if the initial concentraiton time is not equal to the master time file
%initial time, exit with an error message
if Times(1,:) ~= Time_initC 
  error_msg = ['Initial concentration time in init_spec.nc not the same as the run start time.'];
  return
end

%get the Box hights from the initial concentration file
varid          = netcdf.inqVarID(ncid,'BOX_WALL');
BOX_WALL_initC = netcdf.getVar(ncid,varid);

%if the model levels are different - then  send an error message
if BOX_WALL_initC ~= BOX_WALL 
  error_msg = ['The model levels in the master initialization file master_time_lev.nc are different from the init_spec.nc file.'];
  return
end

%get list of varIDs in the files
varIDs = netcdf.inqVarIDs(ncid);
[~, nvarIDs] = size(varIDs);

for i=2:nvarIDs-1  %skip the first value, it's the model grid
  var = netcdf.inqVar(ncid,i);                              %species name from the netcdf file
  disp(['reading concentraiton & setting intial value for - ' var]);
  %ind = get_ind(var);                                      %finding this species name in the mechanism
  ind = get_ind(var);                                       %finding this species name in the mechanism
  spec_t0(ind,:) = netcdf.getVar(ncid,i);                   %use ind for the spec array always!!!!, i is for the loop over the netcdf file
  %disp(spec_t0(ind,:))
end

%get the air density in #/cm3
%size(temperature);
%size(pressure);
rho = getAirConc( temperature, pressure );                  %air density in molec cm-3

%move the initial specience concentrations over to the spec array, 
%at time t=t0, convert from ppbv to molec cm-3
%loop over species & levels, convert units
for i=1:NVAR
    for l=1:NLEV
        spec(i,l,1) = spec_t0(i,l)*1e-9*rho(l);             %for the spec array, time is the last dimension, set the value at this time
    end
end

%disp(['NO2 initial concentration level 1'])
%spec(ind_NO2,1,1)

netcdf.close(ncid);

disp(['initilizing fixed concentraiton species based on temperature, pressure, RH']);
%setting up a minimum concentraiton value for the fixed concentration
%species
spec_fixed(:,:,:) = minConcVal;
%loop over the levels to initialize the fixed concentration species
for l=1:NLEV
    fixed_concs_t0 = set_fixed_concs( temperature(l), pressure(l), relative_humidity(l) );  
    for i=1:NFIX
      spec_fixed(i,l,1:2) = fixed_concs_t0(i);
    end
end
