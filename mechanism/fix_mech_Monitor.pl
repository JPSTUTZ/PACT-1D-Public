use strict;
use warnings;

my $line;
my $file_in;
my $file_out;

$file_in='mech_Monitor.m';
$file_out='mech_Monitor_new.m';

open(FILE_IN,'<',$file_in) or die("Could not open file.");

#read lines, see when the desriptions of the equations starts, save that line 
my $count = 0;
my $count_save_start = 0;
my $count_save_end = 0;
foreach $line (<FILE_IN>)  {   
    $count = $count+1;
    if ($line =~ "EQN_NAMES") 
    {
      $count_save_start = $count;
    }
    if ($line =~ "];") 
    {
      $count_save_end = $count-1;
    }
    
}
#print("$count_save_start $count_save_end \n");
close(FILE_IN);

#reopen the input file, loop trhough the lines and write them out
$count = 0;
open(FILE_IN, $file_in) or die("Could not open  file.");
open(FILE_OUT,'>', $file_out) or die("Could not open file.");
my $substring;
my $endsub = 49;

foreach $line (<FILE_IN>)  {   
  #if this is during the mechanism description printing, cut the line
  if ($count >= $count_save_start && $count < $count_save_end) 
  {
    #example line length before end quote
    #'                        MGLY --> CO + HO2 + C2O3
    $substring = substr($line,0,$endsub);
    print FILE_OUT "$substring'; ... \n" ;
  } 
  elsif ($count == $count_save_end) 
  {
    $substring = substr($line,0,$endsub);
    print FILE_OUT "$substring' ]; \n" ;
    #print $line;
  } 
  else 
  {
  #otherwise just print the line as is
    print FILE_OUT $line;
    #print $line;
  }
  #increment count
  $count = $count+1;
}
close(FILE_IN);
close(FILE_OUT);


