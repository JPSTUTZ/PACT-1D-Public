function [Kz,error_msg] = read_kz(kzfile,BOX_WALL,Times);
% read Kz values from netcdf file

 error_msg = [];
 
 %read open the Kz file
 ncid = netcdf.open(kzfile,'NOWRITE');
 
 %get the times of the kz file
 varid      = netcdf.inqVarID(ncid,'Times');
 Times_Kz = netcdf.getVar(ncid,varid);
 Times_Kz = Times_Kz.';
 
 %there is one more time in the master time file than in the kz input file
 [ntimes ~] = size(Times);
 
 %if the initial concentraiton time is not equal to the master time file
 %initial time, exit with an error message
 if Times(1:ntimes,:) ~= Times_Kz
   error_msg = ['Times Kz.nc are not the same as in the master times file master_time_lev.nc.'];
   return
 end
 
 %get the Box hights from the initial concentration file
 varid      = netcdf.inqVarID(ncid,'BOX_WALL');
 BOX_WALL_Kz = netcdf.getVar(ncid,varid);
 
 %if the model levels are different - then  send an error message
 if BOX_WALL_Kz ~= BOX_WALL 
   error_msg = ['The model levels in the master initialization file master_time_lev.nc are different from the Kz.nc file.'];
   return
 end
 
 %-------------------------  Read Kz file -------------------------------------
 
 varid = netcdf.inqVarID(ncid,'Kz');
 Kz(:,:) = netcdf.getVar(ncid,varid);
 netcdf.close(ncid)

end
