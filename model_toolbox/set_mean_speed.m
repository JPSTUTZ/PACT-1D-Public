function [ mean_speed ] = set_mean_speed( temperature )
%Calcualte the mean speed of molecules - returns speed in m/s
% Temperature in kelvin
% Molecular weight input in g/mol

     global MW;  %molecular weight in grams/mol
     
     %See Pitts and Pitts BOX 5.2 (book)
     
     dims = size(temperature);
     NLEV = dims(1);
     NTIM = dims(2);
     dims = size(MW);
     MW_kg = MW/1000.;  %in kg
     NSPEC = dims(2);
     R = 8.3144598; %J k-1 mol-1
     Pi = 3.14159;
          
     mean_speed = zeros(NSPEC, NLEV, NTIM);
     
     %    set up mean free path length
     %    free path length (lambda=freep):
     for l=1:NSPEC
         for m=1:NLEV
            for n=1:NTIM
              %mean speed of molecules in m/s
              %disp(MW_kg(l))
              mean_speed(l,m,n) = (8 * R * temperature(m,n)/(Pi * MW_kg(l)))^0.5;    %Mean molecular speed (m/s), Equation PP from Pits & Pits in Box 5.2
              %disp(mean_speed(l,m,n))
            end
        end
     end


end




