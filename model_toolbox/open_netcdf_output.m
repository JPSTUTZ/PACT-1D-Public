function open_netcdf_output(model_path,nlev,ntim,Times,BOX_WALL,BOXCH,...
    spec_conc,spec_conc_fixed,rates,VT,depo,DateStrLen,...
    temperature,pressure,relative_humidity, rate_constants, emissions, surf_source, total_loss_to_ground, output_file_comment, output_file_created_by)

%open netcdf files, write the initial values there

open_spec_file (model_path, Times, nlev, ntim, DateStrLen, spec_conc,...
    spec_conc_fixed, temperature, pressure, relative_humidity, BOX_WALL, BOXCH, output_file_comment, output_file_created_by);

open_rate_file (model_path, Times, nlev, ntim, DateStrLen, rates, BOX_WALL, BOXCH, output_file_comment, output_file_created_by);

open_rate_constant_file (model_path, Times, nlev, ntim, DateStrLen, rate_constants, BOX_WALL, BOXCH, output_file_comment, output_file_created_by);

open_depo_file (model_path, Times, ntim, DateStrLen, depo, output_file_comment, output_file_created_by);

open_vertical_transport_file (model_path, Times, nlev, ntim, DateStrLen, VT, BOX_WALL, BOXCH, output_file_comment, output_file_created_by);
 
open_emission_file( model_path, Times, nlev, ntim, DateStrLen, emissions, BOX_WALL, BOXCH, output_file_comment, output_file_created_by)

open_surf_source_file( model_path, Times, nlev, ntim, DateStrLen, surf_source, total_loss_to_ground, BOX_WALL, BOXCH, output_file_comment, output_file_created_by)
