function [ str ] = get_rate_constant_names( j )
%Get reaction names for netcdf output file
  react_num = sprintf('%04d',j);
  str = ['rate_constant_' react_num] ;
end