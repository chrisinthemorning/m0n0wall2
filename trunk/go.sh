#!/bin/csh

pkg_add -r wget bash
rehash
mkdir -p /usr/m0n0wall/build81
cd  /usr/m0n0wall/build81
wget http://m0n0wall2.googlecode.com/svn/trunk/doall.sh
wget http://m0n0wall2.googlecode.com/svn/trunk/1makebuildenv.sh
wget http://m0n0wall2.googlecode.com/svn/trunk/2makebinaries.sh
wget http://m0n0wall2.googlecode.com/svn/trunk/3patchtools.sh
wget http://m0n0wall2.googlecode.com/svn/trunk/4buildkernel.sh
wget http://m0n0wall2.googlecode.com/svn/trunk/5makeimage.sh
chmod a+rx *.sh

echo "I will leave you in a bash shell now"
echo "execute doall.sh or run 1makebuildenv.sh , then 2makebinaries.sh, then 3patchtools.sh etc"
/usr/local/bin/bash

