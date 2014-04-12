#!/usr/bin/perl -w
#
# Extract all the condition strings from a lexer and write them to stdout within a '%x line'
#

my $record;
my %x;

while(<>) {
	$record = $_;
	while($record =~ s/<([A-Z_]+)>// ) {
		$x{$1}++;
	}
}

$record = "\%x ".join(" ", keys %x);
print "$record\n\n";

