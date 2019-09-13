function [aerosol_radius,aerosol_number,error_msg] = read_aerosol(aerosol_file,BOX_WALL,Times);
% read values from netcdf file

 error_msg = [];
 
 %read open the netcdf file
 ncid = netcdf.open(aerosol_file,'NOWRITE');
 
 %get the times of the aerosol concentration file
 varid      = netcdf.inqVarID(ncid,'Times');
 Times_aerosol = netcdf.getVar(ncid,varid);
 Times_aerosol = Times_aerosol.';
 
 %there is one more time in the master time file than in the kz input file
 [ntimes ~] = size(Times);
 
 %if the initial concentraiton time is not equal to the master time file
 %initial time, exit with an error message
 if Times(1:ntimes,:) ~= Times_aerosol
   error_msg = ['Times aerosol.nc are not the same as in the master times file master_time_lev.nc.'];
   return
 end
 
 %get the Box hights from the initial concentration file
 varid      = netcdf.inqVarID(ncid,'BOX_WALL');
 BOX_WALL_aerosol = netcdf.getVar(ncid,varid);
 
 %if the model levels are different - then  send an error message
 if BOX_WALL_aerosol ~= BOX_WALL 
   error_msg = ['The model levels in the master initialization file master_time_lev.nc are different from the aerosol.nc file.'];
   return
 end
 
 %-------------------------  Read aerosol data from file -------------------------------------
 
 varid = netcdf.inqVarID(ncid,'aerosol_radius');
 aerosol_radius(:,:) = netcdf.getVar(ncid,varid);
 
 varid = netcdf.inqVarID(ncid,'aerosol_number');
 aerosol_number(:,:) = netcdf.getVar(ncid,varid);
 
 netcdf.close(ncid)

end
