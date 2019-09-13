function [P,T,RH,error_msg] = read_atm(atmfile,BOX_WALL,Times);
%function [P,T,RH,error_msg] = read_atm(atmfile);
% read P, T, RH values from netcdf file

 disp('inside the function this is the file i am using')
 disp(atmfile)
 error_msg = [];

 %read open the Kz file
 ncid = netcdf.open(atmfile,'NOWRITE');

 %get the times of the initial concentration file
 varid     = netcdf.inqVarID(ncid,'Times');
 Times_atm = netcdf.getVar(ncid,varid);
 Times_atm = Times_atm.';

 %there is one more time in the master time file than in the kz input file
 [ntimes ~] = size(Times);

 %if the initial concentraiton time is not equal to the master time file
 %initial time, exit with an error message
 if Times(1:ntimes,:) ~= Times_atm
   error_msg = ['Times' atmfile ' are not the same as in the master times file master_time_lev.nc.'];
   return
 end

 %get the Box hights from the initial concentration file
 varid        = netcdf.inqVarID(ncid,'BOX_WALL');
 BOX_WALL_atm = netcdf.getVar(ncid,varid);

 %if the model levels are different - then  send an error message
 if BOX_WALL_atm ~= BOX_WALL
   error_msg = ['The model levels in the master initialization file master_time_lev.nc are different from the ' atmfile ' file.'];
   return
 end

 %-------------------------  Read file -------------------------------------

 varid = netcdf.inqVarID(ncid,'PRES');
 P(:,:) = netcdf.getVar(ncid,varid);
 
 varid = netcdf.inqVarID(ncid,'TEMP');
 T(:,:) = netcdf.getVar(ncid,varid);
 
 varid = netcdf.inqVarID(ncid,'RH');
 RH(:,:) = netcdf.getVar(ncid,varid);
 netcdf.close(ncid)

end
