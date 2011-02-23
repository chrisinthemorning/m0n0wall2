#!/bin/csh

# ipfilter: ipf.c
        cd /usr/src
        patch < /usr/m0n0wall/build81/freebsd6/build/patches/user/ipfstat.c.patch
        cd sbin/ipf
        make
        install -s /usr/src/sbin/ipf/ipf/ipf /usr/m0n0wall/build81/m0n0fs/usr/sbin/
# syslogd circular logging support and ipv6 support
        cd /usr/src
        patch -R < /usr/m0n0wall/build81/freebsd6/build/patches/user/syslogd.c.ipv6.patch
        patch < /usr/m0n0wall/build81/freebsd6/build/patches/user/syslogd.c.patch
        cd usr.sbin
        tar xfvz /usr/m0n0wall/build81/freebsd6/build/patches/user/clog-1.0.1.tar.gz
        cd syslogd
        make
        install -s /usr/src/usr.sbin/syslogd/syslogd /usr/m0n0wall/build81/m0n0fs/usr/sbin/
        cd ../clog
        make obj && make
        install -s /usr/obj/usr/src/usr.sbin/clog/clog /usr/m0n0wall/build81/m0n0fs/usr/sbin/
# dhclient-script
        cp /usr/m0n0wall/build81/freebsd6/build/tools/dhclient-script /usr/m0n0wall/build81/m0n0fs/sbin
