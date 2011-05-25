cd /tmp
mkdiskimage -F m0n0fat 36 255 63
mkfs.vfat  -F 32 m0n0fat
syslinux m0n0fat
mount -t vfat  m0n0fat /mnt/m0n0fat/ -o loop
cd /mnt/m0n0fat/
tar -zxvf /home/awhite/generic-pc-syslinux-1.8.0b0.tgz
cd /tmp
cp /usr/lib/syslinux/memdisk /mnt/m0n0fat
ls -l /mnt/m0n0fat
umount /mnt/m0n0fat
rm /tmp/m2new.vdi
vboxmanage convertfromraw --variant Standard /tmp/m0n0fat /tmp/m2new.vdi
chmod a+r /tmp/m2new.vdi
