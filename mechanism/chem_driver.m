% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%                                                                  
% chem_driver 
%                                                                  
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  function [spec_layer_new,rate_constants] = chem_driver (spec_layer,...
      spec_fixed_layer, t1,t2,deltaT,temperature, pressure)

  % JPS
  %mech_Parameters;
  global NVAR
  global NFIX
  
  mech_Global_defs;
  mech_Sparse;
  mech_Monitor;
  mech_JacobianSP;
  mech_Initialize;
  
  global M_CONC;
  global PRES_TIME_LEV;
  PRES_TIME_LEV = pressure;   %pressure for this model level and time, Pa
  TEMP = temperature;         %global variable temperature
  %disp(TEMP);
  %display(pressure);
  %display(PRES_TIME_LEV);
  
  %concentraiton factor of kpp rate functions
  %JPS 4/12/19
  ind=get_indf('AIR');
  M_CONC = spec_fixed_layer(ind);
  
  %define the size of the array to hold the final concentraiton returned
  spec_layer_new = zeros(size(spec_layer));

% PASS CONCENTRATIONS TO ARRAYS FOR KPP
  for i=1:NVAR
    %reactive species
    VAR(i) = spec_layer(i);
  end
  for i=1:NFIX
    %reactive species
    FIX(i) = spec_fixed_layer(i);
  end

% SET UP TIME INTEGRATION INFO AND TEMPERATURE
  TSTART = t1;
  TEND = t2;
  DT = deltaT;

% SET UP INTEGRATOR TOLERANCES
  RTOLS = 1.0e-6;
  ATOLS = 1.0e-3;
  Options = odeset('AbsTol',ATOLS,'RelTol',RTOLS,'Jacobian',@mech_Jac_Chem);
  %Options = odeset('AbsTol',ATOLS,'RelTol',RTOLS);

% ********** INTEGRATE USING MATLAB STIFF SYSTEM SOLVER ODE15s *************************
  %VAR are the concentrations going into the solver
  TIME = TSTART;
  Tspan = linspace( TSTART, TEND, round((TEND-TSTART)/DT) );
  [T, Y] = ode15s(@mech_Fun_Chem, Tspan, VAR, Options);
  %T contains the times
  %Y contains the concentrations at each time passed back from the integrator

% ********** GET THE RATE CONSTANTS FROM RCONST *************************
rate_constants = RCONST;

%PASS THE FINAL CONCETNRATIONS BACK TO THE MAIN PROGRAM
  for i=1:NVAR
      %ind = get_ind(i);
      spec_layer_new(i)   = Y(length(T),i);
  end

return

%end of chem driver

