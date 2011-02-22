#!/bin/csh

# kernel compile	got to remove ath/ath_hal rg lnc ugen ADAPTIVE_GIANT IPSTATE_MAX IPSTATE_SIZE 
#					rename FAST_IPSEC to IPSEC
#					add COMPAT_FREEBSD7
        cd /sys/i386/conf
        cp /usr/m0n0wall/build81/freebsd6/build/kernelconfigs/M0N0WALL_GENERIC* /sys/i386/conf/
        wget http://m0n0wall2.googlecode.com/svn/trunk/M0N0WALL_GENERIC.patch
		patch < M0N0WALL_GENERIC.patch
        config M0N0WALL_GENERIC
        cd /sys/i386/compile/M0N0WALL_GENERIC/
        make depend && make
        gzip -9 kernel
        mv kernel.gz /usr/m0n0wall/build81/tmp/
        cd modules/usr/src/sys/modules
        cp dummynet/dummynet.ko if_tap/if_tap.ko if_vlan/if_vlan.ko ipfw/ipfw.ko /usr/m0n0wall/build81/m0n0fs/modules

# make libs
	cd /usr/m0n0wall/build81/tmp
	perl /usr/m0n0wall/build81/freebsd6/build/minibsd/mklibs.pl /usr/m0n0wall/build81/m0n0fs > m0n0wall.libs
	perl /usr/m0n0wall/build81/freebsd6/build/minibsd/mkmini.pl m0n0wall.libs / /usr/m0n0wall/build81/m0n0fs