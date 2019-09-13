function [ reaction_comment ] = get_rxn_desc( model_path )
%get descriptions of the reactions from the mechanism

mech_Parameters;

%make speace for reaction rate names
for i = 1:NREACT
    for j = 1:100
      reaction_comment(i,j) = ' ';  %blank spaces, make sure it's longer than tline
    end
end

%read in the reaction rate names
fid = fopen([model_path '/mechanism/mech.eqn']);
tline = fgets(fid);
count = 1;
while ischar(tline)   
    tmp = strfind(tline, '{');  %pick only lines with a reaciton rate listed, these start with {R
    if tmp > 0
        %replace newline character
        tline = strrep(tline,sprintf('\n'),'');
        %find just the reaction name for the output label
        start_ind = strfind(tline, '{') ;   
        end_ind   = strfind(tline, ':') - 1;  
        if end_ind > 0 
            end_ind = end_ind;
        else
            [~, end_ind] = size(tline);
        end
        length = end_ind-start_ind;
        reaction_comment(count,1:length+1) = tline(start_ind:end_ind);
        count = count+1;
    end
    tline = fgets(fid);
end

end

