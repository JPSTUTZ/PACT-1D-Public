function [ lambda ] = mean_free_path( temperature, diffusion_constant)

% calulate the mean free path in air (lambda) in meters
% Caluate mean free path using Fuchs and Sutugin 1971
%Equation from Seinfeld and Pandis, 1998, Table 11.1

% Temperature in kelvin
% Diffusion constant in m2 s-1
% Molecular weight in g/mol

     global MW;  %molecular weight in grams/mol
     
     dims = size(temperature);
     NLEV = dims(1);
     NTIM = dims(2);
     dims = size(MW);
     NSPEC = dims(2);
     k_boltz = 1.38064852e-23;  % m2 kg s-2 K-1
     k_boltz = k_boltz*1000.;   % m2  g s-2 K-1
     Pi = 3.14159;
     Na = 6.0221409e23;
     MW_molec = MW/Na;
          
     lambda = zeros(NSPEC, NLEV, NTIM);
     
     %    set up mean free path length
     %    free path length (lambda=freep):
     for l=1:NSPEC
         for m=1:NLEV
            for n=1:NTIM
              %mean speed of molecules
              C_bar = (8*k_boltz*temperature(m,n)/(Pi*MW_molec(l)))^0.5;    %Mean molecular speed, Equation 11.24
              lambda(l,m,n) = 3*diffusion_constant(l,m,n)/C_bar;            %mean free path Table 11.1, Fuchs & Sutugin
            end
        end
     end

end

