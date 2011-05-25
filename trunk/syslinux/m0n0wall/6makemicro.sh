#!/usr/local/bin/bash


if [ -z "$MW_BUILDPATH" -o ! -d "$MW_BUILDPATH" ]; then
	echo "\$MW_BUILDPATH is not set"
	exit 1
fi

VERSION=`cat $MW_BUILDPATH/freebsd8/version`
if [ $MW_ARCH = "amd64" ]; then
	VERSION=$VERSION.$MW_ARCH	
fi

rm -rf $MW_BUILDPATH/m0n0fsmicro
mkdir $MW_BUILDPATH/m0n0fsmicro
cd  $MW_BUILDPATH/m0n0fsmicro
mkdir -p lib libexec bin sbin etc dev usr/sbin mnt/m0n0fat
perl $MW_BUILDPATH/freebsd8/build/minibsd/mkmini.pl $MW_BUILDPATH/freebsd8/build/scripts/micro.files /  $MW_BUILDPATH/m0n0fsmicro
perl $MW_BUILDPATH/freebsd8/build/minibsd/mklibs.pl $MW_BUILDPATH/m0n0fsmicro > /tmp/m0n0wallmicro.libs
perl $MW_BUILDPATH/freebsd8/build/minibsd/mkmini.pl /tmp/m0n0wallmicro.libs / $MW_BUILDPATH/m0n0fsmicro
cp  $MW_BUILDPATH/freebsd8/build/scripts/rc $MW_BUILDPATH/m0n0fsmicro/etc
find $MW_BUILDPATH/m0n0microfs/ | xargs strip -s 2> /dev/null

makeminimfsroot() {
	PLATFORM=$1
	SPARESPACE=$2
	
	echo -n "Making Mini mfsroot for $PLATFORM..."
	
	echo $PLATFORM > $MW_BUILDPATH/m0n0fs/etc/platform
	cd $MW_BUILDPATH/tmp
	dd if=/dev/zero of=mfsroot-$PLATFORM bs=1k count=`du -d0 $MW_BUILDPATH/m0n0fsmicro | cut -d "/" -f 1 | tr " " "+" | xargs -I {} echo "($SPARESPACE)+{}" | bc` > /dev/null 2>&1
	mdconfig -a -t vnode -f mfsroot-$PLATFORM -u 20
	disklabel -rw /dev/md20 auto
	newfs -b 8192 -f 1024 -o space -m 0 /dev/md20 > /dev/null
	mount /dev/md20 /mnt
	cd /mnt
	tar  -cf - -C $MW_BUILDPATH/m0n0fsmicro ./ | tar -xpf -
	cd $MW_BUILDPATH/tmp
	umount /mnt
	mdconfig -d -u 20
	gzip -9f mfsroot-$PLATFORM
	
	echo " done"
}

makeimage() {
	PLATFORM=$1
	SPARESPACE=$2
	
	echo -n "Making image for $PLATFORM..."
	
	# Make staging area to help calc space
	mkdir $MW_BUILDPATH/tmp/firmwaretmp
	
	cp $MW_BUILDPATH/tmp/kernel.gz $MW_BUILDPATH/tmp/firmwaretmp
	cp $MW_BUILDPATH/tmp/mfsroot-$PLATFORM.gz $MW_BUILDPATH/tmp/firmwaretmp/mfsroot.gz
	cp /boot/{loader,loader.rc} $MW_BUILDPATH/tmp/firmwaretmp
	if [ $MW_ARCH = "i386" ]; then
		cp $MW_BUILDPATH/tmp/acpi.ko $MW_BUILDPATH/tmp/firmwaretmp
	fi
	cp $MW_BUILDPATH/m0n0fs/conf.default/config.xml $MW_BUILDPATH/tmp/firmwaretmp

	cd $MW_BUILDPATH/tmp
	dd if=/dev/zero of=image.bin bs=1k count=`du -d0 $MW_BUILDPATH/tmp/firmwaretmp  | cut -b1-5 | tr " " "+" | xargs -I {} echo "($SPARESPACE)+{}" | bc` > /dev/null 2>&1
	rm -rf $MW_BUILDPATH/tmp/firmwaretmp
	
	mdconfig -a -t vnode -f $MW_BUILDPATH/tmp/image.bin -u 30
	disklabel  -wn  /dev/md30 auto 2>/dev/null |  awk '/unused/{if (M==""){sub("unused","4.2BSD");M=1}}{print}' > md.label
    bsdlabel -m  i386 -R -B -b /boot/boot /dev/md30 md.label
    newfs -b 8192 -f 1024 -O2 -U -o space -m 0 /dev/md30a > /dev/null
	mount /dev/md30a /mnt
	
	cp $MW_BUILDPATH/tmp/kernel.gz /mnt/
	cp $MW_BUILDPATH/tmp/mfsroot-$PLATFORM.gz /mnt/mfsroot.gz
	mkdir -p /mnt/boot/kernel
	cp /boot/loader /mnt/boot
	cp $MW_BUILDPATH/freebsd8/build/boot/$PLATFORM/loader.rc /mnt/boot
	if [ -r $MW_BUILDPATH/freebsd8/build/boot/$PLATFORM/boot.config ]; then
		cp $MW_BUILDPATH/freebsd8/build/boot/$PLATFORM/boot.config /mnt
	fi
	if [ $MW_ARCH = "i386" ]; then
		cp $MW_BUILDPATH/tmp/acpi.ko /mnt/boot/kernel
	fi
	mkdir /mnt/conf
	cp $MW_BUILDPATH/m0n0fs/conf.default/config.xml /mnt/conf
	cd $MW_BUILDPATH/tmp
	umount /mnt
	mdconfig -d -u 30
	gzip -9f image.bin
	mv image.bin.gz $MW_BUILDPATH/images/$PLATFORM-$VERSION.img
	
	echo " done"
}


# Creating mfsroots with 4MB spare space
	makeminimfsroot generic-pc-syslinux 4096
	
# Make firmware img with 2MB space 	
	makeimage generic-pc-syslinux 2048

# Make syslinux tgz file 
	mkdir -p $MW_BUILDPATH/tmp/syslinux
	cd $MW_BUILDPATH/tmp/syslinux
	
	echo "default M0n0wall" > $MW_BUILDPATH/tmp/syslinux/syslinux.cfg
	echo "label M0n0wall" >> $MW_BUILDPATH/tmp/syslinux/syslinux.cfg
	echo "linux memdisk" >> $MW_BUILDPATH/tmp/syslinux/syslinux.cfg
	echo "initrd generic-pc-syslinux-$VERSION.img" >> $MW_BUILDPATH/tmp/syslinux/syslinux.cfg
	echo "append raw ro noedd" >> $MW_BUILDPATH/tmp/syslinux/syslinux.cfg
 
	cp -R $MW_BUILDPATH/m0n0fs $MW_BUILDPATH/tmp/syslinux
	rm  $MW_BUILDPATH/tmp/syslinux/m0n0fs/conf
	mkdir $MW_BUILDPATH/tmp/syslinux/m0n0fs/conf
	mkdir -p $MW_BUILDPATH/tmp/syslinux/m0n0fs/cf/conf
	cp $MW_BUILDPATH/m0n0fs/conf.default/config.xml $MW_BUILDPATH/tmp/syslinux/m0n0fs/conf
	cp $MW_BUILDPATH/m0n0fs/conf.default/config.xml  $MW_BUILDPATH/tmp/syslinux/m0n0fs/cf/conf
	mv $MW_BUILDPATH/images/generic-pc-syslinux-$VERSION.img $MW_BUILDPATH/tmp/syslinux
	tar -zcf generic-pc-syslinux-$VERSION.tgz m0n0fs syslinux.cfg generic-pc-syslinux-$VERSION.img 
	mv generic-pc-syslinux-$VERSION.tgz $MW_BUILDPATH/images/
	rm -rf $MW_BUILDPATH/tmp/syslinux
	
	echo " done"

 scp /usr/m0n0wall/build82/images/generic-pc-syslinux-1.8.0b0.tgz awhite@10.60.47.199:
 ssh awhite@10.60.47.199 sudo /root/doit.sh
ssh awhite@10.60.47.198 sudo bash /root/doit.sh

