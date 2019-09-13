TO COMPILE THE MECANISM AND APPLY FIXES DO

source mech_compile.bash 

**************************

NOTES:
In the model - the fixed concentration species must match up with what you have as fixed concentration species in the mechanism
You can find the fixed concentrations species in ../model_toolbox/set_fixed_concs.m
If these lists don't match up, the model will not work

There is an error in the mechanism where some reactions are divided on two lines in mech_Update_RCONST.m
 - This has to be fixed by a perl script 
There are incorrect line breaks in mech_Update_RCONST at lines 80 and 497

FIXED issue in  mech_Update_RCONST - removed 500.0/TEMP using perl script 



