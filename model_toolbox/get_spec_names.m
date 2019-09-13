function [ spec_names ] = get_spec_names( model_path )

mech_Parameters;

%add model parameters
specfile = [model_path '/mechanism/mech.spc'];

%-------------------------  Read spec names from the mechanism -------------------
% save the spec names
fid = fopen(specfile);
tmp_names = {''};    %spec that have variable concentraitons
%read all the lines of the spec definition file
tline = fgets(fid);
while (ischar(tline)),
  tline = fgets(fid);
  %variable concentration spec names
  if(strfind(tline,'='))
    %find the equal sign, use the caracters before the equal sign for the spec names, store in tmp, strip spaces
    clear tmp;
    tmp = tline(1:(strfind(tline,'=')-1));
    %add tmp to the list of spec names, trim space from the tmp species name string
    tmp_names = [tmp_names{:} {strtrim(tmp)}];
  end
end
fclose(fid);

%make the real spec names array, ordered in the right way
[~, nspec] = size(tmp_names);

spec_names = {''};
for i=1:nspec
    try
%    ind = get_ind(tmp_names{i});       % Replaced 8/11/17 JPS
    ind = eval(['ind_' tmp_names{i}]);
    spec_names{ind} = tmp_names{i};
    catch
    end
end

% disp(spec_names);
% pause(1000);

