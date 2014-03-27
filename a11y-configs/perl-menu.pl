#!/usr/bin/perl -w

use strict;
use Menu;

&main_menu;

sub main_menu {
	my $mainmenu = new Menu( tries => 3);
	my $answer;
	$answer = $mainmenu->menu(
		raspbian    => ["Raspbian configurations", '1'],
		arch    => ["Arch configurations", '2'],
		minibian    => ["Minibian (minimalist Raspbian) configurations", '3'],
		exit    => ["Exit", 'x'],
	);
	if ( defined $answer ) {
		&{{ 'raspbian' => \&raspbian_menu, 'arch' => \&arch_menu, 'minibian' => \&minibian_menu, 'exit' => sub { print "Bye bye\n"; exit } }->{$answer}};
	} else {
		print "Answer was undefined\n";
	}
}

#---- first level sub menus

sub raspbian_menu {
	my $menu = new Menu( tries => 3);
	my $answer;
	$answer = $menu->menu(
		'lxde-sd-libao'    => ["Raspbian/LXDE/speech-dispatcher using libao", '1'],
		'exit'    => ["Exit", 'x'],
	);
	if ( defined $answer ) {
		&{{ 'lxde-sd-libao' => sub { print "Ran lxde-sd-libao\n"; exit }, 'exit' =>\&main_menu }->{$answer}};
	} else {
		print "Answer was undefined\n";
	}
}

sub arch_menu {
	print "Arch was called\n";
}

sub minibian_menu {
	print "Minibian was called\n";
}

#----- second level

