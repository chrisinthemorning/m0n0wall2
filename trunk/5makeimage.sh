#!/usr/local/bin/bash

# make bootloader
	cd /usr/src
	patch < /usr/m0n0wall/build81/freebsd6/build/patches/boot/bootinfo.c.patch 
	cd /sys/boot
	make clean && make obj && make
	mkdir /usr/m0n0wall/build81/tmp/bootdir
	cp /usr/obj/usr/src/sys/boot/i386/loader/loader /usr/m0n0wall/build81/tmp/bootdir
	cp /usr/obj/usr/src/sys/boot/i386/boot2/{boot1,boot2} /usr/m0n0wall/build81/tmp/bootdir
	cp /usr/obj/usr/src/sys/boot/i386/cdboot/cdboot /usr/m0n0wall/build81/tmp/bootdir
	wget http://m0n0wall2.googlecode.com/svn/trunk/loader.rc
	mv loader.rc /usr/m0n0wall/build81/tmp/bootdir

# Creating mfsroot with 4MB spare space
	cd /usr/m0n0wall/build81/tmp
	dd if=/dev/zero of=mfsroot bs=1k count=`du -d0 /usr/m0n0wall/build81/m0n0fs | cut -b1-5 | tr " " "+" | xargs -I {} echo '(4096)+{}' | bc`
	mdconfig -a -t vnode -f /usr/m0n0wall/build81/tmp/mfsroot -u 20
	disklabel -rw /dev/md20 auto
	newfs -b 8192 -f 1024 -o space -m 0 /dev/md20
	mount /dev/md20 /mnt
	cd /mnt
	tar -cf - -C /usr/m0n0wall/build81/m0n0fs ./ | tar -xvpf -
	cd /usr/m0n0wall/build81/tmp
	umount /mnt
	mdconfig -d -u 20
	gzip -9f mfsroot
	
# Make img
	dd if=/dev/zero of=image.bin bs=1k count=`ls -l mfsroot.gz kernel.gz | tr -s " " " " | cut -f5 -d " " | xargs | tr " " "+" | xargs -I {} echo '(2097152+{})/1024' | bc`
	mdconfig -a -t vnode -f /usr/m0n0wall/build81/tmp/image.bin -u 30
	disklabel -Brw -b /usr/m0n0wall/build81/tmp/bootdir/boot1  /dev/md30 auto
	disklabel -rw /dev/md30 auto
	newfs -b 8192 -f 1024 -o space -m 0 /dev/md30
	mount /dev/md30 /mnt
	
	cp /usr/m0n0wall/build81/tmp/kernel.gz /mnt
	cp /usr/m0n0wall/build81/tmp/mfsroot.gz /mnt/
	mkdir -p /mnt/boot/kernel
	cp /usr/m0n0wall/build81/tmp/bootdir/{loader,loader.rc} /mnt/boot
	cp /usr/m0n0wall/build81/tmp/acpi.ko /mnt/boot/kernel
	mkdir /mnt/conf
	cp /usr/m0n0wall/build81/m0n0fs/conf.default/config.xml /mnt/conf
	cd /usr/m0n0wall/build81/tmp
	umount /mnt
	mdconfig -d -u 30
	gzip -9 image.bin
	cp image.bin.gz /usr/m0n0wall/build81/tmp/cdroot/firmware.img
	mv image.bin.gz /usr/m0n0wall/build81/images/generic-pc-2.0.img
	 
	 
# Make ISO
	cd /usr/m0n0wall/build81/tmp
	mkdir -p /usr/m0n0wall/build81/tmp/cdroot/boot/kernel
	cp /usr/m0n0wall/build81/tmp/acpi.ko /usr/m0n0wall/build81/tmp/cdroot/boot/kernel
	cp /usr/m0n0wall/build81/tmp/bootdir/{cdboot,loader,loader.rc} /usr/m0n0wall/build81/tmp/cdroot/boot
	cp kernel.gz mfsroot.gz  /usr/m0n0wall/build81/tmp/cdroot/
	mkisofs -b "boot/cdboot" -no-emul-boot -A "m0n0wall2 CD-ROM image" \
        -c "boot/boot.catalog" -d -r -publisher "foo.com" \
        -p "Your Name" -V "m0n0wall_cd" -o "m0n0wall.iso" \
        /usr/m0n0wall/build81/tmp/cdroot
	mv m0n0wall.iso /usr/m0n0wall/build81/images/generic-pc-2.0.iso
