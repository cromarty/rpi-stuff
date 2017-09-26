PREFIX = /usr/local/bin
DATA_PREFIX = /usr/local/share
MKDIR_P = mkdir -p

install:
	install -m0755 scripts/rpi-pacstrap ${PREFIX}/rpi-pacstrap
	install -m0755 lib/rpi-pacstrap.lib ${PREFIX}/rpi-pacstrap.lib
	$(MKDIR_P) ${DATA_PREFIX}/rpi-pacstrap/data
	install -m0644 data/rpi_pacstrap_package_list.txt ${DATA_PREFIX}/rpi-pacstrap/data

clean:
	rm $(PREFIX)/rpi-pacstrap
	rm $(PREFIX)/rpi-pacstrap.lib
	rm -rf ${DATA_PREFIX}/rpi-pacstrap

