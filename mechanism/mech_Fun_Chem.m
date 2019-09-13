
% Wrapper for calling the ODE function routine
% in a format required by Matlab's ODE integrators

function P = mech_Fun_Chem(T, Y) 
     
  global TIME FIX RCONST  
 
  Told = TIME;
  TIME = T;
  mech_Update_SUN;
  mech_Update_RCONST;
  
%  This line calls the Matlab ODE function routine  
  P = mech_Fun( Y, FIX, RCONST );
  
%  To call the mex routine instead, comment the line above and uncomment the following line:
%  P = mech_mex_Fun( Y, FIX, RCONST );

  TIME = Told;

return
