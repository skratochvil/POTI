#!/usr/bin/env perl

# Name : Scott Kratochvil
# Class : CSCI 2850
# Program # : 8
# Due Date : 9/30/18

# Colleagues: None
# This is a basic program to process output from the Unix "last" command.

use Modern::Perl;

my $numParams = @ARGV;
if ($numParams != 1)
{
    say "Usage: lastsummary login";
    exit;
}

my $minutes = 0;
my $hours = 0;
my @capture = `last`;
my $login = substr $ARGV[0], 0, 8;

my @logins = grep /\b$login\b/, @capture;
my $numLogins = @logins;

say "Here is a listing of the logins for $ARGV[0]:\n";

my $counter = 1;
for my $record (@logins) {
    if ($record =~ /\((\d)\+/) {
       $hours += (24 * $1);
    }  
 
    if ($record =~ /\((\d\+)?(\d\d):(\d\d)\)/g)
    {
        $minutes += $3;
        $hours += $2;
    }    

    print " " . $counter . ". " . $record;
    $counter++;
}

$hours += ($minutes / 60);
$minutes = $minutes % 60;

say "\nHere is a summary of the time spent on the system for $ARGV[0]:\n";
say $ARGV[0];
say $numLogins;

printf ("%02d:%02d\n\n", $hours, $minutes);
