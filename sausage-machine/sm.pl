#!/usr/bin/perl -w

use strict;
use warnings;

use IO::File;
use Term::Menu;

my $cfh = IO::File->new;
my $key;
my $val;
my %cfg;

&load_config(\%cfg);

if ( ! &validate_config(\%cfg) ) {
	print "Config file contents failed validation\n";
	exit 1;
}

&set_env(\%cfg);


#exit 0;

&main_menu(\%cfg);


sub main_menu {
	my ($cfg) = @_;
	my $mainmenu = new Term::Menu(
		tries => 3,
		beforetext => 'Welcome to the Sausage machine, choose an option:',
		aftertext => '? ',
		nooptiontext => 'Invalid selection',
		toomanytries => 'Retry count exceeded, Sausage machine will exit.'
		);

	my $answer = undef;
	$answer = $mainmenu->menu(
		raspbian    => ["Raspbian configurations", '1'],
		arch    => ["Arch configurations", '2'],
		minibian    => ["Minibian (minimalist Raspbian) configurations", '3'],
		exit    => ["Exit", 'x'],
	);
	if ( defined $answer ) {
		&{{ 'raspbian' => \&raspbian_menu($cfg, $answer), 'arch' => \&arch_menu($cfg, $answer), 'minibian' => \&minibian_menu($cfg, $answer), 'exit' => sub { print "Bye bye\n"; exit } }->{$answer}};
	} else {
		#print "Answer was undefined\n";
	}
} # main_menu

sub raspbian_menu {
	my ($cfg, $option) = @_;
	my $menu = new Term::Menu( tries => 3);
	my $answer = undef;
	$answer = $menu->menu(
		'lxde-sd-libao'    => ["Raspbian/LXDE/speech-dispatcher using libao", '1'],
		'exit'    => ["Exit (back to main menu)", 'x'],
	);
	if ( defined $answer ) {
		&{{ 'lxde-sd-libao' =>\&raspbian_lxde_sd_libao($cfg, "$option/$answer"), 'exit' => sub{} }->{$answer}};
	} else {
		print "Answer was undefined\n";
	}
} # raspbian_menu

sub arch_menu {
	my ($cfg, $option) = @_;
	print "Arch was called\n";
	exit 0;
} # arch_menu

sub minibian_menu {
	my ($cfg, $option) = @_;
	print "Minibian was called\n";
	exit 0;
} # minibian_menu

#---- actual work

sub raspbian_lxde_sd_libao {
	my ($cfg, $option) = @_;
	my @scripts;
	$ENV{CONFIG_PATH} = join("/", ($cfg->{'sausage-pack-root'},$option, 'config'));;
	$ENV{SCRIPT_PATH} = join("/", ($cfg->{'sausage-pack-root'}, $option, 'scripts'));;
	$ENV{UTILS_PATH} = join("/", ($cfg->{'sausage-pack-root'}, $option, 'utils'));;
	@scripts = <$ENV{SCRIPT_PATH}/*.sh>;
	foreach (@scripts) {
		print "Script: $_\n";
	}
	print "Ran $option\n";
	print "CONFIG_PATH: $ENV{CONFIG_PATH}\n";
	print "SCRIPT_PATH: $ENV{SCRIPT_PATH}\n";
	print "UTILS_PATH: $ENV{UTILS_PATH}\n";
	exit 0;
}

sub load_config {
	my ($cfg) = @_;
	$cfh->open("< sm.conf");
	while (<$cfh>) {
		chomp;                  # no newline
		s/#.*//;                # no comments
		s/^\s+//;               # no leading white
		s/\s+$//;               # no trailing white
		next unless length;     # anything left?
		($key, $val) = split(/\s*=\s*/, $_, 2);
		$cfg->{$key} = $val;
	} # end while 
	$cfh->close;
	return;
}

sub validate_config {
	my ($cfg) = @_;
	if ( ! $cfg->{'build-path'} ) {
		print "Build-path not set in the config file, setting to default of~/.builds\n";
		$cfg->{'build-path'} = '~/.builds';
	}

	if ( ! $cfg->{'sausage-pack-root'} ) {
		print "ERROR: Did not find a 'sausage-pack-root' key in the config file\n";
		return 0;
	}

	if ( ! -d $cfg{'sausage-pack-root'} ) {
		print "ERROR: The directory path found in the 'sausage-pack-root' key in the config file does not exist\n";
		return 0;
	}

	return 1;
}

sub set_env {
	my ($cfg) = 	@_;
	$ENV{'BUILD_PATH'} = $cfg->{'build-path'};
	$ENV{'SAUSAGE_PACK_ROOT'} = $cfg->{'sausage-pack-root'};
	return;
}




