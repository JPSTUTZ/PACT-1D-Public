use strict;
use warnings;

my $line;
my $file_in;
my $file_out;

$file_in='mech_Update_RCONST.m';
$file_out='mech_Update_RCONST_new.m';

my $lineerror1 = 80 ; 
my $lineerror2 = 497 ; 
$lineerror1 = $lineerror1-1;
$lineerror2 = $lineerror2-1 ; 
#open the input file, loop trhough the lines and write them out
my $count = 0;
my $tmp1;
my $tmp2;
my $tmp3;

open(FILE_IN, $file_in) or die("Could not open  file.");
open(FILE_OUT,'>', $file_out) or die("Could not open file.");

foreach $line (<FILE_IN>)  {   
  #if print out the lines as they are if we are before count
  if ($count == $lineerror1 || $count == $lineerror1+1 || $count == $lineerror2 || $count == $lineerror2+1) 
  {
    if($count == $lineerror1) 
    {
      $tmp1 = $line;
    }
    if($count == $lineerror1+1)
    {
      $tmp1 =~ s/\R//g;
      $tmp1 =~ s/\ //g;
      $tmp2 = $line;
      $tmp3 = "$tmp1 $tmp2";
      my $place_holder = "\.\.\.";
      my $subs = quotemeta $place_holder;
      $tmp3 =~ s/$subs//g;
      $tmp3 =~ s/\ //g;
      print FILE_OUT "   $tmp3" ;
    }
    if($count == $lineerror2) 
    {
      $tmp1 = $line;
    }
    if($count == $lineerror2+1)
    {
      $tmp1 =~ s/\R//g;
      $tmp1 =~ s/\ //g;
      $tmp2 = $line;
      $tmp3 = "$tmp1 $tmp2";
      my $place_holder = "\.\.\.";
      my $subs = quotemeta $place_holder;
      $tmp3 =~ s/$subs//g;
      $tmp3 =~ s/\ //g;
      print FILE_OUT "   $tmp3" ;
    }
    $count = $count+1;
  } 
  else 
  {
    if($line =~ /B0\*/)
    {
      $tmp1 = $line;
      ##print $line;
      $tmp1 =~ s/\*exp\(190\.0\/TEMP//g;
      ##print $tmp1;
      print FILE_OUT $tmp1;
    } 
    else 
    {
      print FILE_OUT $line ;
    }
    $count = $count+1;
  } 
}
close(FILE_IN);
close(FILE_OUT);


