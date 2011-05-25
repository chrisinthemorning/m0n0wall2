scp user@10.60.47.199:/tmp/m2new.vdi /usr/virtualbox/root/.VirtualBox/HardDisks/
/usr/local/bin/VBoxManage controlvm m2 poweroff
/usr/local/bin/VBoxManage storageattach m2 --storagectl 'IDE Controller' --port 0 --device 0 --type hdd --medium none
/usr/local/bin/VBoxManage unregisterimage disk  /usr/virtualbox/root/.VirtualBox/HardDisks/m2new.vdi
/usr/local/bin/VBoxManage storageattach m2 --storagectl 'IDE Controller' --port 0 --device 0 --type hdd --medium   /usr/virtualbox/root/.VirtualBox/HardDisks/m2new.vdi
/usr/local/bin/VBoxManage startvm m2
