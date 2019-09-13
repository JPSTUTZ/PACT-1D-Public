function [ H2O_conc ] = getH2OConc( temperature, rel_hum )
% H2O concentration at given temperatureerature, relative humidity in # cm-3

    %NOT SURE THIS IS RIGHT - CHECK EQUATION JLT
    
    Na = 6.022*10^23;                       %avagadro's number #/mol
    R = 8.31;                               %gas constant in m3 Pa K-1 mol-1
    cm3tom3 = 1.*10^6;                      %conversion constant, number of cm3 per m3

    %saturation vapor pressure at a given temperatureerature
    e_s = exp(77.3450 + 0.0057 * temperature - 7235 / temperature) / temperature^8.2;      %saturation vapor pressure of water in Pa
    
    %vapor pressure at given RH
    e   = e_s*rel_hum/100.;                        %vapor pressure at given RH in hPa                                  %vapor pressure in Pa
    H2O_conc = Na*e/(R*temperature);                      %air concentration in molecules m-3
    H2O_conc = H2O_conc/cm3tom3;                   %air concentraiton in molecules cm-3

end

