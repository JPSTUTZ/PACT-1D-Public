
% Wrapper for calling the sparse ODE Jacobian routine
% in a format required by Matlab's ODE integrators

function J =  mech_Jac_Chem(T, Y)   
  
  global TIME FIX RCONST 
%  To call the mex file uncomment one of the following lines:
%     1) LU prefix if SPARSE_LU_ROW option was used in code generation
%  global LU_IROW LU_ICOL 
%     2) if SPARSE_ROW option was used in code generation
%  global IROW ICOL 
  
  Told = TIME;
  TIME = T;
  mech_Update_SUN;
  mech_Update_RCONST;
  
%  This line calls the Matlab ODE Jacobian routine  
  J = mech_Jac_SP( Y, FIX, RCONST );
  
%  To call the mex routine instead, comment the line above and uncomment one of the following lines:
%     1) LU prefix if SPARSE_LU_ROW option was used in code generation
%  J = sparse( LU_IROW, LU_ICOL, ...
%        mech_mex_Jac_SP( Y, FIX, RCONST ), 141, 141); 
%     2) if SPARSE_ROW option was used in code generation
%  J = sparse( IROW, ICOL, ...
%        mech_mex_Jac_SP( Y, FIX, RCONST ), 141, 141); 

  TIME = Told;
  
return              
