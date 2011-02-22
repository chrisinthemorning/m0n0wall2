#!/bin/sh

# kernel compile        - got to remove rg lnc ugen FAST_IPSEC ADAPTIVE_GIANT IPSTATE_MAX IPSTATE_SIZE
        cd /sys/i386/conf
        config M0N0WALL_GENERIC
        cd /sys/i386/compile/M0N0WALL_GENERIC/
        make depend && make
        gzip -9 kernel
        cd modules/usr/src/sys/modules
        cp dummynet/dummynet.ko if_tap/if_tap.ko if_vlan/if_vlan.ko ipfw/ipfw.ko /usr/m0n0wall/build81/m0n0fs/modules
