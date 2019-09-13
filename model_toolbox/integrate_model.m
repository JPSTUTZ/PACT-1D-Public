function [spec, spec_fixed, rates, VT, rate_constants] = integrate_model(...
    model_path,...
    NTIM_CHEM,...
    NLEV,...
    dt_chem,...
    dt_kpp,...
    Times,...
    temperature,...
    press,rh,...
    jrates,...
    spec,spec_fixed,...
    emissions,surf_source,rates,...
    VT,...
    BOX_WALL,...
    BOXCH,...
    Kz,...
    rate_constants, ...
    run_chem, ...
    run_vert_diff, ...
    addemissions, ...
    diffusion_constant, ...
    K_het, ...
    Eff_dep_surf,...
    n_step_diff,...
    depo,...
    total_loss_to_ground,...
    DateStrLen)

%load the mech parameters
  mech_Parameters;

% set some global variables, we pass these to our global structure, GSTRUCT
  global xIod                                       % Global variable for turnning on/off iodine chemistry  
  global xBr                                        % Global variable for turnning on/off bromine chemistry  
  global xCl                                        % Global variable for turnning on/off chlorine chemistry  

 % Declare a global structure
  global GStruct jrates_list xhet 
  GStruct.jrates_for_kpp=[];
  GStruct.jrates_for_kpp_dt=[];
  GStruct.J_StartTime=0;
  GStruct.J_StopTime=0;
  GStruct.jrates_list=jrates_list;
  GStruct.K_het_for_kpp=[];
  GStruct.K_het_for_kpp_dt=[];
  GStruct.xhet=xhet;
  GStruct.xIod = xIod;
  GStruct.xBr  = xBr;
  GStruct.xCl  = xCl;
  
  %JPS_NEW
  GStruct.J_Counter=1;
  GStruct.J_Length=-1;
  GStruct.J_Index=zeros(length(jrates_list),1);
  
  
  
  global WriteRep
  WriteCounter=WriteRep;
  %------------------------------------------------------------------------
  
  disp(['----------Initial model time--------------------------'])
  disp(Times(1,:));
   
  disp(['----------starting time integration-------------------']);
  disp(['model progress - calculating concentrations for time:']);

  %if things go negative or really small, reset the concentration to this
  %minimum concentraiton value
  minConcVal = 1.e-4;   % in molec cm-3
  
  tic
  
  %main time loop over the chemistry timesteps
  for t=1:NTIM_CHEM-1   %since we integrate to t = t+1, loop to NTIM_CHEM-1        
    disp(Times(t+1,:));
    toc
    
    %Loop over the model levels, set up the fixed concentration species
    for l=1:NLEV
      %loop over the set the fixed concentraiton species for this time,
      %using the temperature, pressure and rh for this time
      fixed_concs_t = set_fixed_concs( temperature(l,t+1), press(l,t+1), rh(l,t+1) );  
      for i=1:NFIX
         spec_fixed(i,l,t+1) = fixed_concs_t(i);
      end
%       %if the time is the last one, also set the fixed concentraiton
%       %species at t+1 for the plotting routines
%       if t==(NTIM_CHEM-1)
%         fixed_concs_t = set_fixed_concs( temperature(l,t+1), press(l,t+1), rh(l,t+1) );
%         for i=1:NFIX
%           spec_fixed(i,l,t+1) = fixed_concs_t(i);
%         end
%       end
     end
    
%       if (addemissions == 1)
%          disp('-->Adding emissions')
%               spec(:,:,t) = spec(:,:,t) + emissions(:,:,t)*dt_chem; 
%     end
%     
    if (run_chem == 1) 
        %integrate chemistry
        disp(['-->Calculating chemistry using kpp']);
        %tic;
        
        %loop over the levels, to do chemistry
        for l=1:NLEV     %to loop over the levels go back to this line
          %provide the initial and final time for this step to kpp, t1 and t2
          t1 = 0;
          t2 = dt_chem;
          
          GStruct.J_StartTime=t1;             %Start Time for chem_driver call
          GStruct.J_StopTime=t2;              %Stop Time for chem_driver call
          GStruct.jrates_for_kpp = jrates(:,l,t);
          GStruct.jrates_for_kpp_dt = jrates(:,l,t+1);
          GStruct.K_het_for_kpp = K_het(:,l,t);
          GStruct.K_het_for_kpp_dt =  K_het(:,l,t+1);

          %--------------------------------------------------------------------------      
          
          %find and eliminate small and negative concentrations
          for i=1:NVAR
              if spec(i,l,t+1) <= minConcVal
                  spec(i,l,t+1) = minConcVal;
              end
          end  

          % call the chem driver for this model layer 
          [spec(:,l,t+1),rate_constants_this_time] = ...
              chem_driver(spec(:,l,t),spec_fixed(:,l,t),...
              t1,t2,dt_kpp,temperature(l,t),press(l,t));   %pressure for this model level and time, Pa);  
  
          %find and eliminate small and negative concentrations
          for i=1:NVAR
              if spec(i,l,t+1) <= minConcVal
                  spec(i,l,t+1) = minConcVal;
              end
          end  
                
          %make unified concentration array with variable and fixed species for
          %time t, this is used for the calculation of the rates
          %concentrations
          spec_all = zeros(NVAR+NFIX,1);
          for n=1:NVAR
            spec_all(n) = spec(n,l,t);
          end
          for n=1:NFIX
             spec_all(n+NVAR) = spec_fixed(n,l,t);
          end

          %JLT check about this - kind of confusing about if we should save the rates for time t or time t+1
          %save the rate constants for output
          rate_constants(:,l,t+1) = rate_constants_this_time;

          %%Calcualte the rates - using the rate constants and species concentraitons 
          %%e.g. k * [O3] for ozone photolysis
          %%e.g. k * [NO][O3] for NO2 formation 
          %disp(['calculating reaction rates for level=' l]);
          tmp_rates = calculate_rates(rate_constants_this_time, spec_all);
          %tmp_rates = rate_constants_this_time;
          rates(:,l,t+1) = tmp_rates;

        end

		%disp(toc);		
    
     else  %if no chemistry just set the next concentration equal the the last one
        disp(['-->Skipping chemistry']);
        spec(:,:,t+1) = spec(:,:,t);
        rates(:,:,t) = 0.;
        rate_constants(:,:,t) = 0.;
    end
    %end loop of the model levels to do chemistry
    

    %emissions/diffusion/surface source calls
    
    if (run_vert_diff == 1) %if doing the vertical diffusion, do this
        disp(['-->Doing vertical mixing - as well as emissions, surface source (if on)']);
        %Doing 1D Diffusion - Take the t=t+1 spec conc and mix them, add emissions and re-write
        
        rho = spec_fixed(indf_AIR,:,t);                     %get the air density for this time
    
           %Doing 1D diffusion including surface emissions, add emissions inside here if emissions are on as well as 1D diffusion;
           [spec(:,:,t+1), VT(:,:,t+1), depo(:,t+1), total_loss_to_ground, surf_source(:,:,t+1)] = diffusion_1d (spec(:,:,t+1), BOX_WALL, BOXCH, ...
                  Kz(:,t),Kz(:,t+1), diffusion_constant(:,:,t), diffusion_constant(:,:,t+1), ...
                  rho, temperature, NLEV, dt_chem, Eff_dep_surf(:,t), emissions(:,:,t), addemissions, n_step_diff, total_loss_to_ground, run_chem);

            %find and eliminate small and negative concentrations
            for l=1:NLEV
              for i=1:NVAR
                if spec(i,l,t+1) <= minConcVal
                    spec(i,l,t+1) = minConcVal;
                end
              end
            end      
        
    else  %if no diffusion, add emissions in any case
        disp(['-->Skipping 1D diffusion']);
        %ADD EMISSIONS
        if (addemissions == 1) 
           disp('-->Adding emissions')
           spec(:,:,t+1) = spec(:,:,t+1) + emissions(:,:,t)*dt_chem; 
        else
           emissions(:,:,t) = 0.;
        end
    end
       
    %write updated concentrations and rates
    %JPS Updated
    

    if((WriteCounter == WriteRep) || (t == NTIM_CHEM-1 ) )
        disp(['-->Writing Output']);
        write_netcdf_output(model_path,NLEV,t,spec,spec_fixed,temperature, press, rh, rates,rate_constants,VT,depo, surf_source, emissions, Times, DateStrLen);
        WriteCounter=0;
    end
    WriteCounter=WriteCounter+1;
 
  end

