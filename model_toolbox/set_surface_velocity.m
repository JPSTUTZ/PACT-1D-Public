function [ K_surface_uptake ] = set_surface_velocity( temperature, alpha, spec_names)

%Set up surface uptake velocity based on the kinetic theory of gases
%This is uptake to the surface in the lowest model level!!!
%alpha is surface uptake probability, for each species

global MW;

%get number of levels, times, and species
dims = size(temperature);
NLEV = dims(1);
NTIM = dims(2);
dims = size(MW);
NSPEC = dims(2);

%set mean speed of molecules
mean_speed = set_mean_speed(temperature);  %m s-1

%calcualte the effective deposition velocity in cm/s for surface reactions
%K_het = 1/4 * v_bar * alpha
K_surface_uptake = zeros(NSPEC,NTIM);

level = 1;
for i=1:NSPEC
   for k=1:NTIM
           K_surface_uptake(i,k) = 0.25*mean_speed(i,level,k)*alpha(i);  %m/seconds
   end
end


end

