#!/usr/bin/env perl

# Name : Scott Kratochvil
# Class : CSCI 2850
# Program # : 5
# Due Date : 9/8/18

# Colleagues: None
# This is a basic program that prompts for a binary number and converts it to a decimal number.

use Modern::Perl;

print "Please enter a binary number up to 30 digits: ";
chomp (my $binary = <>);

my $reversed = reverse $binary;

my @array = split(//, $reversed);
my $length = $#array;

my $total = 0;
for (my $a = 0; $a <= $length; $a++) 
{
    $total += ($array[$a] * (2 ** $a));
}

say "$binary is $total in decimal.";


