function  [spec_new,total_loss_to_ground] = surface_source(spec, dt, BOX_WALL_cm, depo_rate, rho, temperature,total_loss_to_ground)

% calculate a surface emissions source, to be customized based on your case, here an example for I2 emissions from the ocean based on ozone concentrations 

%global variable
global GStruct TIME

%set the new concentrations equal to the old concentrations
spec_new = spec;

% set up dimensions of surface emissions source array
    spec_surface_source = zeros(size(spec));
%   size(spec_surface_source)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %IODINE OCEAN SOURCE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % get index for species emitted, taken up to ocean
%     I2_ind  =get_ind('I2');
%     HOI_ind =get_ind('HOI');
%     O3_ind  =get_ind('O3');
% 
% % Parameterization from MacDonald et l 2014
%     fac1=double(dt)/BOX_WALL_cm(1);
%     ws = 2;                                     % windspeed ms^-1
%     O3MR=spec(O3_ind,1)/2.5e10;                 %JLT needs updated to use actual density of air
%     SST=298.;                                    %JLT needs updated to use actual surface temperature in the model
%     Iminus=1.46E6*exp(-9134./SST);
%     F_HOI=O3MR *(4.15e5 * Iminus^0.5 / ws - 20.6/ws - 23600.* Iminus^0.5); %Flux in
%     F_I2=O3MR * Iminus^1.3 * (1.74e9-(6.54e8 * log(ws)));
%     fac2=6.023e23*1e-9*1e-4/86400.;
% 
% % save the surface source for I2 and HOI
%     spec_surface_source(I2_ind,1) = F_I2*fac1*fac2; 
%     spec_surface_source(HOI_ind,1) = F_HOI*fac1*fac2; 
% 
% % set spec_new equal to spec
% %     spec_new = spec;
% % update the concentration of I2 and HOI adding the surface source
%     spec_new(HOI_ind,1) = spec_surface_source(HOI_ind,1) + spec(HOI_ind,1);
%     spec_new(I2_ind,1) = spec_surface_source(I2_ind,1)  + spec(I2_ind,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%END IODINE SURFACE SOURCE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%HONO surface sources - night and day
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%source setup, emit into levels 2 and 3
HONO_ind = get_ind('HONO');
NO2_ind  = get_ind('NO2');
J_NO2    = jrates_name('J_NO2',TIME,GStruct);
%level1 = 1;      %Model level to put a portion of the emissions
%level1Fac = 0.01;  %fraction of emissions to put in model level 1
%level2 = 2;      %Model level to put another portion of the emissions
%level2Fac = 1.-level1Fac;  %fraction of emission for this level


%a factor we need - dT/dZ for the layer that includes deposition (s/cm)
facLev1=double(dt)/BOX_WALL_cm(1);  %We need this factor to distrubte the emissions within this layer, for the timestep
%facLev2=double(dt)/(BOX_WALL_cm(2) - BOX_WALL_cm(1)); %We need this factor to distrubte the emissions within this second layer, for the timestep


%HONO formation at night:
spec_surface_source(HONO_ind,level1) = -1*0.5*depo_rate(NO2_ind)*facLev1;
%spec_surface_source(HONO_ind,level2) = -1*0.5*level2Fac*depo_rate(NO2_ind)*facLev2;

%HONO Formation During the Day, add to surface source at night:
%spec_surface_source(HONO_ind,level1) = -1*0.5*level1Fac*depo_rate(NO2_ind)*J_NO2^3/(1.e-2^3)*facLev1+spec_surface_source(HONO_ind,level1);
%spec_surface_source(HONO_ind,level2) = -1*0.5*level2Fac*depo_rate(NO2_ind)*J_NO2^3/(1.e-2^3)*facLev2+spec_surface_source(HONO_ind,level2);

%KBT edit 5/6/19 - changed factor of 0.5 to 3 (6e-5 is max NO2 uptake in Wong et al, 2013, 3x higher than what we have)
% and changed 1e-2 to 7e-3, which is the approximate noontime JNO2 value for our modeled days
spec_surface_source(HONO_ind,level1) = -1*20*depo_rate(NO2_ind)*J_NO2^3/((7.e-3)^3)*facLev1+spec_surface_source(HONO_ind,level1);
%spec_surface_source(HONO_ind,level2) = -1*20*level2Fac*depo_rate(NO2_ind)*J_NO2^3/((7.e-3)^3)*facLev2+spec_surface_source(HONO_ind,level2);


%Update the HONO concentration with the surface source in the lowest layer
spec_new(HONO_ind,level1) = spec(HONO_ind,level1)+spec_surface_source(HONO_ind,level1);
%spec_new(HONO_ind,level2) = spec(HONO_ind,level2)+spec_surface_source(HONO_ind,level2);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%END HONO surface sources
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


end
