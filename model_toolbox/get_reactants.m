function [ reactants ] = get_reactants( index )
%get descriptions of the reactions from the mechanism

global reaction_comment;

%get this reaction name
reaction = reaction_comment(index,:);
%disp(reaction);

%take out the spaces, make str1
str1 = strrep(reaction,' ','');
%disp(str1);

%get the part after the reaction name comment that ends with the character - }
str2 = strsplit(str1,'}');
str3 = char(str2(:,2));

%get the part that includes the reactants, ends with an equal sign
str4 = strsplit(str3,'=');
str5 = char(str4(:,1));

%%plus signs separate the reactants, get the reactant names
reactants = strsplit(str5,'+');


