#!/usr/bin/env perl

# Name : Scott Kratochvil
# Class : CSCI 2850
# Program # : 2
# Due Date : 9/1/18

# Colleagues: None
# This is a small program to do a little basic math.

use Modern::Perl;

print "Enter first number: ";
chop (my $one = <>);

print "Enter second number: ";
chop (my $two = <>);

print "Enter third number: ";
chop (my $three = <>);

my $largest = $one;
if ($two > $one) {
    $largest = $two;
}
if ($three > $largest) {
    $largest = $three;
}

my $smallest = $one;
if ($two < $one) {
    $smallest = $two;
}
if ($three < $smallest) {
    $smallest = $three;
} 

my $avg = ($one + $two + $three) / 3;

say "ADD:",$one + $two + $three;
printf("AVG:%.3f\n",$avg);         
say "PRD:",$one * $two * $three;
say "LRG:",$largest;
say "SML:",$smallest;



