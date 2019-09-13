function [jrate] = jrates_name(rxn, t, JDat)
% get the index for a specific spec name
% rxn - is the name of the photolysis reaction in the jrate description file - for example 'J_NO2'
% the reaction rates must be in the right order (same order as in the netcdf file) for now, this will be updated later

 % set some global variables
%   global jrates_for_kpp 
%   global jrates_list
   
%---- JPS added to allow time interpolation for J-Rates-----------------------------
%   global jrates_for_kpp_dt   
%   global TIME                  % Internal KPP time
%   global J_StartTime             %Start Time for chem_driver call
%   global J_StopTime              %Stop Time for chem_driver call
%---------------------------------------------------------------------

  %strcmp(jrates_list, rxn)
  
  %find the jrate that fits this j reaction name e.g. J_NO2
 
   ind = find(strcmp(JDat.jrates_list, rxn));
    

  %---- JPS added to allow time interpolation for J-Rates-----------------------------

  jrate = JDat.jrates_for_kpp(ind)+(JDat.jrates_for_kpp_dt(ind)-JDat.jrates_for_kpp(ind)) ./ (JDat.J_StopTime-JDat.J_StartTime) *(t - JDat.J_StartTime);
  
  %---------------------------------------------------------------------
  
  %---- JPS removed to allow for interpolation of J-rates
  %get the reaciton rate for this reaction
%  jrate = jrates_for_kpp(ind); 			% Call without 
  

  

