#!/bin/sh

pkg_add -r wget
rehash
mkdir -p /usr/m0n0wall/build81
cd  /usr/m0n0wall/build81
wget http://m0n0wall2.googlecode.com/svn/trunk/1makebuildenv.sh
wget http://m0n0wall2.googlecode.com/svn/trunk/2makebinaries.sh
wget http://m0n0wall2.googlecode.com/svn/trunk/3patchtools.sh

echo "run makebuildenv.sh , then makebinaries.sh, then patchtools.sh"