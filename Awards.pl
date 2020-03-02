#!/usr/bin/env perl

# Name : Scott Kratochvil
# Class : CSCI 2850
# Program # : 6
# Due Date : 9/16/18
# Colleagues: None
# This is a program to record one's votes for the Emmies.

# I researched online how to find the size of an element in a 2d array at:
# https://stackoverflow.com/questions/16793937/size-of-2d-array-in-perl

use Modern::Perl;

my @first = 
('Outstanding Lead Actor in a Comedy Series',
'Donald Glover, "Atlanta"',
'Bill Hader, "Barry"',
'Anthony Anderson, "black-ish"',
'Larry David, "Curb Your Enthusiasm"',
'William H. Macy, "Shameless"',
'Ted Danson, "The Good Place"');

my @second = 
('Outstanding Lead Actress in a Comedy Series',
'Pamela Adlon, "Better Things"',
'Tracee Ellis Ross, "black-ish"',
'Lily Tomlin, "Grace and Frankie"',
'Issa Rae, "Insecure"',
'Allison Janney, "Mom"',
'Rachel Brosnahan, "The Marvelous Mrs. Maisel"');

my @third = 
('Outstanding Children\'s Program',
'"A Series of Unfortunate Events"',
'"Alexa & Katie"',
'"Fuller House"',
'"Star Wars Rebels"',
'"The Magical Wand Chase: A Sesame Street Special"');

my @fourth = 
('Outstanding Cinematography for a Limited Series or Movie',
'"Fahrenheit 451"',
'"Genius: Picasso": "Chapter One"',
'"Godless": "An Incident at Creede"',
'"The Alienist": "The Boy On The Bridge"',
'"Twin Peaks": "Part 8"',
'"USS Callister (Black Mirror)"');

my @fifth =
('Outstanding Comedy Series',
'"Atlanta"',
'"Barry"',
'"black-rsh"',
'"Curb Your Enthusiasm"',
'"GLOW"',
'"Silicon Valley"',
'"The Marvelous Mrs. Maisel"',
'"Unbreakable Kimmy Schmidt"');

my @sixth = 
('Outstanding Drama Series',
'"Game of Thrones"',
'"Stranger Things"',
'"The Americans"',
'"The Crown"',
'"The Handmaid\'s Tale"',
'"This Is Us"',
'"Westworld"');

my @seventh = 
('Outstanding Supporting Actress in a Comedy Series',
'Zazie Beetz as Van, "Atlanta"',
'Betty Gilpin as Debbie Eagan, "GLOW"',
'Laurie Metcalf as Jackie Harris, "Roseanne"',
'Aidy Bryant as Various Characters, "Saturday Night Live"',
'Leslie Jones as Various Characters, "Saturday Night Live"',
'Kate McKinnon as Various Characters, "Saturday Night Live"',
'Alex Borstein as Susie, "The Marvelous Mrs. Maisel',
'Megan Mullally as Karen Walker, "Will & Grace"');

my @all = (\@first, \@second, \@third, \@fourth, \@fifth, \@sixth, \@seventh);
my $numCategories = @all;
my $category = 0;
my @choices;
my @isWriteIn;

say "Welcome to the 70th Emmy Awards!\n";
say "=====" x 22, "\n";

#Iterate through each category
for (; $category < $numCategories; $category++)
{
    my $isWriteIn = 0;
    my $length = @{$all[$category]};
    say "The nominees for $all[$category][0] are:\n";

    #Iterate through each nominee
    for (my $nominee = 1; $nominee < $length; $nominee++)
    {
        print "\t[", $nominee, "] ";
        print $all[$category][$nominee];
        say " ";
    }
    say "\t[", $length, "] Write In\n";
    
    #Get vote
    my $validEntry = 0;
    while (!$validEntry)
    {
        print "Please enter your choice for $all[$category][0] now: ";
        chomp (my $choice = <>);
        $choices[$category] = $choice;
        if ($choice < 1 || $choice > $length)
        {
            say "I'm sorry, but $choice is not a valid option.\n";
        }
        else
        {
            $validEntry = 1;
        }    
        
        if ($choice == $length)
        {
            $isWriteIn = 1;
            print "Please enter your write-in candidate: ";
            chomp (my $writeIn = <>);
            $choices[$category] = $writeIn;
        } 
    }    

    if (!$isWriteIn)
    {
        say ("Thank you for selecting $all[$category][$choices[$category]] as $all[$category][0].\n");
        $isWriteIn[$category] = 0;
    }
    else
    {
        say ("Thank you for selecting $choices[$category] as $all[$category][0].\n");
        $isWriteIn[$category] = 1;
    }    
    say "=====" x 22, "\n";
}

say "Those were some interesting choices!  Here is a summary of your votes.\n";

for (my $a = 0; $a < $numCategories; $a++)
{
    say "$all[$a][0]: ";

    if ($isWriteIn[$a])
    {
        say "\t", $choices[$a], "\n";
    }
    else
    {
         say "\t", $all[$a][$choices[$a]], "\n";
    }    
}    
