#!/usr/bin/perl
use strict;
use warnings;

use Time::Piece;
use Time::Seconds;

my $command = q(ssh -v -o "HostKeyAlgorithms=ecdsa-sha2-nistp256-cert-v01@openssh.com,ecdsa-sha2-nistp384-cert-v01@openssh.com,ecdsa-sha2-nistp521-cert-v01@openssh.com,ssh-ed25519-cert-v01@openssh.com,ssh-rsa-cert-v01@openssh.com" -o "NumberOfPasswordPrompts=0" -o "PreferredAuthentications=test" ssh-certificate-test@TESTSERVERNAME 2>&1 | grep "Server host certificate");
my $output = qx($command);

$output =~ /.*Server host certificate: .* valid from (?<fromdate>[^\s]+) to (?<todate>[^\s]+)/;

my $fromdate = $+{'fromdate'};
my $todate = $+{'todate'};

my $today = gmtime->datetime;
my $future = (gmtime) + 28*ONE_DAY;

my $status = 0;
my $status_str = "OK";
my $message = "SSH Certificate will expire at: $todate";

if ($future->datetime gt $todate) {
        $status = 2;
        $status_str = "WARNING";
}

print "$status_str: $message\n";
exit $status;
