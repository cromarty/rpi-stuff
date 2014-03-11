#!/usr/bin/perl -w

use File::Spec;
use Getopt::Long;

my $path = "";
my $rx = "/.*/";
my $relative = "";

GetOptions(
	'path=s' => \&saveargs,
	'rx=s' => \$rx,
	'relative' => \$relative,
	'help' => \&saveargs
) || &usage;

&usage if exists $args{'help'};


chdir($args{'path'}) || die "Could not chdir to $args{'path'}: $!\n";

#my @filelist = sort grep(/[1-8][0-9]{2}-[A-Za-z-]*?\.sh/i, readdir D);

my $datestring = localtime();

print <<eof;
#
# sausage-machine sausage-pack configuration file written by
# config-generator version1.0 from sausage-machine version 0.1 beta
#
# --Path=$path
# --rx=$rx
#
# Generated on: $datestring
#
eof

opendir D, '.' || die "Could not open current dir: $!\n";
foreach (sort readdir D) {
#foreach (@filelist) {
	next if $_ eq '.';
	next if $_ eq '..';
    my $code = eval "sub{ \$_[0] =~ $rx }" // die $@;
	if( $code->( $_ ) ) {
		if ( $relative ) {
			print "$_\n";
		} else {
			print File::Spec->rel2abs($_), "\n";
		}
	}
} # foreach

closedir D;



#--- subs


sub saveargs {
	my($arg, $value) = @_;
	$args{$arg} = $value;
}

sub usage {
	print <<eof;
Usage:
	$0 [ --help ] | --path=PATH

	prints to stdout the absolute paths and file names of all files
	found in the path specified by --path=PATH

eof

	exit 0;
}




