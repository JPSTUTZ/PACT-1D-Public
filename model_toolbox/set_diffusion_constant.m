function [diffusion_constant] = set_diffusion_constant(temperature,pressure,model_path)
%read the list of species from the mech.spc file, set the diffusion
%constant for each molecule

%add model parameters and molecular weights
mech_Parameters;

dims = size(temperature);
NLEV = dims(1);
NTIM = dims(2);

%disp(dims)

global MW;
get_molecular_weight(model_path);


diffusion_constant  = zeros(NVAR,dims(1),dims(2));

%diffusion constant calculated as D = mean_free_path in air*molecular_velocity/3
%final units in m2 s-1
%
%mean_free_path in air calculated according to Seinfeld and Pandis, 1998 edition
%equation 8.6
%
%molecular_velocity calculated according to Modeling chemistry in and above snow at Summit, J.L. Thomas
 
for i=1:NVAR
    for l=1:NLEV
        for t=1:NTIM
            diffusion_constant(i,l,t) = 2*1.8*10^(-5)*8.314*temperature(l,t)/(3*pressure(l,t)*sqrt(0.029)*sqrt(MW(i)*0.001));   
        end
    end
end

end
