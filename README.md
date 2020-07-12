# freebsdkde - Install KDE Xorg NVidia

sysrc linux_enable=yes

#reboot

pkg install git 

cd

git clone https://github.com/luckyphillips/freebsdkde/ 

cd freebsdkde 

chmod +x installkde.sh 

./installkde.sh

