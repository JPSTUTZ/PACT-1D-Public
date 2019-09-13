function [BOX_WALL, BOXCH, Times] = read_times_levels(time_level_file);
% read photolysis rates from netcdf file


%------------------------- read vertical levels and times  -------------------------------------
%levels
ncid = netcdf.open(time_level_file,'NOWRITE');
varid = netcdf.inqVarID(ncid,'BOX_WALL');
BOX_WALL = netcdf.getVar(ncid,varid);

%Times
varid = netcdf.inqVarID(ncid,'Times');
Times = netcdf.getVar(ncid,varid);
Times = Times.';

netcdf.close(ncid)

%calculate box centerpoints
nlevels = size(BOX_WALL,1);
BOXCH = zeros(nlevels-1,1);

BOXCH(1) = BOX_WALL(1)/2.;
for l=2:nlevels;
    BOXCH(l) = BOX_WALL(l-1) + (BOX_WALL(l)-BOX_WALL(l-1))/2.;
end
%BOX_WALL
%Times

%pause(10000)

