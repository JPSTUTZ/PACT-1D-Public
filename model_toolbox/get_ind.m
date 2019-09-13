function [ind] = get_ind(name)
%get the index for a specific spec name

%%Load the mechanism parameters
%mech_Parameters;
%tic

x=['ind_' name];
eval(['global ' x]);

%get the index
ind = eval(x);

%ind = eval(['ind_' name]);


%toc

end
