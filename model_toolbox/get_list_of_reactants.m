function [ reactants ] = get_list_of_reactants( )
%gets the list of reactants for each reaction

 %get the mechanism parameters
 mech_Parameters;
 
 %Make a list of the reactants, there can not be more than 4 species that
 %react together
 reactants = cell(NREACT,6);
 
for i=1:NREACT
    %get the reactant names
    [tmp nspec] = size(cellstr(get_reactants(i)));
    reactants(i,1:nspec) = cellstr(get_reactants(i));
end
