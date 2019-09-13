function [ calculated_rates ] = calculate_rates( rate_constants , spec_conc)
%Takes in the rate constants and caclualtes the rates using the mechanism

global reactant_list;

%%get info from the mechanism
mech_Parameters;

%number of reactions is given in the mechanism by NREACT
calculated_rates = zeros(NREACT,1);

% %check some things
% disp('checking')
% disp('size rate constants')
% disp(size(rate_constants))
% disp('size calcualted rates')
% disp(size(calculated_rates))
% disp('NREACT')
% NREACT
% pause(1000)

%
% disp ('calcualting rates');
% tic
% disp('---------------------------looping over reactions');
for i=1:NREACT
    %get the reactant names
    reactants = reactant_list(i,:);
    %get the number of species reacting for this reaction
    [tmp nreactants] = size(reactants);
    
    %loop over the number of reactants, multiply their concentrations
    %to get conc_reac
    
    %set the initial concentraiton of reactants to 1
    conc_reac = 1;
    
%     toc
%     disp('looping over reactants for this reaction');
    %loop over the reactants, multipy their concentrations together
    for j=1:nreactants
        %don't look for a concentration of the reactant is sunlight ('hv'),
        %or there is an empty reactant name
%         disp('comparing strings');
%         toc
        if (strcmp(reactants{j},'hv') == 0)  %hv is the reactant
           if (not(isempty(reactants{j})))   %empty reaction name 
%              disp('multiply');
%              toc
             reac_str = char(reactants{j});
             %disp(reac_str);
%             ind = get_ind(reac_str);      % replaced 8/11/17
             ind = eval(['ind_' reac_str]);
             conc_reac = squeeze(conc_reac*spec_conc(ind));
             %conc_reac
           end
        end
    end

    
    %uncomment for testing
    %disp('conc_reac')
    %size(conc_reac)
    %disp('rate_constants(i)')
    %size(rate_constants(i))

    %multiply concentrations by the rate constants
    calculated_rates(i) = rate_constants(i)*conc_reac;
     
    %uncomment for testing
    %disp('size of calculated rates for this reaction')
    %size(calculated_rates(i))
    %calculated_rates(i)
    %disp('in the loop the size of the calculated rates are')
    %size(calculated_rates)
    %pause(1000)
    %conc_reac
    %rate_constants(i)
    %rates(i)
    
    
end
% disp('size of calculated rates for this time and level - in the routine')
% size(calculated_rates)
% calculated_rates(:,1)
% disp('end of rate calc');
% toc
% disp('done calculating rates');

end


