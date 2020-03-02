#!/usr/bin/env perl
use Modern::Perl;


open(FH, '>', "tester.txt");

say FH "this is one line";
say FH " hopefully this works";
