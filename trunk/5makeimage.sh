#!/bin/sh

# make bootloader
	cd /usr/src
	patch < $MWPATCHDIR/boot/boot.patch
	cd /sys/boot
	make clean && make obj && make
	mkdir /usr/m0n0wall/build81/tmp/bootdir
	cp /usr/obj/usr/src/sys/boot/i386/loader/loader /usr/m0n0wall/build81/tmp/bootdir
	cp /usr/obj/usr/src/sys/boot/i386/boot2/{boot1,boot2} /usr/m0n0wall/build81/tmp/bootdir
	cp /usr/obj/usr/src/sys/boot/i386/cdboot/cdboot /usr/m0n0wall/build81/tmp/bootdir


# Creating mfsroot 11MB
	cd /usr/m0n0wall/build81/tmp
	dd if=/dev/zero of=mfsroot bs=1k count=11264
	vnconfig -s labels -c vn0 mfsroot
	disklabel -rw vn0 auto
	newfs -b 8192 -f 1024 -o space -m 0 /dev/vn0c
	mount /dev/vn0c /mnt
	cd /mnt
	tar -cf - -C /usr/m0n0wall/build81/m0n0fs ./ | tar -xvpf -
	umount /mnt
	vnconfig -u vn0
	gzip -9 mfsroot
	
# Make image 7MB
	dd if=/dev/zero of=image.bin bs=1k count=7168
	vnconfig -s labels -c vn0 image.bin
	disklabel -Brw -b /usr/m0n0wall/build81/tmp/bootdir/boot1 -s /usr/m0n0wall/build81/tmp/bootdir/boot2 vn0 auto
	disklabel -e vn0
	newfs -b 8192 -f 1024 -o space -m 0 /dev/vn0a
	mount /dev/vn0a /mnt
	
	cp /sys/compile/M0N0WALL_[PLATFORM]/kernel.gz /mnt
	cp mfsroot.gz /mnt
	mkdir /mnt/boot
	cp /usr/m0n0wall/build81/tmp/bootdir/{loader,loader.rc} /mnt/boot
	mkdir /mnt/conf
	cp /usr/m0n0wall/build81/m0n0fs/conf.default/config.xml /mnt/conf
	
	umount /mnt
	vnconfig -u vn0
	gzip -9 image.bin
	mv image.bin.gz /usr/m0n0wall/build81/images/generic-pc-2.0.img
	
# Make ISO
	cd /usr/m0n0wall/build81/tmp
	mkdir -p /usr/m0n0wall/build81/tmp/cdroot/boot
	cp /usr/m0n0wall/build81/tmp/bootdir/{cdboot,loader,loader.rc} /usr/m0n0wall/build81/tmp/cdroot

	mkisofs -b "boot/cdboot" -no-emul-boot -A "m0n0wall CD-ROM image" \
        -c "boot/boot.catalog" -d -r -publisher "foo.com" \
        -p "Your Name" -V "m0n0wall_cd" -o "m0n0wall.iso" \
        /usr/m0n0wall/build81/tmp/cdroot
        mv m0n0wall.iso /usr/m0n0wall/build81/images/generic-pc-2.0.iso