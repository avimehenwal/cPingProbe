#!/usr/bin/perl -w 
use strict;
use Net::Ping;
use Time::HiRes;
use IO::Handle;
use threads;
use threads::shared;

#       AUTHOR  :       Avi Mehenwal
#       PURPOSE :       Continuous ping check with PERL iThreads (interpreted threads)
#       DATE    :       10th-Jan-2013

sub Ping {

#Filer handle generation and open log file for writing in append mode.
#creating ping object to check ping response
#Writing Ping results in logs and command window for Real time analysis
#Close file after logs are witten

    my ($host , $protocol) = @_;
    chop $host;
    open my $log, '>>', "Ping_$host.txt" or die "Cannot create log file: $!";
    $log->autoflush;                                                          #autoflusing to stop output stream buffering.      
    my $p = Net::Ping->new($protocol) or die "Cannot create new Net::Ping object : $!";
    $p->hires;
    my ($ret, $duration, $ip) = $p->ping($host);
    if ($ret=='1')
     {    my $event = sprintf "%s\t%s is alive $protocol (packet RTT: %.3fms)\n",
                             scalar localtime, $host, $duration;
          print STDOUT $event;
          print $log $event;
          sleep(1);  #sleep only when ping is continuous    
      }
    else
     {    my $event = sprintf "%s\t%s is UNAVAILABLE (Timedout/lost $protocol request)\n",
                                            scalar localtime, $host;
          print STDOUT $event;
          print $log $event;               
     }
    close $log; 
}

my @hostip = qw(10.98.10.253, 10.112.114.10, 10.112.114.11);
STDOUT->autoflush;
print "****************************************************************************\n\ncPING-CHECK -v2.0 By-Avi Mehenwal\n\n";
print "Kindly enter the protocol to be used by cPing-Probe : tcp / udp / icmp ...\n";
my $protocol = <STDIN>;
chomp $protocol;
if($protocol eq "icmp") {
 print "\nWARNING:For cPing-Probe to use icmp protocol kindly run the program in administrative command prompt\ncPing-Probe v2.0will now exit ...";
 sleep(10);
 exit;
}      

while(1)      {
 foreach my $thost (@hostip) {
   Ping($thost,$protocol);
 }     
}     

#END 
