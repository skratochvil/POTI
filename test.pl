#!/usr/bin/env perl

use Modern::Perl;
use experimental 'smartmatch';

my %hash = ('first' => '1', 'second' => '2');


%hash = function(%hash);

function();

my @keys = keys %hash;

for my $value(@keys)
{
    say "$value is ", $hash{$value};
}    

sub function
{
    
 
    my $numArgs = @_;

    if ($numArgs == 0)
    {
        say "you didn't pass an argument!";
    } else {    

    say "numArgs = $numArgs";
    my %hash_ref = @_;
    
    $hash_ref{"new"} = 5;    
    return %hash_ref;
}
}    
