function [ind] = get_indf(name)
%get the index for fixed concentraiton species

%get the model parameters
%mech_Parameters;
%ind = eval(['indf_' name]);

x=['indf_' name];
eval(['global ' x]);

%get the index
ind = eval(x);

end
