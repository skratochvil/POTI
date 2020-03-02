#!/usr/bin/env perl

use Modern::Perl;
use Data::Dumper;
use Net::hostent;




my $numFiles = @ARGV;

if ($numFiles < 1)
{
    say "Improper usage"; #finsih
    exit;
}   

open(FOUT, '>', "sckratochvil.summary");

my @filesIn;
#read in each file
for (my $a = 0; $a < $numFiles; $a++)
{
    open (IN,$ARGV[$a]); 
    my @fileIn = <IN>; 
    close IN;
    $filesIn[$a] = \@fileIn;
}    

my $totalProcessed = 0;
for (my $a = 0; $a < $numFiles; $a++)
{
    $totalProcessed += @{$filesIn[$a]};
}    
say "Processed $totalProcessed files in $numFiles files.";

### process the hostnames ###
my @ipArray;
for (my $a = 0; $a < $numFiles; $a++)
{
    my $length = @{$filesIn[$a]};

    for (my $b = 0; $b < $length; $b++)
    {
        $filesIn[$a][$b] =~ /^(\d+.\d+.\d+.\d+)/;
        push(@ipArray, $1);
    }    
}

my @hostNames;
my %hostHash;
my $lookupFails;
my %accessDomains;


=pod
for my $host (@ipArray)
{
    my $name = $host;
    if (my $h = gethost($host))
    {
        $name   = $h->name();
        $name =~ /([^.]+.[^.]+)$/;
        $accessDomains{$1}++;
    }    
    else
    {
        $lookupFails++;
    }    
    push(@hostNames, $name);
    $hostHash{$name} ++;
}
$accessDomains{"DOTTED QUAD OR OTHER"} = $lookupFails;
=cut

my @hostsOut = sort {$a cmp $b} keys %hostHash;
for my $host (@hostsOut) 
{
#   say "$host occured $hostHash{$host} times";
}

######

#print the domains
my @aDomainsOut = sort {$a cmp $b} keys %accessDomains;
for my $domain (@aDomainsOut) 
{
#  say "$domain occured $accessDomains{$domain} times";
}

### process the dates ###
my %dateHash;
for (my $a = 0; $a < $numFiles; $a++)
{
    my $length = @{$filesIn[$a]};

    for (my $b = 0; $b < $length; $b++)
    {
        $filesIn[$a][$b] =~ /\[(\d\d\/\w\w\w\/\d\d\d\d)/;
        $dateHash{$1} ++;
    }    
}








my @datesOut = sort {$a cmp $b} keys %dateHash;
for my $date (@datesOut) 
{
#    say "$date occured $dateHash{$date} times";
}    

###process the hours ###
my %hourHash;
for (my $a = 0; $a < $numFiles; $a++)
{
    my $length = @{$filesIn[$a]};
    for (my $b = 0; $b < $length; $b++)
    {
        $filesIn[$a][$b] =~ /\d\d\d\d:(\d\d):/;   
        $hourHash{$1} ++;
    }    
}




my @hoursOut = sort {$a cmp $b} keys %hourHash;
for my $hour (@hoursOut) 
{
#    say "$hour occured $hourHash{$hour} times";
} 

### proccess the status codes ###

my %statusHash;
for (my $a = 0; $a < $numFiles; $a++)
{
    my $length = @{$filesIn[$a]};
    for (my $b = 0; $b < $length; $b++)
    {
        $filesIn[$a][$b] =~ /" (\d\d\d) \d/;
        $statusHash{$1} ++;
    }    
}

my @statusOut = sort {$a cmp $b} keys %statusHash;
for my $status (@statusOut) 
{
#   say "$status occured $statusHash{$status} times";
} 


my $count = 0;

### process the URLs ###
my %urlHash;
for (my $a = 0; $a < $numFiles; $a++)
{
    my $length = @{$filesIn[$a]};
    for (my $b = 0; $b < $length; $b++)
    {
        
        $filesIn[$a][$b] =~ /"\w+ (\/.+?)(?= )/;   
        if ($1 =~ / HTTP\//) {$urlHash{"/"}++;}
        else {$urlHash{$1} ++};
    }    
}

my @urlsOut = sort {$a cmp $b} keys %urlHash;
for my $url (@urlsOut) 
{
    #say "$url occured $urlHash{$url} times";
} 

### process the filetypes ###
my %typeHash;
for (my $a = 0; $a < $numFiles; $a++)
{
    my $length = @{$filesIn[$a]};
    for (my $b = 0; $b < $length; $b++)
    {
        if ($filesIn[$a][$b] =~ /\.cgi/) {$typeHash{"CGI Program (cgi)"}++;}
        elsif ($filesIn[$a][$b] =~ /\.css/) {$typeHash{"Style Sheet (css)"}++;}
        elsif ($filesIn[$a][$b] =~ /\.htm / | $filesIn[$a][$b] =~ /\.html /) {$typeHash{"Web Pages (htm, html)"}++;}

        elsif ($filesIn[$a][$b] =~ /\.gif/ | $filesIn[$a][$b] =~ /\.jpg/ | $filesIn[$a][$b] =~ /\.jpeg/
            | $filesIn[$a][$b] =~ /\.png/ | $filesIn[$a][$b] =~ /\.ico/) {$typeHash{"Image (jpg, jpeg, gif, ico png)"}++;}
        else {$typeHash{"Other"}++;}    
    }  
}    

my @typesOut = sort {$a cmp $b} keys %typeHash;
for my $type (@typesOut) 
{
    #say "$type occured $typeHash{$type} times";
} 


### process agents/browsers ###
my %agentHash;
for (my $a = 0; $a < $numFiles; $a++)
{
    my $length = @{$filesIn[$a]};
    for (my $b = 0; $b < $length; $b++)
    {
        $filesIn[$a][$b] =~ /"([^"]+)"$/;
        $agentHash{$1} ++;
    }    
}

my @agentsOut = sort {$a cmp $b} keys %agentHash;
for my $agent (@agentsOut) 
{
#    say "$agent occured $agentHash{$agent} times";
}

my %familyHash;
for (my $a = 0; $a < $numFiles; $a++)
{
    my $length = @{$filesIn[$a]};
    for (my $b = 0; $b < $length; $b++)
    {

        $filesIn[$a][$b] =~ /"([^"]+)"$/;
        if ($1 =~ /(Chrome)/) {$familyHash{$1} ++;}
        elsif ($1 =~ /(Firefox)/) {$familyHash{$1} ++;}
        elsif ($1 =~ /(MSIE)/) {$familyHash{$1} ++;}
        elsif ($1 =~ /Safari/) {$familyHash{"Safari"} ++;}  
        elsif ($1 =~ /Opera/) {$familyHash{"Opera"} ++;}  
        else {$familyHash{"Unknown"} ++;}
    }    
}

my @familiesOut = sort {$a cmp $b} keys %familyHash;
for my $family (@familiesOut) 
{
#   say "$family occured $familyHash{$family} times";
}



### process referers ###
my %refererHash;
for (my $a = 0; $a < $numFiles; $a++)
{
    my $length = @{$filesIn[$a]};
    for (my $b = 0; $b < $length; $b++)
    {
        $filesIn[$a][$b] =~ /"([^"]+)" "[^"]+"$/;
        $refererHash{$1} ++;
    }    
}

my @referersOut = sort {$a cmp $b} keys %refererHash;
for my $referer (@referersOut) 
{
#    say "$referer occured $refererHash{$referer} times";
}

### process referer domain ###
my %domainHash;
for (my $a = 0; $a < $numFiles; $a++)
{
    my $length = @{$filesIn[$a]};
    for (my $b = 0; $b < $length; $b++)
    {
        $filesIn[$a][$b] =~ /"([^"]+)" "[^"]+"$/;
        
        
        
        
        if ($1 =~ /https?:\/\/([^\/]+)/)
        {
            $1 =~ /([^.]+.[^.]+)$/;
            $domainHash{$1} ++;
        }    
        else
        {
            $domainHash{"NONE"} ++;
        }        
    }    
}

my @domainssOut = sort {$a cmp $b} keys %domainHash;
for my $domain (@domainssOut) 
{
#    say "$domain occured $domainHash{$domain} times";
}



my %osHash;
for (my $a = 0; $a < $numFiles; $a++)
{
    my $length = @{$filesIn[$a]};
    for (my $b = 0; $b < $length; $b++)
    {
        if ($filesIn[$a][$b] =~ / "([^"]+)"$/)
        {
            if ($1)
            {
                if ($1 =~ /Windows/) {$osHash{"Windows"} ++;}
                elsif($1 =~ /Mac/) {$osHash{"Macintosh"} ++;}
                elsif ($1 =~ /Linux|linux/) {$osHash{"Linux"} ++;}
                else {$osHash{"Other"} ++;}
            }    
        }    

    }    
}

my @osOut = sort {$a cmp $b} keys %osHash;
for my $os (@osOut) 
{
#    say "$os occured $osHash{$os} times";
}


### calculate total bytes ###
my $totalBytes = 0;
for (my $a = 0; $a < $numFiles; $a++)
{
    my $length = @{$filesIn[$a]};
    for (my $b = 0; $b < $length; $b++)
    {
        $filesIn[$a][$b] =~ /(\d+) "[^"]+" "[^"]+"$/;
        $totalBytes += ($1);
    }    
}
#say "Total bytes: $totalBytes";





#printReport(\%hostHash, "HOSTNAMES");
#printReport(\%accessDomains, "DOMAINS");
#printReport(\%dateHash, "DATES");
#printReport(\%hourHash,"HOURS");
#printReport(\%statusHash, "STATUS CODES");
#printReport(\%urlHash, "URLs");
#printReport(\%typeHash, "FILE TYPES");
#printReport(\%agentHash, "BROWSERS");
printReport(\%familyHash, "BROWSER FAMILIES"); 
#printReport(\%refererHash, "REFERRERS"); 
printReport(\%domainHash, "REFERRERS' DOMAINS"); 





sub printReport
{
    my ($hashref, $reportType) = @_;
    my $report = "=====" x 16 . "\n";
    $report = $report . "\t$reportType\n";
    $report = $report . "=====" x 16;
    $report = $report . "\n\n\tHits\t%-age\tResource\n";
    $report = $report . "\t----\t-----\t--------\n";
 
    my @records = sort {$a cmp $b} keys %$hashref;
    for my $record (@records) 
    { 
        my $percent = $$hashref{$record} / $totalProcessed * 100;
        
        $report = $report . "\t$$hashref{$record}\t";
        $report = $report . sprintf("%.2f", $percent);

        $report = $report . "\t$record\n";
        


    } 
    $report = $report . "\t-----\n";
        $report = $report . "\t$totalProcessed entries displayed\n";


    say $report;     
}    

