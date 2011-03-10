#!/usr/local/bin/bash

# patch kernel / sources
		cd /usr/src
		wget http://m0n0wall2.googlecode.com/svn/trunk/kernelpatches/Makefile.orig.patch
		patch < Makefile.orig.patch
		wget http://m0n0wall2.googlecode.com/svn/trunk/kernelpatches/options.orig.patch
		patch < options.orig.patch
		wget http://m0n0wall2.googlecode.com/svn/trunk/kernelpatches/ip_ftp_pxy.c.orig.patch
		patch < ip_ftp_pxy.c.orig.patch
		wget http://m0n0wall2.googlecode.com/svn/trunk/kernelpatches/ip_nat.c.orig.patch
		patch < ip_nat.c.orig.patch
		wget http://m0n0wall2.googlecode.com/svn/trunk/kernelpatches/fil.c.orig.patch 
		patch < fil.c.orig.patch
		wget http://m0n0wall2.googlecode.com/svn/trunk/kernelpatches/ip_state.c.orig.patch
		patch < ip_state.c.orig.patch
		wget http://m0n0wall2.googlecode.com/svn/trunk/kernelpatches/mlfk_ipl.c.orig.patch 
		patch < mlfk_ipl.c.orig.patch
		wget http://m0n0wall2.googlecode.com/svn/trunk/kernelpatches/pfil.c.orig.patch 
		patch < pfil.c.orig.patch 
		wget http://m0n0wall2.googlecode.com/svn/trunk/kernelpatches/vm_machdep.c.orig.patch 
		patch < vm_machdep.c.orig.patch 


# kernel compile	got to remove ath/ath_hal rg lnc ugen ADAPTIVE_GIANT IPSTATE_MAX IPSTATE_SIZE and sio
#					rename FAST_IPSEC to IPSEC
#					add COMPAT_FREEBSD7 AH_SUPPORT_AR5416 and COMPAT43_TTYS
        cd /sys/i386/conf
        cp /usr/m0n0wall/build81/freebsd6/build/kernelconfigs/M0N0WALL_GENERIC* /sys/i386/conf/
        wget http://m0n0wall2.googlecode.com/svn/trunk/M0N0WALL_GENERIC.patch
		patch < M0N0WALL_GENERIC.patch
        config M0N0WALL_GENERIC
        cd /sys/i386/compile/M0N0WALL_GENERIC/
        make depend && make
        strip kernel
        strip --remove-section=.note --remove-section=.comment kernel
        gzip -9 kernel
        mv kernel.gz /usr/m0n0wall/build81/tmp/
        cd modules/usr/src/sys/modules
        cp /boot/kernel/if_tap.ko /boot/kernel/if_vlan.ko dummynet/dummynet.ko ipfw/ipfw.ko /usr/m0n0wall/build81/m0n0fs/boot/kernel
		cp /boot/kernel/acpi.ko /usr/m0n0wall/build81/tmp

# make libs
	cd /usr/m0n0wall/build81/tmp
	perl /usr/m0n0wall/build81/freebsd6/build/minibsd/mklibs.pl /usr/m0n0wall/build81/m0n0fs > m0n0wall.libs
	perl /usr/m0n0wall/build81/freebsd6/build/minibsd/mkmini.pl m0n0wall.libs / /usr/m0n0wall/build81/m0n0fs
