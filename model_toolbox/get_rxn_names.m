function [ str ] = get_rxn_names( j )
%Get reaction names for netcdf output file
  react_num = sprintf('%04d',j);
  str = ['rate_' react_num] ;
end

