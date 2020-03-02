#!/usr/bin/env perl

# Name : Scott Kratochvil
# Class : CSCI 2850
# Program # : 10
# Due Date : 10/21/18
# Colleagues: None
# This is a program that runs the finger command based on soundex matches for a given name.

use Modern::Perl;
use experimental 'smartmatch';

my $numArgs = @ARGV;
if ($numArgs != 1) 
{
    say "Usage: $0 possible name";
    exit 1;
} 

my $sdxIn = soundex($ARGV[0]);


open (IN,"/etc/passwd"); # this opens the file for processing
my @wholeFile = <IN>; # this reads in the file, line by line, into
# individual elements of array @wholeFile

close IN; # this closes the file
my $anyMatch = 0; #true if any match is found

say "\nThe name you were looking for, $ARGV[0], converted to $sdxIn.";

foreach my $line (@wholeFile) # process all lines of the file
{
    #true if a match is found for this record
    my $matchFound = 0;
    my ($userid, $firstname, $lastname);

    #pull info for each record
    ($userid, $firstname, $lastname) = getNames($line);

    my @args = ("finger", $userid);

    #check for Id match

=pod
    my $sxUserId = soundex($userid);
    if ($sdxIn eq $sxUserId)
    {
        say "";
        $matchFound = 1;
        system(@args);
        $anyMatch = 1;
    }    
=cut


    #check for first name match
    if ($firstname)
    {
        my $sxFirstName = soundex($firstname);
        if ($sdxIn eq $sxFirstName && !$matchFound)
        {
            say "";
            system(@args);
            $anyMatch = 1;
            $matchFound = 1;
        }    
    }    

    #check for last name match
    if ($lastname)
    {
        my $sxLastName = soundex($lastname);
        if ($sdxIn eq $sxLastName && !$matchFound)
        {
            say "";
            system(@args);
            $anyMatch = 1;
            $matchFound = 1;
        } 
    }


}

if (!$anyMatch)
{
    say "No such user.\n";
}  
else
{
    say "";
}   

###This method returns the login, first name, and last name for a record.
sub getNames 
{
    my $parameter;

    $parameter = shift; # get the argument sent to the function

    $parameter =~ /(^\w+\-?\w+?):/g; #retrieve login
    my $login = $1;

    my $fname; 
    if ($parameter =~ /\w+\:\*?\w?\:\w+\:\w+\:(\w+)/) {$fname = $1;} #retrieve first name
    else {$fname = "";}

    my $lname;
    if ($parameter =~ /(\w+),/) { $lname = $1;} # retrieve last name
    else {$lname = "";}

    my @results = ( $login, $fname, $lname );
    return @results;
}

### The goal of the soundex subroutine below is to take in a string
### which will be a last name and process it via Soundex magic,
### resulting in $sdxValue at the very end containing the Soundex
### code for the input. So, if "Euler" (no quotes) gets passed in
### to $temp, $sdxValue should contain "E4600" when all work is done.
sub soundex {
    
    my $temp;
    $temp = $_[0];
#    say "calling soundex on $temp";
    $temp = uc $temp; # uppercase the name passed in to normalize it
    my @nameArray = split(//, $temp);
    my @sdxArray = shift @nameArray;
    my $toReturn = "";

    my $prevChar = $sdxArray[0];

    for my $letter (@nameArray)
    {
        #build an array of characters which are not repeated and have a code number
        if (soundexChar($letter) ne soundexChar($prevChar) && soundexChar($letter) ne '-1')
        {
            push @sdxArray, soundexChar($letter);    
        }
        $prevChar = $letter;    
    }    

    #build a string from the array
    for my $letter(@sdxArray)
    {
        $toReturn = $toReturn . $letter;            
    }

    #convert to appropriate length
    my $length = length($toReturn);
    if ($length == 1) {$toReturn = $toReturn . "0000"};
    if ($length == 2) {$toReturn = $toReturn . "000"};
    if ($length == 3) {$toReturn = $toReturn . "00"};
    if ($length == 4) {$toReturn = $toReturn . "0"};
    if ($length > 5) {$toReturn = substr $toReturn, 0, 5};

    return $toReturn;

}    

### Returns soundex char, or -1 if character has no code number
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



