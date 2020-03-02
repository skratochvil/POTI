#!/usr/bin/env perl

use Modern::Perl;

my $numParams = @ARGV;

if ($numParams != 1)
{
    say "Improper usage";
    exit;
}    

open (IN,"/etc/passwd"); # this opens the file for processing
my @wholeFile = <IN>; # this reads in the file, line by line, into
# individual elements of array @wholeFile

close IN; # this closes the file


foreach my $line (@wholeFile) # process all lines of the file
{
    print $line; # print the line so we can see it all
     my ($userid, $firstname, $lastname);

    # send $line to function to grab userid, first name and last name
 
    ($userid, $firstname, $lastname) = getNames($line);
    my @args = ("finger", $userid);

    my $sxUserId = soundex($userid);
    my $sxFirstName = soundex($firstname);
    my $sxLastName = soundex($lastname);

#    say $sxUserId;
#    say $sxFirstName;
#    say $sxLastName;
    


}
    sub getNames 
    {
    my $parameter;

            $parameter = shift; # get the argument sent to the function
           
           $parameter =~ /(^\w+\-?\w+?):/g;
           my $login = $1;

          my $fname; 
          if ($parameter =~ /\w+\:\*?\w?\:\w+\:\w+\:(\w+)/) {$fname = $1;}
          else {$fname = "";}

          my $lname;
          if ($parameter =~ /(\w+),/) { $lname = $1;}
          else {$lname = "";}

           my @results = ( $login, $fname, $lname );
           # put real code here to process $parameter and get the real results
           return @results;
    }

### The goal of the soundex subroutine below is to take in a string
               ### which will be a last name and process it via Soundex magic,
               ### resulting in $sdxValue at the very end containing the Soundex
               ### code for the input. So, if "Euler" (no quotes) gets passed in
               ### to $temp, $sdxValue should contain "E4600" when all work is done.
               sub soundex {
                my $temp = $ARGV[0];
             #  my $temp = shift;
                   $temp = uc $temp; # uppercase the name passed in to normalize it
                   my @nameArray = split(//, $temp);
                   my @sdxArray = shift @nameArray;
                   my @noRepeats = @sdxArray;
                   my $toReturn = "";

                   my $prevChar = $sdxArray[0];

                    for my $letter (@nameArray)
                    {
                        if (soundexChar($letter) ne soundexChar($prevChar) && soundexChar($letter) ne '-1')
                        {
                            push @sdxArray, soundexChar($letter);    
                        }
                        $prevChar = $letter;    
                    }    

                    for my $letter(@sdxArray)
                    {
                        $toReturn = $toReturn . $letter;            
                    }

                    my $length = length($toReturn);
                    if ($length == 1) {$toReturn = $toReturn . "0000"};
                    if ($length == 2) {$toReturn = $toReturn . "000"};
                    if ($length == 3) {$toReturn = $toReturn . "00"};
                    if ($length == 4) {$toReturn = $toReturn . "0"};
                    if ($length > 5) {$toReturn = substr $toReturn, 0, 5};

                    return $toReturn;

                }    
 
              sub soundexChar() 
                {
                    my $letter = shift;

                    if ($letter eq 'B' | $letter eq 'F' | $letter eq 'P' | $letter eq 'V')
                       {
                            return '1';  
                       }
                       if ($letter eq 'C' | $letter eq 'G' | $letter eq 'J' | $letter eq 'K'
                         | $letter eq 'Q' | $letter eq 'S' | $letter eq 'X' | $letter eq 'Z')
                       {
                            return '2';
                       }    
                       if ($letter eq 'D' | $letter eq 'T')
                       {
                            return '3';
                       }    
                       if ($letter eq 'L')
                       {
                            return '4';
                       }    
                       if ($letter eq 'M' | $letter eq 'N')
                       {
                            return '5';
                       }    
                       if ($letter eq 'R')
                       {
                            return '6';
                       }
                       return -1;
                   }
            
  
