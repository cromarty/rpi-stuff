#!/usr/bin/perl -w


use strict;

my $key;
my $value;
my %scripts;

# Read script switches from __DATA__
while (<DATA>) {
	chomp;                  # no newline
	s/#.*//;                # no comments
	s/^\s+//;               # no leading white
	s/\s+$//;               # no trailing white
	next unless length;     # anything left?
	($key, $value) = split(/\s*=\s*/, $_, 2);
	$scripts{$key} = $value;
} # end while 

opendir D, '.' or die "Could not open current dir: $!\n";
my @filelist = sort grep(/[1-9][0-9]{2}-[A-Za-z-]*?\.sh/i, readdir D);
closedir D;

foreach (@filelist) {
	if ( $scripts{$_} ) {
		system("./$_");
		die "\n" if $?;
	}
}

__DATA__
#
# Any script below 400 should be regarded as mandatory.
# Scripts from 400 onwards can be switched off by replacing the 1 with a zero.
#
100-prep.sh = 1
110-libs.sh = 1
120-get-sources.sh = 1
130-patch-espeak.sh = 1
140-build-espeak.sh = 1
150-build-speech-dispatcher.sh = 1
160-build-speechd-up.sh = 1
170-configs.sh = 1
180-dummy-espeak.sh = 1
190-dummy-speech-dispatcher.sh = 1
200-dummy-speechd-up.sh = 1
210-fix-alsa-conf.sh = 1
220-speakup-modules.sh = 1
230-enable-and-start-speechd-up.sh = 1
240-enable-speech-dispatcher.sh = 1
400-install-python-speechd.sh = 0
410-install-sound-icons.sh = 1
500-install-gnome-orca.sh = 1
