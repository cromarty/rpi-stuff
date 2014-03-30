#!/usr/bin/perl -w

use strict;
use warnings;

use IO::File;
use Term::Menu;

my $cfh = IO::File->new;
my $key;
my $val;
my %cfg;
my $true = 1;

&load_config(\%cfg);

if ( ! &validate_config(\%cfg) ) {
	print "Config file contents failed validation\n";
	exit 1;
}

&set_env(\%cfg);

while($true) {
	$true = &main_menu(\%cfg);
}

sub main_menu {
	my ($cfg) = @_;
	my $answer = undef;
	my $mainmenu = new Term::Menu(
		tries => $cfg->{'tries'},
		beforetext => "$cfg->{'main-beforetext'}",
		aftertext => "$cfg->{'aftertext'}",
		nooptiontext => "$cfg->{'nooptiontext'}",
		toomanytries => "$cfg->{'toomanytries'}"
		);

	$answer = $mainmenu->menu(
		raspbian    => ["Raspbian configurations", '1'],
		arch    => ["Arch configurations", '2'],
		minibian    => ["Minibian (minimalist Raspbian) configurations", '3'],
		exit    => ["Exit", 'x'],
	);
	if ( defined $answer ) {
		&{{
			'raspbian' => sub { return &raspbian_menu($cfg, $answer) },
			'arch' => sub { return &arch_menu($cfg, $answer) },
			'minibian' => sub { return &minibian_menu($cfg, $answer) },
			'exit' => sub { print "Bye bye\n"; return 0 }
		}->{$answer}};
	} else {
		#print "Answer was undefined\n";
	}
} # main_menu

sub raspbian_menu {
	my ($cfg, $option) = @_;
	my $answer = undef;
	my $menu = new Term::Menu(
		tries => "$cfg->{'tries'}",
		beforetext => "$cfg->{'raspbian-beforetext'}",
		aftertext => "$cfg->{'aftertext'}",
		nooptiontext => "$cfg->{'nooptiontext'}",
		toomanytries => "$cfg->{'toomanytries'}"
	);
	$answer = $menu->menu(
		'lxde-libao'    => ["Raspbian/LXDE/speech-dispatcher using libao", '1'],
		'exit'    => ["Exit (back to main menu)", 'x'],
	);
	if ( defined $answer ) {
		if ( $answer eq 'exit' ) {
			return 1;
		} else {
			return &sausages($cfg, "$option/$answer");
		}
	} else {
		print "Answer was undefined\n";
		return 1;
	}
} # raspbian_menu

sub arch_menu {
	my ($cfg, $option) = @_;
	print "Arch was called\n";
	return 0;
	exit 0;
} # arch_menu

sub minibian_menu {
	my ($cfg, $option) = @_;
	print "Minibian was called\n";
	return 0;
	exit 0;
} # minibian_menu

#---- actual work

#sub raspbian_lxde_libao {
sub sausages {
	my ($cfg, $option) = @_;
	my @scripts;
	my $sm;
	# note: by the time this function is called $option should be 'sausage-pack-root/category/pack'
	# so appending /xxx will give the paths to config, utils, scripts and anything else
	$ENV{CONFIG_PATH} = join("/", ($cfg->{'sausage-pack-root'},$option, 'config'));;
	$ENV{SCRIPT_PATH} = join("/", ($cfg->{'sausage-pack-root'}, $option, 'scripts'));;
	$ENV{UTILS_PATH} = join("/", ($cfg->{'sausage-pack-root'}, $option, 'utils'));;
	$ENV{'SM_LOG_FILE'} = join("/", ($ENV{'BUILD_PATH'}, 
$cfg->{'log-file'}));
	$sm = <<eof;


sausages() {

	for SCRIPT in $ENV{'SCRIPT_PATH'}/*.sh
	do
		if [ -f \${SCRIPT} -a -f \${SCRIPT} ]; then
			\${SCRIPT}
		fi
	done
 
}

set -e
export BUILD_PATH=$ENV{'BUILD_PATH'}
export CONFIG_PATH=$ENV{'CONFIG_PATH'}
export SCRIPT_PATH=$ENV{'SCRIPT_PATH'}
export UTILS_PATH=$ENV{'UTILS_PATH'}
mkdir -p \${BUILD_PATH}
sausages | tee $ENV{'SM_LOG_FILE'} 

eof

	#print "$sm\n";
	system($sm);
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
		$cfg->{'build-path'} = "~/.builds";
	}

	if ( ! $cfg->{'sausage-pack-root'} ) {
		print "ERROR: Did not find a 'sausage-pack-root' key in the config file\n";
		return 0;
	}

	if ( ! -d $cfg{'sausage-pack-root'} ) {
		print "ERROR: The directory path found in the 'sausage-pack-root' key in the config file does not exist\n";
		return 0;
	}

	if ( ! $cfg->{'log-file'} ) {
		print "ERROR: Did not find a log-file key in the config file, setting to the default 'sausage-machine.log'\n";
		$cfg->{'log-file'} = "sausage-machine.log";
	}

	return 1;
}

sub set_env {
	my ($cfg) = 	@_;
	$ENV{'BUILD_PATH'} = $cfg->{'build-path'};
	$ENV{'SAUSAGE_PACK_ROOT'} = $cfg->{'sausage-pack-root'};
	$ENV{'SM_LOG_FILE'} = $cfg->{'log-file'};
	return;
}


