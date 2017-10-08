PREFIX = /usr/local/bin
LISTS_PREFIX = /usr/local/share
MKDIR_P = mkdir -p

install:
	install -m0755 pacstrap-arch-pi ${PREFIX}/pacstrap-arch-pi
	$(MKDIR_P) ${LISTS_PREFIX}/pacstrap-arch-pi/lists
	install -m0644 lists/packages.base.txt ${LISTS_PREFIX}/pacstrap-arch-pi/lists

clean:
	rm $(PREFIX)/pacstrap-arch-pi
	rm -rf ${LISTS_PREFIX}/pacstrap-arch-pi

