function [ spec_t1 , VT_t , depo_t, total_loss_to_ground, surf_source_emi] = diffusion_1d (spec_t0, BOX_WALL, BOXCH, ...
    Kz1, Kz2, diffusion_constant1, diffusion_constant2, rho, temperature, NLEV, ..., 
    dt_diff_in, Eff_dep_vel_t, emissions, addemissions, n_step_diff, total_loss_to_ground, run_chem)

%Do 1 dimensional diffusion for this time step, takes in the current
%concentration of species at t=0 and returns species concentrations at t=t+1

    mech_Parameters;
    
    %set up array to save before and after diffusion concentrations
    spec_before_diff       = zeros(NVAR,NLEV);
    spec_after_diff        = zeros(NVAR,NLEV);
    
    %set up array to save deposition rate, vertical transport rate and
    %surface sources
    VT_t                       = zeros(NVAR,NLEV);
    depo_t                     = zeros(NVAR,1);     %the total deposition rate
    depo_t_inst                = zeros(NVAR,1);     %sub_timestep deposition rate, for surface source
    loss_to_ground_inst        = zeros(NVAR,1);     %sub timestep loss to ground for each species in molecules/cm2
    surf_source_emi            = zeros(NVAR, NLEV); %emissions from the surface source routine
    
    %save box wall to wall distance in cm
    BOX_WALL_cm = BOX_WALL*100. ; %box wall to wall distance in cm

    %how much backward vs. forward integraton to consider
    %backward alpha = 1.0, forward  alpha = 0.0
    alpha = 0.5;
    
    %set the diffusion time step should be set according to the lowest box
    %Kz and the time step such that the following is true
    %N_TIME_DIFF = ceil(dt_diff_in*Kz(1)/BOX_WALL(1)/(BOXCH(2)-BOXCH(1)));
    N_TIME_DIFF = n_step_diff;
    
    %disp(['running diffusion for ', num2str(N_TIME_DIFF) ,' steps']);
    dt_diff = dt_diff_in/N_TIME_DIFF;   
    
    %set spec t1 = spec t0
    spec_t1 = spec_t0; 
    
    for ii = 1:N_TIME_DIFF 
        %ADD EMISSIONS for all species, we are working in concentration
        if (addemissions == 1) 
            %disp('-->Adding emissions')
            spec_t1 = spec_t1 + emissions*dt_diff; 
        end
            
        %loop over species
        for nn = 1:NVAR
            
            %Save the effective deposition velocity for this time
            v_eff_spec = Eff_dep_vel_t(nn);
        
            %Interpoalte the Kz values in time
            contrib_t1 = (N_TIME_DIFF-(ii-1))/N_TIME_DIFF;
            Kz = Kz1*contrib_t1+Kz2*(1.-contrib_t1);
          
            %Intepolate Diffusion Constant in Time
            diffusion_constant=diffusion_constant1(nn,:)*contrib_t1+diffusion_constant2(nn,:)*(1.-contrib_t1);
            
            %Calcuate total diffusion constant - Kz + molecular diffusion
            Kz = Kz + diffusion_constant';
                    
            %DO 1D diffusion and deposition
            %save concentration prior to diffusion
            spec_before_diff(nn,:) = spec_t1(nn,:);
            %convert to mixing ratio
            for k=1:NLEV
                spec_t1(nn,k) = spec_t1(nn,k)/rho(k);
            end
            %calcuate the first coefficients needed
            [a_coeffs, b_coeffs, c_coeffs, dp, dm, beta] = coeffs_diffusion_1d_first_step(Kz, rho, BOX_WALL, BOXCH, alpha, dt_diff, NLEV, v_eff_spec);
            %calcuate the remaining coeffiencts
            [d_coeffs] = coeffs_diffusion_1d(spec_t1(nn,:),beta,dp,dm,NLEV, v_eff_spec, dt_diff,BOX_WALL); 
            %do the tridiag algorithim
            spec_t1(nn,:) = solve_triadiag(a_coeffs, b_coeffs, c_coeffs, d_coeffs, NLEV);  
            %convert back to number concentration
            for k=1:NLEV
                spec_t1(nn,k) = spec_t1(nn,k)*rho(k);
            end
            %END 1D diffusion and deposition
            spec_after_diff(nn,:) = spec_t1(nn,:);
        end %end loop over species
        
        %calculate deposition rate for this time
        %in units of molec/cm2/s
        sum_vertical_conc_t0       = zeros(NVAR,1);
        sum_vertical_conc_t1       = zeros(NVAR,1);
        for nn=1:NVAR
            sum_vertical_conc_t0(1) = sum_vertical_conc_t0(nn)+spec_before_diff(nn,1)*BOX_WALL_cm(1);
            sum_vertical_conc_t1(1) = sum_vertical_conc_t1(nn)+spec_after_diff(nn,1)*BOX_WALL_cm(1);  
            for k=2:NLEV
                sum_vertical_conc_t0(nn) = sum_vertical_conc_t0(nn)+spec_before_diff(nn,k)*(BOX_WALL_cm(k)-BOX_WALL_cm(k-1));
                sum_vertical_conc_t1(nn) = sum_vertical_conc_t1(nn)+spec_after_diff(nn,k)*(BOX_WALL_cm(k)-BOX_WALL_cm(k-1));
            end
            %save the deposition rate for this instant
            depo_t_inst(nn) = (sum_vertical_conc_t1(nn) - sum_vertical_conc_t0(nn))/double(dt_diff) ; % loss to ground in molec/cm2/s 
            %save and sum the total deposition rate, divide by the timestep at the very end
            loss_to_ground_inst(nn) = (sum_vertical_conc_t1(nn) - sum_vertical_conc_t0(nn)); 
            depo_t(nn)              = depo_t(nn) + (sum_vertical_conc_t1(nn) - sum_vertical_conc_t0(nn));
        end

        %make cumulative surface deposition sum
        %need to move this up to into the sub-timesteps, such that we can use it in surface source
        %display(size(total_loss_to_ground))
        %display(size(depo_t))
        total_loss_to_ground = total_loss_to_ground+loss_to_ground_inst  ; %molec/cm2
        
        %calculate the amount transported via 1D diffusion
        % this is vertical transport PLUS deposition
        VT_t = (spec_after_diff - spec_before_diff)*dt_diff;
        
        %INTERACTIVE Surface source of HONO, Iodine, or other species, based on
        %deposition amount or concentration in lowermost layer
        %we need chemsitry rates including photolysis rates to do this, only
        %call the surface source if chemistry is on
        if (run_chem==1)
            %Add a surface source, 
            %The surface source routine can be edited to be any species
            %We have I2 and HONO options set up
            %disp('-->Adding surface source')
            spec_t1_before_surface_source = spec_t1;
            %calculate surface source (HONO, iodine, or whatever you want)
            [spec_t1(:,:),total_loss_to_ground] = surface_source(spec_t1(:,:), dt_diff, BOX_WALL_cm, depo_t_inst, rho, temperature,total_loss_to_ground);
            %total surface source emissions sum, on model levels for each species
            surf_source_emi = surf_source_emi+ (spec_t1 - spec_t1_before_surface_source);
        end
    end  %end loop over sub timesteps
    
    %calcualte vertical transport rate, needs to be updated to be right,
    %without emissions or the surface source
    %in units of molec/cm3/s
    for k=1:NLEV
       for nn = 1:NVAR
         VT_t(nn,k) = (spec_t1(nn,k)-spec_t0(nn,k))/double(dt_diff);
       end
    end
    
    %Correct for saved deposition amount, divide by timestep
    depo_t = depo_t/dt_diff_in;
 
    %sum the surface source over the vertical levels, then divide by the
    %timestep   
    surf_source_emi = surf_source_emi/dt_diff_in;
    
    %calculate total vertical transport rate, this is 1D diffusion PLUS
    %deposition in each model level
    VT_t = VT_t/dt_diff_in;

end
