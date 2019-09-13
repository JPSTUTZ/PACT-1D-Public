function [ H2Conc ] = getH2Conc( airConc )
%Return H2 concentraiton given that mol/mol H2/air = 500*10^-9
  H2percent = 500*10^-9;
  H2Conc = airConc*H2percent;
end

