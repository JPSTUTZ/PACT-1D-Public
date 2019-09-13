function [ O2Conc ] = getO2Conc( airConc )
%Return O2 concentraiton given that 21% of the air is oxygen
  O2percent = 0.21;
  O2Conc = airConc*O2percent;
end

