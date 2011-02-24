#!/bin/csh

pkg_add -r wget bash
rehash
mkdir -p /usr/m0n0wall/build81
cd  /usr/m0n0wall/build81
wget http://m0n0wall2.googlecode.com/svn/trunk/1makebuildenv.sh
wget http://m0n0wall2.googlecode.com/svn/trunk/2makebinaries.sh
wget http://m0n0wall2.googlecode.com/svn/trunk/3patchtools.sh
wget http://m0n0wall2.googlecode.com/svn/trunk/4buildkernel.sh
wget http://m0n0wall2.googlecode.com/svn/trunk/5makeimage.sh

echo "start a bash shell, can cd to /usr/m0n0wall/build81"
echo "run 1makebuildenv.sh , then 2makebinaries.sh, then 3patchtools.sh etc"
