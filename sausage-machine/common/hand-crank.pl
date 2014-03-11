#!/usr/bin/perl -w

use strict;
use IO::File;
use File::Spec;
use Getopt::Long;

my $config = "";
my $logfile = "sausages.log";
my $help = "";
my $cfh = new IO::File;
my $lfh = new IO::File;

my @steps;
my $step;
my $i;
my $flag;
my $code;
my $script;

GetOptions(
	'config=s' => \$config,
	'log=s' => \$logfile,
	'help' => \$help
) || &usage;

&usage if $help;

$cfh->open("< $config") || die "Failed to open file $config: $!\n";

if ( ( $ENV{SM_BUILD_PATH} ) && ( -d $ENV{SM_BUILD_PATH} ) ) {
	$logfile = join("/", (File::Spec->rel2abs($ENV{SM_BUILD_PATH}), $logfile));
}

$lfh->open("> $logfile") || die "Failed to open file $logfile: $!\n";

while (<$cfh>) {
	chomp;                  # no newline
	s/#.*//;                # no comments
	s/^\s+//;               # no leading white
	s/\s+$//;               # no trailing white
	next unless length;     # anything left?
	$lfh->print("Run $_\n");
	#system("$_");
	#die "\n" if $?;
}

$cfh->close;


#--- subs



sub usage {
	print <<eof;
Usage:
	$0 [ --help ] | --config=FILE

	Run each of the scripts contained in the builder configuration files passed in the --config parameter.

	If --help is included, print this usage text and exit.

eof

	exit 0;
}




