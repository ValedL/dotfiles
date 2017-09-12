#!/usr/bin/env perl
use Getopt::Std;
use strict;
use Term::ANSIColor; 

my %opts;
getopts('hsc:l:',\%opts);
    if ($opts{h}){
      print<<EoF; 
DESCRIPTION

$0 will highlight the given pattern in color. 

USAGE

$0 [OPTIONS] -l PATTERN FILE

If FILE is ommitted, it reads from STDIN.

-c : comma separated list of colors
-h : print this help and exit
-l : comma separated list of search patterns (can be regular expressions)
-s : makes the search case sensitive

EoF
      exit(0);
    }

my $case_sensitive=$opts{s}||undef; 
my @color=('bold red','bold blue', 'bold yellow', 'bold green', 
           'bold magenta', 'bold cyan', 'yellow on_magenta', 
           'bright_white on_red', 'bright_yellow on_red', 'white on_black');
## user provided color
if ($opts{c}) {
   @color=split(/,/,$opts{c});
}
## read patterns
my @patterns;
if($opts{l}){
     @patterns=split(/,/,$opts{l});
}
else{
    die("Need a pattern to search for (-l)\n");
}

# Setting $| to non-zero forces a flush right away and after 
# every write or print on the currently selected output channel. 
$|=1;

while (my $line=<>) 
{ 
    for (my $c=0; $c<=$#patterns; $c++){
    if($case_sensitive){
        if($line=~/$patterns[$c]/){
           $line=~s/($patterns[$c])/color("$color[$c]").$1.color("reset")/ge;
        }
    }
    else{
        if($line=~/$patterns[$c]/i){
          $line=~s/($patterns[$c])/color("$color[$c]").$1.color("reset")/ige;
        }
      }
    }
    print STDOUT $line;
}

