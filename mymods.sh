#!/usr/local/bin/bash
install -s /usr/sbin/ntpd /usr/m0n0wall/build81/m0n0fs/usr/sbin/
install -s /usr/bin/ntpq  /usr/m0n0wall/build81/m0n0fs/usr/bin/

grep upl /sys/i386/conf/GENERIC >> /usr/m0n0wall/build81/freebsd8/build/kernelconfigs/M0N0WALL_GENERIC
grep u3g /sys/i386/conf/GENERIC >> /usr/m0n0wall/build81/freebsd8/build/kernelconfigs/M0N0WALL_GENERIC
echo "device\tucom" >> /usr/m0n0wall/build81/freebsd8/build/kernelconfigs/M0N0WALL_GENERIC
