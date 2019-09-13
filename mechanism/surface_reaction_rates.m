function [rate_constant] = surface_reaction_rates(ind, t, JDat)
% get the surface reaction rate for the given reaction

%    global K_het_for_kpp
%    global K_het_for_kpp_dt
   
%---- JPS added to allow time interpolation for J-Rates-----------------------------
%    global TIME                  % Internal KPP time
%    global J_StartTime           %Start Time for chem_driver call
%    global J_StopTime            %Stop Time for chem_driver call
%---------------------------------------------------------------------
  
 %---- JPS added to allow time interpolation for J-Rates-----------------------------
 a=JDat.K_het_for_kpp(ind);
 b=JDat.J_StartTime;
 rate_constant = JDat.xhet*( a +(JDat.K_het_for_kpp_dt(ind)-a) ./ (JDat.J_StopTime-b) *(t - b));
 
 
% rate_constant = JDat.xhet*JDat.K_het_for_kpp(ind)+(JDat.K_het_for_kpp_dt(ind)-JDat.K_het_for_kpp(ind)) ./ (JDat.J_StopTime-JDat.J_StartTime) *(t - JDat.J_StartTime);

% tic
% disp(ind);
% disp(rate_constant);
% toc
% pause(1000)
  