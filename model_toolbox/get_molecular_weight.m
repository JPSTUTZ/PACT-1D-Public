function []=get_molecular_weight(model_path)

global MW;

mech_Parameters;

mech.spc = [model_path '/mechanism/mech.spc'];

fid=fopen(mech.spc);

tmp_names = {''};
molecular_weight=[];

tline = fgets(fid);
while (ischar(tline)),
  tline = fgets(fid);
  if(strfind(tline,'#DEFFIX')),break,end
     if(strfind(tline,'='))
        clear tmp;
        clear weight;
        tmp = tline(1:(strfind(tline,'=')-1));
        tmp_names = strtrim(tmp);
        try
           ind = get_ind(tmp_names);
           start_ind = strfind(tline,'{MW=')+4;
           end_tmp = strfind(tline,'}')-1;
           end_ind = end_tmp(1);
           weight = tline(start_ind:end_ind);
           molecular_weight(ind)= str2double(weight);
        catch
          disp (tmp_names) 
          disp('is not defined in the mech.eqn file') 
        end
     end
end

MW=molecular_weight;

fclose(fid);

end

