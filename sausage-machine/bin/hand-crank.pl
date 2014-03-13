#!/usr/bin/perl -w

use strict;
use IO::File;
use File::Spec;
use Getopt::Long;

my $config = "";
my $logfile = "sausages.log";
my $help = "";
my $configfilehandle = new IO::File;
my $logfilehandle = new IO::File;
#my $code;
#my $script;
my $args;

GetOptions(
	'config=s' => \$config,
	'log=s' => \$logfile,
	'help' => \$help
) || &usage;

&usage if $help;

$configfilehandle->open("< $config") || die "Failed to open file $config: $!\n";

if ( ( $ENV{SM_BUILD_PATH} ) && ( -d $ENV{SM_BUILD_PATH} ) ) {
	$logfile = join("/", (File::Spec->rel2abs($ENV{SM_BUILD_PATH}), $logfile));
}

$logfilehandle->open("> $logfile") || die "Failed to open file $logfile: $!\n";

while (<$configfilehandle>) {
	chomp;                  # no newline
	s/#.*//;                # no comments
	s/^\s+//;               # no leading white
	s/\s+$//;               # no trailing white
	next unless length;     # anything left?
	($script, $args) = split("??");
	$logfilehandle->print("Run $_\n");
	#system("$_");
	#die "\n" if $?;
}

undef $configfilehandle;

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




