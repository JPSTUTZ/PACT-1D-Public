function [ K_het ] = set_heterogenous_reactions( temperature, diffusion_constant, ...
    aerosol_radius, aerosol_number, aerosol_rxn_probabilities, reactant_name)

%Set up heterogenous reaction rates
%calculate everything we can, then multipy by aerosol_rxn_probabilities (the reaction
%probability, and the reactant gas concentraiton within KPP)

%note aerosol radius in cm
%aerosol number concentration in # cm-3
%aerosol_rxn_probabilities is heterogenous reaciton pobability OR unreactive uptake probability alpha, for each species

%constant
Pi = 3.14159;

mech_Parameters;
global MW;
global het_reaction_index;
global n_het_rxns;

%get number of levels, times, and species
dims = size(temperature);
NLEV = dims(1);
NTIM = dims(2);
NRXN = n_het_rxns;

%set mean speed of molecules
mean_speed = set_mean_speed(temperature);  %m s-1
mean_speed = mean_speed*100.;              %cm s-1

%set up mean free path of molecules
lambda = mean_free_path(temperature, diffusion_constant);  %mean free path in meters
lambda = lambda*100.;                                      %mean free path in cm

%set aerosol surface area
aerosol_surface_area = zeros(NLEV,NTIM);  %final units in m2 aerosol per m3 air
aerosol_radius = aerosol_radius*1.e-7;    %convert from nm to cm
for j=1:NLEV
    for k=1:NTIM
        aerosol_surface_area(j,k) = aerosol_number(j,k) * 4 * Pi * aerosol_radius(j,k)^2.; 
    end
end

%Calculate the Knudsen number
%ratio of the mean free path in cm to the aerosol radius in cm
Kn = zeros(NRXN,NLEV,NTIM);
for i=1:NRXN
    i_ind = het_reaction_index(i);
    spec_ind = get_ind(reactant_name{i_ind});
    for j=1:NLEV
       for k=1:NTIM         
           Kn(i_ind,j,k) =  lambda(spec_ind,j,k)/aerosol_radius(j,k);
        end
    end
end

%calculate the Fuchs and Sutugin (1071) expression from Table 11.1 
%Seinfeld and Pandis, 1998 
J_corr = zeros(NRXN,NLEV,NTIM);

for i=1:NRXN
    i_ind = het_reaction_index(i);
    for j=1:NLEV
       for k=1:NTIM
            %only calculate this for species with a reaction probability
            %(aerosol_rxn_probabilities) greater than zero
            if (aerosol_rxn_probabilities(i_ind) > 0 && het_reaction_index(i_ind) >0)              
                upper = 0.75*aerosol_rxn_probabilities(i_ind)*(1+Kn(i_ind,j,k));
                lower = Kn(i_ind,j,k)^2+Kn(i_ind,j,k)+0.283*Kn(i_ind,j,k)*aerosol_rxn_probabilities(i_ind)+0.75*aerosol_rxn_probabilities(i_ind);
                J_corr(i_ind,j,k) = upper/lower;
            else
                J_corr(i_ind,j,k) = 0;
            end
        end
    end
end


%calcualte the effective rate constant in 1/s for surface reactions
%given by 
%K_het = 1/4 v_bar a_s J_corr 
%v_bar = mean molecular speed
%a_s = aerosol surface area
%J_corr - defined above
K_het = zeros(NRXN,NLEV,NTIM);

for i=1:NRXN
    i_ind = het_reaction_index(i);
    spec_ind = get_ind(reactant_name{i_ind});
    %disp(reactant_name{i_ind})
    for j=1:NLEV
       for k=1:NTIM
            %only for heterogenous reactions with a reaciton index assigned
            %otherwise the heterogenous reaciton rate is zero 
            if (het_reaction_index(i_ind) > 0)
                K_het(i_ind,j,k) = 0.25*mean_speed(spec_ind,j,k)*aerosol_rxn_probabilities(i_ind)*aerosol_surface_area(j,k)*J_corr(i_ind,j,k);
            end
        end
    end
end


end

