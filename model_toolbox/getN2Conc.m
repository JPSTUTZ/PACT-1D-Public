function [ N2Conc ] = getN2Conc( airConc )
%Return N2 concentraiton given that 78% of the air is N2 
  N2percent = 0.78;
  N2Conc = airConc*N2percent;
end

