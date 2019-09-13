function [jrate] = jrates(rxn, t, JDat)
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
  
 persistent cc;
  
   if(JDat.J_Length < 0)
      [ind,count]=jrates_FirstCall(rxn);
      cc=count;
   else
    ind= JDat.J_Index(cc);
    cc=cc+1;
    if(cc>JDat.J_Length)
      cc=1;
    end 
   end 
      
% This to test if new code works       
%    ind2 = find(strcmp(JDat.jrates_list, rxn));
%    if(ind~=ind2)
%       disp(ind)
%       disp(ind2)
%     end   
  
%ind = find(strcmp(JDat.jrates_list, rxn));
   
  %---- JPS added to allow time interpolation for J-Rates-----------------------------

  a=JDat.jrates_for_kpp(ind);
  b=JDat.J_StartTime;
  jrate = a + (JDat.jrates_for_kpp_dt(ind)-a)/(JDat.J_StopTime-b)*(t - b);
  
  
%  jrate = JDat.jrates_for_kpp(ind)+(JDat.jrates_for_kpp_dt(ind)-JDat.jrates_for_kpp(ind)) / (JDat.J_StopTime-JDat.J_StartTime) *(t - JDat.J_StartTime);
  
%   if(jrate1 ~= jrate)
%      disp (jrate1 - jrate) 
%   end
  
  %---------------------------------------------------------------------
  
  %---- JPS removed to allow for interpolation of J-rates
  %get the reaciton rate for this reaction
%  jrate = jrates_for_kpp(ind); 			% Call without 
  

  

