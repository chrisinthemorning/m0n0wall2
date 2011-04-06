#!/usr/local/bin/bash

cd /usr/m0n0wall/build81/tmp
svn co https://m0n0mods.googlecode.com/svn/trunk/ntpd

cp /usr/m0n0wall/build81/tmp/ntpd/usr/local/www/* /usr/m0n0wall/build81/m0n0fs/usr/local/www/
cp /usr/m0n0wall/build81/tmp/ntpd/etc/inc/* /usr/m0n0wall/build81/m0n0fs/etc/inc/

install -s /usr/sbin/ntpd /usr/m0n0wall/build81/m0n0fs/usr/sbin/
install -s /usr/bin/ntpq  /usr/m0n0wall/build81/m0n0fs/usr/bin/

grep upl /sys/i386/conf/GENERIC >> /usr/m0n0wall/build81/freebsd8/build/kernelconfigs/M0N0WALL_GENERIC
grep u3g /sys/i386/conf/GENERIC >> /usr/m0n0wall/build81/freebsd8/build/kernelconfigs/M0N0WALL_GENERIC
echo "device\tucom" >> /usr/m0n0wall/build81/freebsd8/build/kernelconfigs/M0N0WALL_GENERIC
