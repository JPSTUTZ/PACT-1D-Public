function [ind,counter] = jrates_FirstCall(rxn)
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
 
  
global GStruct 
  
  counter=GStruct.J_Counter;
  length=GStruct.J_Length;
  
%  if(length < 0)
    ind=find(strcmp(GStruct.jrates_list, rxn)>0);
    if(GStruct.J_Counter==1)
        GStruct.J_Index(counter)=  ind;
        counter=counter+1;
    else
       if(ind ~= GStruct.J_Index(1))
           GStruct.J_Index(counter)=  ind;
            counter=counter+1;
       else 
         length=counter-1;  
         counter=2;
       end  
    end    
     
%   else
%     ind= GStruct.J_Index(counter);
%     counter=counter+1;
%     if(counter>length)
%       counter=1;
%     end  
%   end
  
  GStruct.J_Counter=counter;
  GStruct.J_Length=length; 
  
  %ind = find(strcmp(GStruct.jrates_list, rxn)>0);
  
  %---- JPS added to allow time interpolation for J-Rates-----------------------------

%  jrate = JDat.jrates_for_kpp(ind)+(JDat.jrates_for_kpp_dt(ind)-JDat.jrates_for_kpp(ind)) ./ (JDat.J_StopTime-JDat.J_StartTime) *(t - JDat.J_StartTime);
  
  %---------------------------------------------------------------------
  
  %---- JPS removed to allow for interpolation of J-rates
  %get the reaciton rate for this reaction
%  jrate = jrates_for_kpp(ind); 			% Call without 
  

  

