use strict;
use warnings;

my $line;
my $file_in;
my $file_out;

$file_in='mech_Jac_SP.m';
$file_out='mech_Jac_SP_new.m';

open(FILE_IN,'<',$file_in) or die("Could not open file.");

#read lines, see when the global variable is declared "global LU_ICOL" 
my $count = 0;
my $count_save_start = 0;
my $count_save_end = 0;
foreach $line (<FILE_IN>)  {   
    $count = $count+1;
    if ($line =~ "global LU_ICOL") 
    {
      $count_save_start = $count;
    }
    
}
#print("count save start = $count_save_start \n");
close(FILE_IN);

#reopen the input file, loop trhough the lines and write them out
$count = 0;
open(FILE_IN, $file_in) or die("Could not open  file.");
open(FILE_OUT,'>', $file_out) or die("Could not open file.");

foreach $line (<FILE_IN>)  {   
  #if print out the lines as they are if we are before count
  if ($count == $count_save_start) 
  {
    print FILE_OUT $line ;
    print FILE_OUT " \n";
    print FILE_OUT "B=zeros(1,2000);        % This dimension may have to be increase for larger models\n" ;
    print FILE_OUT "JVS=zeros(1,length(LU_IROW));    % dimension linked to an existing global variable and should be OK\n" ; 
    print FILE_OUT " \n";
    $count = $count+1;
  } 
  else 
  {
    print FILE_OUT $line ;
    $count = $count+1;
  } 
}
close(FILE_IN);
close(FILE_OUT);


