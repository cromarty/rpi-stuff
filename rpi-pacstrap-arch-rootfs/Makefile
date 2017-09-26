PREFIX = /usr/local/bin
DATA_PREFIX = /usr/local/share
MKDIR_P = mkdir -p

install:
	install -m0755 scripts/rpi-pacstrap-arch-rootfs ${PREFIX}/rpi-pacstrap-arch-rootfs
	install -m0755 lib/rpi-pacstrap-arch-rootfs.lib ${PREFIX}/rpi-pacstrap-arch-rootfs.lib
	$(MKDIR_P) ${DATA_PREFIX}/rpi-pacstrap-arch-rootfs/data
	install -m0644 data/rpi_pacstrap_package_list.txt ${DATA_PREFIX}/rpi-pacstrap-arch-rootfs/data

clean:
	rm $(PREFIX)/rpi-pacstrap-arch-rootfs
	rm $(PREFIX)/rpi-pacstrap-arch-rootfs.lib
	rm -rf ${DATA_PREFIX}/rpi-pacstrap-arch-rootfs

