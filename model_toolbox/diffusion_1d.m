%1D diffusion implemented by Jennie Thomas & Cyril Falvo
%Edited by Jochen Stutz - 18 Sept 2019
function [ spec_t1 , VT_t , depo_t, total_loss_to_ground, surf_source_emi] = diffusion_1d (spec_t0, BOX_WALL, BOXCH, ...
    Kz1, Kz2, diffusion_constant1, diffusion_constant2, rho, temperature, NLEV, ...,
    dt_diff_in, Eff_dep_vel_t,  n_step_diff, total_loss_to_ground)

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
diff_spec                  = zeros(NVAR,NLEV);  %difference during diffusion for each species due to diffusion/deposition on model levels
sum_diff                   = zeros(NVAR,1);     %vertical column change before and after diffusion/deposition

%save box wall to wall distance in cm
BOX_WALL_cm = BOX_WALL*100. ; %box wall to wall distance in cm

%how much backward vs. forward integraton to consider
%backward alpha = 1.0, forward  alpha = 0.0
alpha = 1.0;

%set the diffusion time step should be set according to the lowest box
%Kz and the time step such that the following is true
%N_TIME_DIFF = ceil(dt_diff_in*Kz(1)/BOX_WALL(1)/(BOXCH(2)-BOXCH(1)));
N_TIME_DIFF = n_step_diff;

%disp(['running diffusion for ', num2str(N_TIME_DIFF) ,' steps']);
dt_diff = dt_diff_in/N_TIME_DIFF;

%set spec t1 = spec t0
spec_t1 = spec_t0;

%Calcualte online deposition velocity - modify online_depo_vel
%COMMENTED out for now
% to change deposition velocities during a run
%Eff_dep_vel_t = online_depo_vel(Eff_dep_vel_t);

%loop over diffusion time steps
for ii = 1:N_TIME_DIFF
    %loop over species
    for nn = 1:NVAR
        
        %Get the effective deposition velocity for this species
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
    for nn=1:NVAR
        diff_spec(nn,1)=spec_before_diff(nn,1)*BOX_WALL_cm(1) - spec_after_diff(nn,1)*BOX_WALL_cm(1);
        for k=2:NLEV
            diff_spec(nn,k)=spec_before_diff(nn,k)*(BOX_WALL_cm(k)-BOX_WALL_cm(k-1)) - spec_after_diff(nn,k)*(BOX_WALL_cm(k)-BOX_WALL_cm(k-1));
        end
        %save the deposition rate for this instant
        
        sum_diff(nn)=sum(diff_spec(nn,:));
        %save and sum the total deposition rate, divide by the timestep at the very end
        loss_to_ground_inst(nn) = -1*sum_diff(nn);     %positive term, ground storage
        depo_t(nn)            = depo_t(nn) + sum_diff(nn);  %depo_t is the total deposition, summed here - divided by time step later
    end
    
    %make cumulative surface storage sum
    total_loss_to_ground = total_loss_to_ground+loss_to_ground_inst  ; %molec/cm2
    
end  %end loop over sub timesteps

%calculate vertical trasnport rate - this is change in number/cm3/s for each level
%This is due to vertical mixing and deposition
VT_t = (spec_t1-spec_t0)/double(dt_diff_in);

%Divide deposition amount by the timestep, number/cm2/s
depo_t = depo_t/double(dt_diff_in);

end
