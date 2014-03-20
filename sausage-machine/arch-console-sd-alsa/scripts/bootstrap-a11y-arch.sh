#!/bin/bash

# Save the path from which we run the script. gwd = global working directory
gwd=$(pwd)

# Where we do the builds
BUILD_PATH=~/.builds


PKGS=( base-devel unzip parted git portaudio alsa-utils bc gnutls fuse sshfs tcl tk emacs )


# load file for speakup modules
SPEAKUP_LOAD_FILE=/etc/modules-load.d/speakup_soft.conf

# add the following packages to 'IgnorePkg' in pacman.conf
BLACKLIST="linux-raspberrypi"

# this stuff relates to the espeakup service
SERVICE_ROOT=/etc/systemd/system
SERVICE_FILE=espeakup.service
SERVICE_UNIT=${SERVICE_ROOT}/${SERVICE_FILE}
ESPEAKUP_DEFS=/etc/default/espeakup


check_errs() {
	# used for checking return value of function calls
	if [ "${1}" -ne "0" ]; then
		echo "-- Error ${1} : ${2}"
		exit ${1}
	fi
} # check_errs

checkpoint() {
	# called by almost every other function to keep a progress marker
	cp=$1
	echo "-- Checkpoint: ${1}"
	echo "${cp}" > ~/checkpoint
} # checkpoint

update_arch() {
	echo "-- update_arch now does nothing..."
} # update_arch

install_pkg() {
	echo "-- Installing ${1}..."
	pacman -S --noconfirm --noprogressbar --needed "${1}"
	check_errs $? "Failed installing ${1}"
} # install_pkg

install_packages() {
	checkpoint $1
	echo "-- Installing packages..."
	for pkg in "${PKGS[@]}"
	do
		install_pkg "${pkg}"
	done
} # install_packages

pkgbuild_edit() {
	echo "-- Editing PKGBUILD to add 'armv6h'..."
	sed -i-old "s:^arch=(\(.*\)):arch=(\1 'armv6h'):" PKGBUILD
	check_errs $? "Failed in pkgbuild_edit"
} # pkgbuild_edit

edit_sudoers() {
	checkpoint $1
	echo "-- Checking whether sudo is installed before editing the sudoers file to grant the usual privilages..."
	which sudo &> /dev/null
	if [ $? != 0 ]; then
		echo "-- sudo is not installed."
		return 0
	fi
	echo "-- Checking to see if we have already done the sudoers edit..."
	if [ -f /etc/sudoers-old ]; then
		echo "-- Looks like we already did the edit"
		return 0
	fi
	sed -i-old 's:#\( %wheel ALL=(ALL) ALL\):\1:' /etc/sudoers
	check_errs $? "Failed in edit_sudoers"
	echo "-- Old sudoers file is /etc/sudoers-old"
} # edit_sudoers


pulse_user_and_group_stuff() {
	checkpoint $1
	echo "-- Adding groups pulse and pulse-access, and adding user pulse..."
	if [ -z $(cat /etc/group | grep '^[p]ulse:' | cut -f 1 -d:) ]; then
		groupadd -g 58 pulse
		check_errs $? "Failed in pulse_user_and_group_stuff"
	else
		echo "-- Group pulse already exists"
	fi
	if [ -z $(cat /etc/group | grep '^[p]ulse-access:' | cut -f 1 -d:) ]; then
		groupadd -g 59 pulse-access
		check_errs $? "Failed in pulse_user_and_group_stuff"
	else
		echo "-- Group pulse-access already exists"
	fi
	if [ -z $(cat /etc/passwd | grep '^[u]ser:' | cut -f 1 -d:) ]; then
		useradd -c "Pulseaudio User" -d /var/run/pulse -g pulse -G pulse-access -s /bin/false -u 58 pulse
		check_errs $? "Failed in pulse_user_and_group_stuff"
	else
		echo "-- User pulse already exists"
	fi
} # pulse_user_and_group_stuff

install_cower() {
	checkpoint $1
	local wd=$(pwd)
	echo "-- Checking to see if cower is installed..."
	which cower &> /dev/null
	if [ $? -eq 0 ]; then
		echo "-- cower is already installed"
		return 0
	fi
	echo "-- Installing cower..."
	wget https://aur.archlinux.org/packages/co/cower-git/cower-git.tar.gz &&
	tar -zxf cower-git.tar.gz &&
	cd cower-git &&
	pkgbuild_edit &&
	makepkg -s -i --asroot --noconfirm --noprogressbar
	check_errs $? "failed in install_cower"
	cd "${BUILD_PATH}" && rm -rf cower-git/
	check_errs $? "Failed to remove cower build directory after successful build"
	echo "-- Successfully installed cower"
	cd "${wd}"
} # install_cower


install_espeak_dummy() {
	checkpoint $1
	local wd=$(pwd)
	echo "-- Installing espeak-rpi..."
	mkdir espeak &&
	cd espeak &&
	cat <<EOF > PKGBUILD &&
# Maintainer:
# Contributors :
pkgname=espeak
pkgver=1.47.11
pkgrel=1
pkgdesc="Dummy espeak package"
url=('')
arch=('armv6h')
license=('GPL')
depends=()
optdepends=()
makedepends=()
replaces=()
conflicts=('espeak')
provides=('espeak')

build() {
   echo "Do nothing"
}

EOF

	makepkg --asroot -i --noconfirm
	check_errs $? "Failed in install_espeak-rpi"
	echo "-- Successfully installed espeak-rpi"
	cd "${wd}"
} # install_espeak_dummy

install_espeak_from_source() {
	checkpoint $1
	local wd=$(pwd)
	echo "-- Installing espeak from source..."
	wget http://sourceforge.net/projects/espeak/files/espeak/espeak-1.48/espeak-1.48.02-source.zip
	check_errs $? "Failed to get the espeak source file"
	unzip espeak-1.48.02-source.zip &&
	cd espeak-1.48.01-source/src &&
	cp portaudio19.h portaudio.h &&
	sed -i -e 's:FRAMES_PER_BUFFER 512:FRAMES_PER_BUFFER 2048:' -e 's:paFramesPerBufferUnspecified:FRAMES_PER_BUFFER:' wave.cpp &&
	make all &&
	make install
	check_errs $? "Failed in install_espeak_from_source"
	echo "-- Completed installation of espeak from source"
	cd ${wd}
} # install_espeak_from_source

install_tclx() {
	checkpoint $1
	local wd=$(pwd)
	echo "-- Checking to see if tclx is installed..."
	if [ ! -z "$(cower -s tclx | grep "tclx " | grep '[i]nstalled')" ]; then
		echo "-- tclx is already installed"
		return 0
	fi
	echo "-- Installing tclx..."
	cower -d tclx &&
	cd tclx &&
	pkgbuild_edit &&
	makepkg -s -i --asroot --noconfirm --noprogressbar &&
	cp -r pkg/usr/lib/tclx8.4/ /usr/lib
	check_errs $? "Failed in install_tclx"
	cd "${BUILD_PATH}" && rm -rf tclx/
	check_errs $? "Failed to remove tclx build directory after successful build"
	echo "-- Successfully installed tclx"
	cd "${wd}"
} # install_tclx

install_emacspeak() {
	checkpoint $1
	local wd=$(pwd)
	echo "-- Checking to see if emacspeak is already installed..."
	if [ ! -z "$(cower -s emacspeak | grep "emacspeak " | grep '[i]nstalled')" ]; then
		echo "-- emacspeak is already installed"
		return 0
	fi
	echo "-- Checking that espeak is installed..."
	which espeak &> /dev/null
	check_errs $? "eSpeak is not installed.  Can't install emacspeak"
	echo "-- Installing emacspeak..."
	cower -d emacspeak &&
	cd emacspeak &&
	emacspeak_pkgbuild_edit &&
	makepkg -s -i --asroot --noconfirm --noprogressbar
	check_errs $? "Failed in install_emacspeak"
	cd "${BUILD_PATH}" && rm -rf emacspeak/
	check_errs $? "Failed to remove emacspeak build directory after successful build"
	echo "Successfully installed emacspeak"
	cd "${wd}"
} # install_emacspeak


edit_usr_bin_emacspeak() {
	checkpoint $1
	echo "-- Editing the file /usr/bin/emacspeak to enable saving config files..."
	sed -i-old -e "s:\$HOME:~:" \
		-e "s:EMACS_UNIBYTE:#EMACS_UNIBYTE:" \
		-e "s:export EMACS_UNIBYTE:#export EMACS_UNIBYTE:" \
		-e "s:-q ::" /usr/bin/emacspeak
	check_errs $? "Failed editing /usr/bin/emacspeak"
	echo "-- Old emacspeak file saved in /usr/bin/emacspeak"
} # edit_usr_bin_emacspeak

config_emacspeak_skel() {
	checkpoint $1
	echo "-- Setting up emacspeak stuff in /etc/skel..."
		cp "${gwd}/.emacs" /etc/skel/.emacs &&
	mkdir -p /etc/skel/.emacs.d/elpa &&
	cp "${gwd}/package.el" /etc/skel/.emacs.d/elpa/package.el &&
	chmod 0644 /etc/skel/.emacs &&
	chmod 0700 /etc/skel/.emacs.d &&
	chmod 0755 /etc/skel/.emacs.d/elpa &&
	chmod 0644 /etc/skel/.emacs.d/elpa/package.el
	check_errs $? "Failed in config_emacspeak_skel"
} # config_emacspeak_skel


install_brltty_minimal() {
	checkpoint $1
	local wd=$(pwd)
	echo "-- Checking to see if brltty-minimal is installed..."
	if [ ! -z "$(cower -s brltty-minimal | grep "brltty-minimal " | grep '[i]nstalled')" ]; then
		echo "-- brltty-minimal is already installed"
		return 0
	fi
	echo "Installing brltty-minimal..."
	cower -d brltty-minimal &&
	cd brltty-minimal &&
	pkgbuild_edit &&
	makepkg -s -i --asroot --noconfirm --noprogressbar
	check_errs $? "Failed in install_brltty_minimal"
	echo "-- Successfully installed brltty-minimal"
	cd "${wd}"
} # install_brltty_minimal

add_new_user() {
	checkpoint $1
	echo "-- Adding the user: user..."
	useradd -m -g users -G audio,lp,storage,video,wheel,games,power,pulse,pulse-access -s /bin/bash user &&
	echo -e "password\npassword\n" | /usr/bin/passwd user
	check_errs $? "Failed adding new user: user"
	echo "-- Added new user 'user' successfully"
} # add_new_user

edit_user_files() {
	checkpoint $1
	echo "-- Adding export DTK_PROGRAM=espeak to the new user's .bashrc..."
	echo "-- Adding pulseaudio --start to the new user's .bash_profile..."
	echo "export DTK_PROGRAM=espeak" >> /home/user/.bashrc &&
	cat <<EOF >> /home/user/.bash_profile

pa=\$(ps aux | grep '[p]ulseaudio')
if [ -z "\${pa}" ]; then
	pulseaudio --start --resampling-method=trivial
fi

EOF

	check_errs $? "Failed in edit_user_files"
} # edit_user_files

edit_skel_files() {
	checkpoint $1
	echo "-- Adding export DTK_PROGRAM=espeak to /etc/skel/.bashrc..."
	echo "-- Adding pulseaudio --start to /etc/skel/.bash_profile..."
	echo "export DTK_PROGRAM=espeak" >> /etc/skel/.bashrc &&
	cat <<EOF >> /etc/skel/.bash_profile

pa=\$(ps aux | grep '[p]ulseaudio')
if [ -z "\${pa}" ]; then
	pulseaudio --start --resampling-method=trivial
fi

EOF

	check_errs $? "Failed in edit_skel_files"
} # edit_skel_files


load_speakup_modules_file() {
	checkpoint $1
	# write the modules load file for the speakup modules
	echo "-- Writing ${SPEAKUP_LOAD_FILE}..."
	echo "speakup_soft" > "${SPEAKUP_LOAD_FILE}"
	check_errs $? "Failed to create /etc/modules-load.d/speakup_soft.conf"
} # load_speakup_modules_file

espeakup_defaults_file() {
	checkpoint $1
	echo "-- Deploying the espeakup defaults file..."
	echo "-- Deploying ${SERVICE_UNIT}..."
	cp "${gwd}/espeakup.defaults" "${ESPEAKUP_DEFS}" &&
	chmod 0644 "${ESPEAKUP_DEFS}"
	check_errs $? "Failed in espeakup_defaults_file"
} # espeakup_defaults_file

espeakup_service_unit() {
	checkpoint $1
	echo "-- Deploying the espeakup service unit..."
	cp "${gwd}/${SERVICE_FILE}" "${SERVICE_UNIT}" &&
	chmod 0644 "${SERVICE_UNIT}"
	check_errs $? "Failed in espeakup_service_unit"
} # espeakup_service_unit


fix_alsa_conf() {
	checkpoint $1
	echo "-- Fixing /usr/share/alsa/alsa.conf to comment out cards which do not exist..."
	sed -i-old -e 's:^\(pcm\.front cards\.pcm\.front\):#\1:' \
		-e 's:^\(pcm\.rear cards\.pcm\.rear\):#\1:' \
		-e 's:^\(pcm\.center_lfe cards\.pcm\.center_lfe\):#\1:' \
		-e 's:^\(pcm\.side cards\.pcm\.side\):#\1:' \
		-e 's:^\(pcm\.surround40 cards\.pcm\.surround40\):#\1:' \
		-e 's:^\(pcm\.surround41 cards\.pcm\.surround41\):#\1:' \
		-e 's:^\(pcm\.surround50 cards\.pcm\.surround50\):#\1:' \
		-e 's:^\(pcm\.surround51 cards\.pcm\.surround51\):#\1:' \
		-e 's:^\(pcm\.surround71 cards\.pcm\.surround71\):#\1:' \
		-e 's:^\(pcm\.iec958 cards\.pcm\.iec958\):#\1:' \
		-e 's:^\(pcm\.spdif iec958\):#\1:' \
		-e 's:^\(pcm\.hdmi cards\.pcm\.hdmi\):#\1:' \
		-e 's:^\(pcm\.dmix cards\.pcm\.dmix\):#\1:' \
		-e 's:^\(pcm\.modem cards\.pcm\.modem\):#\1:' \
		-e 's:^\(pcm\.phoneline cards\.pcm\.phoneline\):#\1:' /usr/share/alsa/alsa.conf
	check_errs $? "-- Failed in fix_alsa_conf"
	echo "-- Old alsa.conf file saved to /usr/share/alsa/alsa.conf-old"
} # fix_alsa_conf

chmod_filesystem_scripts() {
	checkpoint $1
	echo "-- Setting executable flags of file-system scripts..."
	chmod +x "${gwd}/expand-arch-rootfs-2.0.sh" &&
	chmod +x "${gwd}/resize-arch-rootfs-2.0.sh"
	check_errs $? "Failed to chmod +x file-system scripts"
} # chmod_filesystem_scripts

blacklist_packages() {
	checkpoint $1
	echo "-- Adding blacklisted packages to 'IgnorePkg' setting in /etc/pacman.conf..."
	if [ -z "${BLACKLIST}" ]; then
		echo "-- Nothing to blacklist"
		return 0
	fi
	sed -i-old -r "s:#\s*IgnorePkg\s*=\s*:IgnorePkg = ${BLACKLIST}:" /etc/pacman.conf
	check_errs $? "Failed in blacklist_packages"
} # blacklist_packages

suppress_boot_messages() {
	checkpoint $1
	echo "-- Editing /boot/cmdline.txt to suppress stuttery boot messages..."
	check_errs $? "Failed in suppress_boot_messages"
} # suppress_boot_messages

	sed -i 's:\(.*\):\1 quiet:' /boot/cmdline.txt

### start of main code


# check we're root
if [ $(id -u) -ne 0 ]; then
	echo "-- Script must be run as root. Try 'sudo $0'"
	exit 1
fi

# check and possibly default the build path
if [ -z "${BUILD_PATH}" ]; then
	BUILD_PATH=~/.builds
fi

# mkdir the build path
if [ ! -d "${BUILD_PATH}" ]; then
	mkdir -p "${BUILD_PATH}" &&
	check_errs $? "Failed to mkdir ${BUILD_PATH} and/or cd to it"
fi

cd "${BUILD_PATH}"


date


# reset checkpoint to beginning if checkpoint file does not exist
if [ ! -f ~/checkpoint ]; then
	echo "-- Resetting absent checkpoint data to start-point"
	checkpoint "0:"
fi

# get checkpoint file contents
cp=$(cat ~/checkpoint | cut -f 1 -d:)
p=$(cat ~/checkpoint | cut -f 2 -d:)
if [ ! -z "${c}" ]; then
	PKGS="${p}"
	echo "-- Packages from checkpoint file: ${PKGS}"
fi

echo "-- At start, checkpoint is: ${cp}"

case "${cp}" in
	0)
		update_arch 0
;&
	1)
		install_packages 1
;&
	2)
		#pulse_user_and_group_stuff 2
		install_espeak_from_source 2
;&
	3)
		edit_sudoers 3
;&
	4)
		install_cower 4
;&
	5)
		install_espeak_dummy 5
;&
	6)
		install_tclx 6
;&
	7)
		install_emacspeak 7
;&
	8)
		edit_usr_bin_emacspeak 8
;&
	9)
		config_emacspeak_skel 9
;&
	10)
		install_brltty_minimal 10
;&
	11)
		PKGS=( espeakup )
		install_packages 11
;&
	12)
		config_emacspeak_skel 12
;&
	13)
		add_new_user 13
;&
	14)
		edit_user_files 14
;&
	15)
		edit_skel_files 15
;&
	16)
		load_speakup_modules_file 16
;&
	17)
		espeakup_defaults_file 17
;&
	18)
		espeakup_service_unit 18
;&
	19)
		fix_alsa_conf 19
;&
	20)
		chmod_filesystem_scripts 20
;&
	21)
		blacklist_packages 21
;&
	22)
		suppress_boot_messages 22
;;
esac


date

# We have a successful finish so remove ~/checkpoint file if it exists
if [ -f ~/checkpoint ]; then
	rm ~/checkpoint
fi

# remove the build directory
rm -rf "${BUILD_PATH}"

echo "-- Done everything successfully!"

exit 0

