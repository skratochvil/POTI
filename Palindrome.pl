#!/usr/bin/env perl

# Name : Scott Kratochvil
# Class : CSCI 2850
# Program # : 4
# Due Date : 9/7/18

# Colleagues: None
# This is a basic program that prompts for a word and checks if it's a palindrome.

use Modern::Perl;

my $isPalindrome = 1;
print "Enter a 7 character phrase: ";
chomp (my $word = <>);

my @array = split(//, $word);
my $length = $#array;

if ($length == 6) {
    my @reverse = reverse @array;
    for (my $a = 0; $a < 6; $a++) {
        if ($array[$a] ne $reverse[$a]) {
           $isPalindrome = 0;
        }
    }   
    if ($isPalindrome) {
        say "PALINDROME";
    }    
    else {
        say "NOT";
    }    
}
else {
    say "ERROR: That is not a 7-character input";
}    
