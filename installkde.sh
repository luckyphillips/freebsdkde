#!/bin/sh



if ! [ $(id -u) = 0 ]; then
   echo -e "\n\n****You must run this program as ROOT user****\n\n"
   exit 1
fi

INSTALLGNOME()
{
            case $1 in
                    [o]*)
                            pkg install -y nvidia-driver-390* linux-nvidia-libs-390* gnome3 gdm xorg xf86-video-intel nvidia-xconfig nvidia-settings bash 
                    ;;
                    *)
                            pkg install -y nvidia-driver linux-nvidia-libs gnome3 gdm xorg xf86-video-intel nvidia-xconfig nvidia-settings bash 
                    ;;
            esac
            wait
            nvidia-xconfig 
}

INSTALLKDE()
{
            case $1 in
                    [o]*)
                            pkg install nvidia-driver-390* linux-nvidia-libs-390* kde5 sddm xorg xf86-video-intel plasma5-plasma-desktop nvidia-xconfig nvidia-settings bash 
                    ;;
                    *)
                            pkg install -y nvidia-driver linux-nvidia-libs kde5 sddm xorg xf86-video-intel plasma5-plasma-desktop nvidia-xconfig nvidia-settings bash                             
                    ;;
            esac
            wait
            nvidia-xconfig 
}

cat << EOF

******************************************

       Starting Desktop Install
       
    (I take NO responsibility to this script)

**** Before running this script (or any script), please read through it to understand what is happening when you agree to the questions ****

This script will alter to the following files 
    
    /etc/rc.conf
    /etc/fstab
    /etc/sysctl.conf
    
******************************************

EOF






echo "Running a pkg update"
pkg update 








echo -e "\n\nLinux must be enabled in order for this to work. Continue (Y/n)"
read var_enablelinux
case $var_enablelinux in
        [Nn]*)
            echo "Linux must be enabled for the desktop to run. Continuing all the same..."
		;;
        *)
            echo "Added sysrc linux_enable=yes AND kldload linux"
            sysrc linux_enable=yes
            kldload linux
		;;
esac


cat << EOF 
Your current /etc/sysctl.conf looks like 


EOF

cat /etc/sysctl.conf

echo ""


cat << EOF 

****************************************************************

Add "net.local.stream.recvspace=65536" to /etc/sysctl.conf
Add "net.local.stream.sendspace=65536" to /etc/sysctl.conf


****************************************************************

EOF

echo "Update /etc/sysctl.conf with added values? (Y/n)"
read var_enablelinux2
case $var_enablelinux2 in
        [Nn]*)
#             echo "Linux must be enabled for the desktop to run. Continuing all the same..."
		;;
        *)
            echo "net.local.stream.recvspace=65536" >> /etc/sysctl.conf
            echo "net.local.stream.sendspace=65536" >> /etc/sysctl.conf
		;;
esac





echo "Your current /etc/rc.conf file"
echo "______________________________"
echo ""
cat /etc/rc.conf
echo ""
echo "______________________________"
echo ""
echo "Add kld_list=nvidia-modeset to /etc/rc.conf? (Y/n)" 
read var_enablelinuxkld
case $var_enablelinuxkld in
        [Nn]*)
            echo "You might need to have kld_list=nvidia-modeset or kld_list=nvidia in rc.conf for your card to work"
		;;
        *)
            echo 'kld_list="nvidia-modeset"' >> /etc/rc.conf
		;;
esac

echo ""
echo "Does your system have an (O)lder graphics card or a (N)ewer card? Newer = at least a nvidia gtx1050"
read var_enablelinuxcard

echo "Your /etc/fstab file"
cat /etc/fstab

cat << EOF 

 ****** Update your /etc/fstab file???? (Y/n) *******
 
 This will add these lines to the /etc/fstab file. 

    proc /proc procfs rw 0 0
    linprocfs   /compat/linux/proc  linprocfs       rw      0       0
    linsysfs    /compat/linux/sys   linsysfs        rw      0       0
    tmpfs    /compat/linux/dev/shm  tmpfs   rw,mode=1777    0       0

( READ : If you've already run this script before and added these lines, enter n and continue )

EOF
echo "Add lines to /etc/fstab? (Y/n)"
read var_enablelinuxfstab

case $var_enablelinuxfstab in
        [Nn]*)
            echo -e "You might need to update your fstab for your desktop to work"
		;;
        *)
            echo "proc /proc procfs rw 0 0" >> /etc/fstab 
            echo "linprocfs   /compat/linux/proc  linprocfs       rw      0       0" >> /etc/fstab
            echo "linsysfs    /compat/linux/sys   linsysfs        rw      0       0" >> /etc/fstab
            echo "tmpfs    /compat/linux/dev/shm  tmpfs   rw,mode=1777    0       0" >> /etc/fstab
        ;;
esac


cat << EOF 

Installing all files needed for your desktop.
Once you choose the desktop, this will take quite a while to install.

Would you like to install (K)DE or (G)NOME? (Q) to quit. 
    
    Default = (K)DE

EOF



read var_enablelinux3

case $var_enablelinux3 in
        [Qq]*)
            echo -e "You have quit the installation"
            exit 1
		;;
        [Gg]*)
            sysctl gnome_enable=yes
            sysctl gnome_enable=yes
            sysctl gdm_enable=yes
            sysctl hald_enable=yes
            sysctl dbus_enable=yes
            INSTALLGNOME $var_enablelinuxcard
            
        ;;
        [Kk]*)
            echo 'sddm_enable="YES"' >> /etc/rc.conf
            echo 'mouse_enable="YES"' >> /etc/rc.conf
            echo 'hald_enable="YES"' >> /etc/rc.conf
            echo 'dbus_enable="YES"' >> /etc/rc.conf
            INSTALLKDE $var_enablelinuxcard
        ;;     
        *)
            echo 'sddm_enable="YES"' >> /etc/rc.conf
            echo 'mouse_enable="YES"' >> /etc/rc.conf
            echo 'hald_enable="YES"' >> /etc/rc.conf
            echo 'dbus_enable="YES"' >> /etc/rc.conf
            INSTALLKDE $var_enablelinuxcard
        ;;            
esac


cat << EOF 


Installation is complete
It is recommended that you reboot your pc and it should take you straight to a login page.

If the script halts before all the packages are installed, run the script again after a reboot answering "n" until you choose the desktop again.
EOF












