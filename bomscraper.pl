#!/usr/bin/env perl

# Name : Scott Kratochvil
# Class : CSCI 2850
# Program # : 9
# Due Date : 10/7/18

# Colleagues: None
# This is a handy program to scrape a summary of box office results, process it, and email the results to a specified address.

use Modern::Perl;
use Mail::Sendmail;

my $numParams = @ARGV;
if ($numParams != 1)
{
    say "Usage: bomscraper email";
    exit;
}    

my $pageToGrab = "http://boxofficemojo.com/weekend/chart/";
my $command = "/usr/bin/lynx -dump -width=400 $pageToGrab";

my $allData = `$command`;

my @matches = $allData =~ /(\d+)\s+(\d+|N|-)\s*\[\d+\](.*)\[\d+\]\w+\.?\s?\d?(?:\(\w+\))?(?:\w*)\s?\s+(\$\S*)\s+\S+\s+\S+\s+(?:\S+\s+\S+\s+)?(\$\S+)/g;
my $numEntries = @matches / 5;

my $bigDebut = "No Debuts";
my $bigDebutValue = 0;

my $weakDebut = "No Debuts";
my $weakDebutValue = 1000000000;

my $bigGain = $matches[2];
my $bigGainValue = 0;

my $bigLoss = $matches[2];
my $bigLossValue = 0;

my $email = "Data scraped from $pageToGrab\n\n";
$email = $email . "TW   LW   Movie Title                         Weekend Gross   Total Gross\n\n"; 

#for each movie
for (my $matchCounter = 0; $matchCounter < $numEntries; $matchCounter++)
{
    my $isDebut = 0;
    #for each field
    for (my $counter = 0; $counter < 5; $counter++)
    {
        #format fields and check mins and maxes
        #this week position
        if ($counter == 0)
        {
            $matches[$counter + $matchCounter * 5] = sprintf("%-4s", $matches[$counter + $matchCounter * 5]);       
        } 

        #last week position
        if ($counter == 1)
        {
            if ($matches[$counter + $matchCounter * 5] eq "N")
            {
                $isDebut = 1;
            }    
            elsif ($matches[$counter + $matchCounter * 5] ne "-")
            {
                my $posDelta = ($matches[$counter + $matchCounter * 5] - $matches[$counter - 1 + $matchCounter * 5]); 
                #check for biggest gain
                if ($posDelta > $bigGainValue)
                {
                    $bigGainValue = $posDelta;
                    $bigGain = $matches[$counter + 1 + $matchCounter * 5];
                    $bigGain =~ s/\s+$//g;
                    $bigGain = $bigGain . " (" . $posDelta . " places)"; 
                }    
                #check for biggest lost
                if ($posDelta < $bigLossValue)
                {
                    $bigLossValue = $posDelta;
                    $bigLoss = $matches[$counter + 1 + $matchCounter * 5];
                    $bigLoss =~ s/\s+$//g;
                    $posDelta =~ s/-//;
                    $bigLoss = $bigLoss . " (" . $posDelta . " places)"; 
                } 
            }    

            $matches[$counter + $matchCounter * 5] = sprintf("%-4s", $matches[$counter + $matchCounter * 5]);       
        }    

        #Movie Title
        if ($counter == 2)
        {
            $matches[$counter + $matchCounter * 5] = substr $matches[$counter + $matchCounter * 5], 0, 35; 
            $matches[$counter + $matchCounter * 5] = sprintf("%35s", $matches[$counter + $matchCounter * 5]);       
        }    

        #Weekend Gross
        if ($counter == 3)
        {
            $matches[$counter + $matchCounter * 5] = sprintf("%-15s", $matches[$counter + $matchCounter * 5]);       
        }    

        #Total Gross
        if ($counter == 4)
        {
            if ($isDebut)
            {
                #convert string to int
                my $temp = $matches[$counter + $matchCounter * 5];
                $matches[$counter + $matchCounter * 5] =~ s/,|\$//g;
                
                #check for biggest debut
                if ($matches[$counter + $matchCounter * 5] > $bigDebutValue)
                {
                    $bigDebutValue = $matches[$counter + $matchCounter * 5];
                    $bigDebut = $matches[$counter + $matchCounter * 5 - 2];
                    $bigDebut =~ s/\s+$//g;
                    $bigDebut = $bigDebut . " (" . $matches[$counter - 4 + $matchCounter * 5]; 
                    $bigDebut =~ s/\s+$//;
                    $bigDebut = $bigDebut . ")";
                } 

                #check for weakest debut
                if ($matches[$counter + $matchCounter * 5] < $weakDebutValue)
                {
                    $weakDebutValue = $matches[$counter + $matchCounter * 5];
                    $weakDebut = $matches[$counter + $matchCounter * 5 - 2];

                    $weakDebut =~ s/\s+$//g;
                    $weakDebut = $weakDebut . " (" . $matches[$counter - 4 + $matchCounter * 5]; 
                    $weakDebut =~ s/\s+$//;
                    $weakDebut = $weakDebut . ")";

                }
                #restore original value
                $matches[$counter + $matchCounter * 5] = $temp;
            }    
        }    

        #append fields to email
        $email = $email . $matches[$counter + $matchCounter * 5];
        $email = $email . " ";
    }
        $email = $email . "\n";
} 
$email = $email . "\n\nBiggest Debut: $bigDebut\n";
$email = $email . "Weakest Debut: $weakDebut\n";
$email = $email . "Biggest Gain: $bigGain\n";
$email = $email . "Biggest Loss: $bigLoss\n";

my $mailTo = $ARGV[0];
my $mailFrom = 'sckratochvil@unomaha.edu';
my $subjectLine = "Weekend Box Office Report";
my $message = "<pre>$email</pre>";

my %mail = (To      => $mailTo,
            From    => $mailFrom,
            Subject => $subjectLine,
            Message => $message,
            'Content-Type' => 'text/html; charset="utf=8"'
        ); 

if (sendmail %mail) 
{
    say "Succesfully sent email to $mailTo";
}
else
{
    say "Error sending email.";
}    

