function [ CH4Conc ] = getCH4Conc( airConc )
%Return CH4 concentraiton given that mol/mol CH4/air = 1.7x10-6 
  CH4percent = 1.7*10^-6 ;
  CH4Conc = airConc*CH4percent;
end

