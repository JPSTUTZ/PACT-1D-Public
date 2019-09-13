function [ground_uptake_probability]=get_surface_uptake_probabilities(model_path)

mech_Parameters;

infile = [model_path '/input/uptake_to_ground.txt'];

ground_uptake_probability = zeros(NSPEC);

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

%loop over the lines and get the values
for i=1:n
    line = fgetl(fid);
    if(any(ismember(line,'#')) || isempty(line)) 
        %disp('comment line')
        %disp(line);
    else
        %disp('data line')
        %disp(line);
        fields = strsplit(line);
        reactant_name = fields{1};
        ind = get_ind(reactant_name);
        %display(reactant_name)
        ground_uptake_probability(ind) = str2num(char(fields(2)));
        %disp(reactant_name)
        clear fields;
    end
end
fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end

