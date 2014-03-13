#!/usr/bin/perl -w

use strict;
use IO::File;
use File::Spec;
use Getopt::Long;

my $path = "";
my $rx = "/.*/";
my $relative = "";
my $help = "";
my @scripts;
my %scripts;
my $off_list;
my @warnings;


my $off = 0;
my $on = 1;
my $ignore = 2;




GetOptions(
	'path=s' => \$path,
	'rx=s' => \$rx,
	'relative' => \$relative,
	'help' => \$help
) || &usage;

&usage if $help;

die "Supplied path does not exist\n" unless -d $path;
chdir($path) || die "Failed to chdir to $path: $!\n";

scriptlist($path, $relative, $rx, \@scripts, \%scripts);
restrictlist($path, \%scripts, "default.off.list", 0, \@warnings);
restrictlist($path, \%scripts, "ignore.list", 2, \@warnings);

if ( $#scripts > -1 ) {
	printlist($path, $relative, \@scripts, \%scripts, $rx, \@warnings);
} else {
	warn "No scripts found or none matched the supplied regular-expression\n";
}

#--- subs



sub usage {
	print <<eof;
Usage:
	config-generator.pl [ --help ] | --path=PATH

	prints to stdout the absolute paths and file names of all files
	found in the path specified by --path=PATH

eof

	exit 0;
}

sub banner {
	my ($path, $regex, $warnings_aref) = @_;
	my $datestring = localtime();
	my $warnings = 0;
print <<eof;
#
# sausage-machine sausage-pack configuration file written by
# config-generator version1.0 from sausage-machine version 0.1 beta
#
# --Path=$path
# --rx=$regex
#
# Generated on: $datestring
#
eof

	foreach (@{$warnings_aref}) {
		$warnings++;
		print "# $_\n";
	}
	print "#\n" if $warnings;

} # banner


sub scriptlist {
	my ($path, $relative, $rx, $scripts_aref, $scripts_href) = @_;
	opendir D, '.' || die "Could not open current dir: $!\n";
	foreach (sort readdir D) {
		next if $_ eq '.';
		next if $_ eq '..';
		next if $_ =~ /\.list$/;
		my $code = eval "sub{ \$_[0] =~ $rx }" // die $@;
		if( $code->( $_ ) ) {
			push @{$scripts_aref}, "$_";
			$scripts_href->{$_} = 1;
		}
	} # foreach
	closedir D;
} # scriptlist

sub restrictlist {
	my ($path, $script_href, $restrictfile, $switch, $warnings_aref) = @_;
	#if ( -f "$path/$restrictfile" ) {
	if ( -f "$restrictfile" ) {
		$off_list = new IO::File;
		$off_list->open("< $restrictfile") || die "Failed to open the $restrictfile file to set restrictions: $!\n";
		while (<$off_list>) {
			chomp;                  # no newline
			s/#.*//;                # no comments
			s/^\s+//;               # no leading white
			s/\s+$//;               # no trailing white
			next unless length;     # anything left?
			if ( exists $script_href->{$_} ) {
				$script_href->{$_} = $switch;
			}
		}
		undef $off_list;
	} else {
		push @{$warnings_aref}, "Warning: no $restrictfile found, continuing without";
	}
} # restrictlist

sub printlist {
	my ($path, $relative, $script_aref, $script_href, $rx, $warnings_aref) = @_;
	my $absolute;
	&banner($path, $rx, $warnings_aref);
	foreach (@{$script_aref}) {
		if ( $relative ) {
			$absolute = $_;
		} else {
			$absolute = File::Spec->rel2abs($_);
		}
		if ( $script_href->{$_} == 1) {
			print "$_\n";
		} elsif ( $script_href->{$_} == 0) {
			print "# Switched off by inclusion in default.off.list:\n#$_\n";
		} # $ignore
	}
} # printlist






