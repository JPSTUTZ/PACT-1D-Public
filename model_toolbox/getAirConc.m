function [ airConc ] = getAirConc( temperature, press )
%   returns air concentration in # cm-3 for a given temperatureerature and pressure
    Na = 6.022*10^23;                       %avagadro's number #/mol
    R = 8.31;                               %gas constant in m3 Pa K-1 mol-1
    cm3tom3 = 1.*10^6;                      %conversion constant, number of cm3 per m3
    
    airConc = zeros(size(temperature,1),1);
    
    for i=1:size(temperature,1)  
      airConc(i) = Na*press(i)/(R*temperature(i)); %air concentration in molecules m3
      airConc(i) = airConc(i)/cm3tom3;      %air concentration in #/cm3
    end
    
    %size(airConc)
end

