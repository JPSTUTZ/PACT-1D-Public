function [aerosol_rxn_probabilities, reactant_name]=get_aerosol_reaction_probabilities(model_path)

mech_Parameters;
global het_reaction_index;
global n_het_rxns;

infile = [model_path '/input/het_uptake_aerosols.txt'];

%get gamma values here
fid=fopen(infile);
 
%determine the number of lines in the file
n = 0;
tline = fgetl(fid);
while ischar(tline)
  tline = fgetl(fid);
  n = n+1;
end
fclose(fid);

%reopen the file
fid=fopen(infile);

count = 1;
for i=1:n
    line = fgetl(fid);
    if(any(ismember(line,'#')) || isempty(line)) 
        %disp('comment line')
        %disp(line);
    else
        %disp('data line')
        %disp(line);
        fields = strsplit(line);
        rxn_index = str2num(char(fields(4)));
        %disp(rxn_index)
        het_reaction_index(count) = rxn_index;
        aerosol_rxn_probabilities(rxn_index) = str2num(char(fields(3)));
        reactant_name(rxn_index) = fields(1);
        count = count+1;
        clear fields;
    end
end

[tmp n_het_rxns] = size(het_reaction_index);


end

