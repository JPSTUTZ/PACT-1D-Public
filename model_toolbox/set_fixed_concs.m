function [ spec_fixed_values ] = set_fixed_concs( temperature, press, rel_hum )
%set fixed concentration species 
%UPDATE THIS BASED ON THE MECHANISM

    %global variable with air concentraiton for kpp functions
    %set equal to the air concentration
    global AIRConc

    %load the mechanism parameters
    mech_Parameters;
    
    %make some space
    spec_fixed_values = zeros(NFIX,1);
    
    %get air number concentration for this temperature and pressure, # cm-3
    airConc = getAirConc(temperature,press);
    AIRConc = airConc;
%    ind = get_indf('AIR');     
    ind = eval('indf_AIR');     % replaced 8/11/17 JPS
    spec_fixed_values(ind) = airConc;

    %get the N2 concentration
%    ind = get_indf('N2');
     ind = eval('indf_N2');     % replaced 8/11/17 JPS
    N2Conc = getN2Conc(airConc);
    spec_fixed_values(ind) = N2Conc;

    %get O2 concentration, # cm-3
%    ind = get_indf('O2');
        ind = eval('indf_O2');     % replaced 8/11/17 JPS
    O2Conc = getO2Conc(airConc);
    spec_fixed_values(ind) = O2Conc;

    %get H2 concentration, # cm-3
%    ind = get_indf('H2');
    ind = eval('indf_H2');     % replaced 8/11/17 JPS
    H2Conc = getH2Conc(airConc);
    spec_fixed_values(ind) = H2Conc;

    %get CH4 concentration, # cm-3 
%    ind = get_indf('CH4');
    ind = eval('indf_CH4');     % replaced 8/11/17 JPS
    CH4Conc = getCH4Conc(airConc);
    spec_fixed_values(ind) = CH4Conc;

    %calculate water vapor concentraiton from RH
%    ind = get_indf('H2O');
    ind = eval('indf_H2O');     % replaced 8/11/17 JPS
    H2OConc = getH2OConc(temperature, rel_hum);
    spec_fixed_values(ind) = H2OConc;

end

