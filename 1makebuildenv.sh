#!/bin/csh

# get build env ready
	pkg_add -r subversion cdrtools curl autoconf213 autoconf262
	rehash
	cd  /usr/m0n0wall/build81
	svn export http://svn.m0n0.ch/wall/branches/freebsd6/
 
# make filesystem structure for image
	mkdir  m0n0fs tmp images
	cd m0n0fs
	mkdir -p etc/rc.d/ bin cf conf conf.default dev etc ftmp mnt modules proc root sbin tmp var libexec lib usr/bin usr/lib usr/libexec usr/local usr/sbin usr/share usr/local/bin usr/local/captiveportal usr/local/lib usr/local/sbin usr/local/www usr/share/misc boot/kernel
 
# insert svn files to filesystem
	cp -r ../freebsd6/phpconf/ etc/
	cp -r ../freebsd6/etc/* etc
	mv etc/rc.bootup  etc/rc.d/
	cp -r ../freebsd6/webgui/ usr/local/www/
	cp -r ../freebsd6/captiveportal usr/local/
 
# set permissions
	chmod -R 0755 usr/local/www/* usr/local/captiveportal/*
 
# create links
	ln -s cf/conf conf
	ln -s var/run/htpasswd usr/local/www/.htpasswd
 
# configure build information
	echo "generic-pc-cdrom" > etc/platform
	date > etc/version.buildtime
	echo "2.0rc1" > etc/version
 
# get and set current default configuration
	curl http://m0n0.ch/wall/downloads/config.xml > conf.default/config.xml
	cp conf.default/config.xml conf/config.xml
 
# insert termcap and zoneinfo files
	cp /usr/share/misc/termcap usr/share/misc
 
# do zoneinfo.tgz and dev fs
	cd tmp
	wget ftp://ftp.yzu.edu.tw/mirror/pub2/BSD/m0n0wall/freebsd-4.11/zoneinfo.tgz 
	cp zoneinfo.tgz /usr/m0n0wall/build81/m0n0fs/usr/share
	perl /usr/m0n0wall/build81/freebsd6/build/minibsd/mkmini.pl /usr/m0n0wall/build81/freebsd6/build/minibsd/m0n0wall.files  / /usr/m0n0wall/build81/m0n0fs/
	wget ftp://ftp.yzu.edu.tw/mirror/pub2/BSD/m0n0wall/freebsd-4.11/dev.tgz
	tar -xzf dev.tgz -C /usr/m0n0wall/build81/m0n0fs/

# create php.ini	
	wget http://m0n0wall2.googlecode.com/svn/trunk/php.ini
	mv php.ini /usr/m0n0wall/build81/m0n0fs/usr/local/lib/php.ini
	cd ..