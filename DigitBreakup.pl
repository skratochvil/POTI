#!/usr/bin/env perl

# Name : Scott Kratochvil
# Class : CSCI 2850
# Program # : 3
# Due Date : 9/6/18

# Colleagues: None
# This is a basic program that prompts for a number between 10000 and 99999
# then prints the digits separated by 3 spaces each.


use Modern::Perl;

my $validNum = 1;
say "Enter a five-digit number: ";
chomp (my $number = <>);

if ($number > 99999 || $number < 10000) {
    print "ERROR: Your number must be in the range 10000 and 99999.";
    $validNum = 0;
}

if ($validNum) {
    my @array = split(//, $number);
    for my $digit(@array) {
        print "$digit   ";
    }    
}

say "";

