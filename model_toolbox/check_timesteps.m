function [message] = check_timesteps( dt_input, dt_chem, dt_kpp )

   message = '';
   
   %Check that the time steps are set up right
   if(dt_input < dt_chem) 
       message = ['dt_input is less than dt_chem - fix this!'];
   end
   if(mod(dt_input, dt_chem) ~= 0) 
       message = ['dt_chem needs to divide evenly into the input timesteps!'];
   end
   if(mod(dt_chem, dt_kpp) ~= 0) 
       message = ['dt_kpp needs to divide evenly into dt_chem!'];
   end
   if(dt_chem < dt_kpp) 
       message = ['dt_chem is greater than dt_kpp - fix this!'];
   end

end

