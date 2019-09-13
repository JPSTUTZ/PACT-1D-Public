 %--------------------------------------------------------------------------------------
 % Platform for Atmospheric Chemistry and Transport in 1D 
 %
 % One dimensional model to calculate atmopsheric chemistry & vertical transport 
 % 
 % Developed by:
 % 
 % Jennie L. Thomas: jennie.thomas@univ-grenoble-alpes.fr
 % Katie Tuite: ktuite@ucla.edu
 % Jochen Stutz: jochen@atmos.ucla.edu
 %
 % Version 1.0
 % Last updated: September 13, 2019
 %
 % --------------------------------------------------------------------------------------
   close all;
   clear all;
   
 % set up path, add mechanism and model toolbox to the matlab path
   model_path = pwd;
   addpath('./mechanism')
   addpath('./model_toolbox')

 % use the paramaters created by kpp
   mech_Parameters;
   
 % read input text file
   read_input_text_file
   
 % do the model initialization, read all input files, set up arrays
   %script located in the model_toolbox
   initialize_model;
  
 %setup model times
 Times = datestr(datenum_chem,'yyyy-mm-dd_HH:MM:SS');

 % open netcdf output files
 
 open_netcdf_output(model_path, NLEV, NTIM_CHEM, Times, BOX_WALL,...
       BOXCH, spec, spec_fixed, rates, VT, depo, timeStrLen,...
       temperature, pressure, relative_humidity, rate_constants, ...
       emissions, surf_source, output_file_comment, output_file_created_by);
   
 % main time loop for integrating chemistry & writing model output
 [spec, spec_fixed, rates, VT, rate_constants] = ...
       integrate_model(model_path,NTIM_CHEM,NLEV,dt_chem,dt_kpp,Times,...
       temperature,pressure,relative_humidity,jrates,spec,spec_fixed,emissions,surf_source, rates,VT,BOX_WALL,BOXCH,Kz,...
       rate_constants, run_chem, run_vert_diff, addemissions, diffusion_constant, K_het, Eff_dep_surf, n_step_diff,...
       depo,total_loss_to_ground, timeStrLen);
   
 disp(['Model run complete!']);

 return
 % end one dimensional model
