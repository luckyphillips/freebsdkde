# freebsdkde - Install KDE Xorg NVidia
#Run as su

sysrc linux_enable=yes

#reboot

pkg install -y git 

cd

git clone https://github.com/luckyphillips/freebsdkde/ 

cd freebsdkde 

chmod +x installkde.sh 

./installkde.sh

