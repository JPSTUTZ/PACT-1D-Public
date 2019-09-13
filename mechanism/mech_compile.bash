#!/bin/bash

kpp mech.kpp 

echo "CUSTOM FIXES"
echo "1. Fixing mech monitor"
perl fix_mech_Monitor.pl
mv -f mech_Monitor_new.m mech_Monitor.m

echo "2. Addind lines to allocate arrays in mech_Jac_SP"
perl add_lines_JAC.pl
mv -f mech_Jac_SP_new.m  mech_Jac_SP.m 

echo "3. Addind lines to allocate arrays in mech_Fun"
perl add_lines_Fun.pl 
mv -f mech_Fun_new.m mech_Fun.m

echo "4. Fixing mech_Update_RCONST"
perl fix_mech_Update_RCONST.pl 
mv -f mech_Update_RCONST_new.m mech_Update_RCONST.m


