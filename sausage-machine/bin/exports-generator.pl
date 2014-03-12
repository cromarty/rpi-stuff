#!/usr/bin/perl -w

use strict;

use File::Spec;
use Getopt::Long;

my $smversion = "0.1 beta";
my $version = "0.1 beta";
my %args;
my $export = "";
my $buildpath;
my $logfile = "sausage-machine.log";
my $work = 0;
my $line;
my @lines;

GetOptions(
	'build-path=s' => \&saveargs,
	'config-path=s' => \&saveargs,
	'utils-path=s' => \&saveargs,
	'log-file=s' => \&saveargs,
	'relative' => \&saveargs,
	'help' => \&saveargs,
	'export' => \&saveargs
) || die &usage;

if ( $args{'help'} ) {
	warn &usage;
	exit;
}

$export .= "export " if exists $args{'export'};

foreach ("build-path", "config-path", "utils-path") {
	next unless exists $args{$_};
	if ( ! -e $args{$_} ) {
		warn "Directory supplied for $_ must pre-exist, skipping $_\n";
		next;
	}
	$line = uc("$export"."SM_"."$_=");
	$line =~ s/-/_/g;
	if ( exists $args{'relative'} ) {
		$line .= $args{$_};
	} else {
		$line .= File::Spec->rel2abs($args{$_});
	}
	$work++;
	push @lines, "$line\n";
}

if ( ! exists $args{'build-path'} ) {
	warn "Skipping the definition of SM_LOG_FILE due to missing --build-path parameter\n";
} else {
	$logfile = $args{'log-file'} if exists $args{'log-file'};
	if ( exists $args{'relative'} ) {
		$logfile = join("/", ($args{'build-path'}, $logfile)); 
	} else {
		$logfile = join("/", (File::Spec->rel2abs($args{'build-path'}, $logfile)));
	}
	push @lines, "$export", "SM_LOG_FILE=", "$logfile\n\n";
}

&banner;
print @lines;


#--- subs


sub saveargs {
	my($arg, $value) = @_;
	$args{$arg} = $value;
}

sub usage {
	my $msg = <<eof;

Usage:
	$0 [ --help ] \
		| [ --export ] \
		[ --build-path=PATH ] \
		[ --config-path=PATH ] \
		[ --utils-path=PATH]

	Write a line for each of the three string arguments (not including --help and --export) to stdout

	If --export is included, the line for each argument is prefixed with 'export '

	If --help is included this usage text is displayed and no output is produced.


eof

	return $msg;
}


sub banner {
	my $datestring = localtime();
print <<eof;

#
# Generated on: $datestring
#
# by exports-generator.pl version $version
#
# Part of sausage-machine version $smversion
#
eof

}

