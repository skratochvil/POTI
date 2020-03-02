#!/usr/bin/env perl

use Modern::Perl;
use experimental 'smartmatch';

say soundex($ARGV[0]);


               ### The goal of the soundex subroutine below is to take in a string
               ### which will be a last name and process it via Soundex magic,
               ### resulting in $sdxValue at the very end containing the Soundex
               ### code for the input. So, if "Euler" (no quotes) gets passed in
               ### to $temp, $sdxValue should contain "E4600" when all work is done.
               sub soundex {
                   my $temp = shift;
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
            

=pod
say "adding letter $letter";
                       say "previous letter $lastElement";

                       if ($letter eq 'B' | $letter eq 'F' | $letter eq 'P' | $letter eq 'V')
                       {
                            push @sdxArray, '1';  
                       }
                       if (($letter eq 'C' | $letter eq 'G' | $letter eq 'J' | $letter eq 'K'
                         | $letter eq 'Q' | $letter eq 'S' | $letter eq 'X' | $letter eq 'Z') && soundexChar($lastElement) ne '2')
                       {
                            push @sdxArray, '2';
                       }    
                       if ($letter eq 'D' | $letter eq 'T')
                       {
                            push @sdxArray, '3';
                       }    
                       if (($letter eq 'L' | $letter eq 'I') && soundexChar($lastElement) ne '4')
                       {
                            push @sdxArray, '4';
                       }    
                       if (($letter eq 'M' | $letter eq 'N') && soundexChar($lastElement) ne '5')
                       {
                            push @sdxArray, '5';
                       }    
                       if ($letter eq 'R')
                       {
                            push @sdxArray, '6';
                       } 
=cut                       
