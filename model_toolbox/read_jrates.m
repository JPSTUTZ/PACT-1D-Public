function [jrates_in,jrate_list_input,error_msg] = read_jrates(jrate_file,BOX_WALL,Times);
% read photolysis rates from netcdf file

%set error message to nothing
error_msg = [];

%add model parameters
mech_Parameters;

%-------------------------  Read photo file -------------------------------------
%read model levels from the photolysis file
ncid = netcdf.open(jrate_file,'NOWRITE');

 %get the times of the initial concentration file
 varid      = netcdf.inqVarID(ncid,'Times');
 Times_Jrate = netcdf.getVar(ncid,varid);
 Times_Jrate = Times_Jrate.';
 
 %there is on more time in the master time file, compare with the size
 %ntimes-1
 [ntimes ~] = size(Times);

 %if the initial concentraiton time is not equal to the master time file
 %initial time, exit with an error message
 if Times(1:ntimes,:) ~= Times_Jrate
   error_msg = ['Times J_values.nc are not the same as in the master times file master_time_lev.nc.'];
   return
 end
 
 %get the Box hights from the initial concentration file
 varid      = netcdf.inqVarID(ncid,'BOX_WALL');
 BOX_WALL_jrates = netcdf.getVar(ncid,varid);
 
 %if the model levels are different - then  send an error message
 if BOX_WALL_jrates ~= BOX_WALL 
   error_msg = ['The model levels in the master initialization file master_time_lev.nc are different from the J_values.nc file.'];
   return
 end
 
 %get the names of the jrates in the files
 %get list of varIDs in the files
 varIDs = netcdf.inqVarIDs(ncid);
 [~, nvarIDs] = size(varIDs);
 
 [NLEV ~] = size(BOX_WALL);

 %make space for jrates
 jrates_in = zeros(nvarIDs-1,NLEV,ntimes);  %-1 here, arrays start at 1, there are two varids not used BOX_WALL and Times
 
 %save jrates and a list of the jrate names
 jrate_list_tmp = {};
 for i=2:nvarIDs-1  %skip 0, it's the box heights
  var = netcdf.inqVar(ncid,i);                                           %species name from the netcdf file
  jrate_list_tmp = [jrate_list_tmp{:} {var}];
  disp(['reading photolysis rates - ' var]);   %finding this species name in the mechanism
  %size(netcdf.getVar(ncid,varIDs(i)))
  %size(jrates_in(i-1,:,:))
  %jrates_in(i-1,:,:) = netcdf.getVar(ncid,i);     
  temp = netcdf.getVar(ncid,i);
  jrates_in(i-1,:,:) = netcdf.getVar(ncid,i)';  %JPS why do we now have to transpose the input matrix
 end

 jrate_list_input = jrate_list_tmp;

 return
