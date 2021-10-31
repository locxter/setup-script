#!/bin/bash
echo "################################################################################"
echo "#                              Starting the setup                              #"
echo "################################################################################"
echo "################################################################################"
echo "#          Add data drive scripts and programs to this computer?[y/N]          #"
echo "################################################################################"
read REPLY
if [[ $REPLY == [Yy]* ]]
then
    DATA_DRIVE=true
    echo "################################################################################"
    echo "#             Enter the device representing the locked data drive:             #"
    echo "################################################################################"
    read REPLY
    LOCKED_DATA_DRIVE=$REPLY
    echo "################################################################################"
    echo "#            Enter the device representing the unlocked data drive:            #"
    echo "################################################################################"
    read REPLY
    UNLOCKED_DATA_DRIVE=$REPLY
else
    DATA_DRIVE=false
fi
echo "################################################################################"
echo "#         Add backup drive scripts and programs to this computer?[y/N]         #"
echo "################################################################################"
read REPLY
if [[ $REPLY == [Yy]* ]]
then
    BACKUP_DRIVE=true
    echo "################################################################################"
    echo "#            Enter the device representing the locked backup drive:            #"
    echo "################################################################################"
    read REPLY
    LOCKED_BACKUP_DRIVE=$REPLY
    echo "################################################################################"
    echo "#           Enter the device representing the unlocked backup drive:           #"
    echo "################################################################################"
    read REPLY
    UNLOCKED_BACKUP_DRIVE=$REPLY
else
    BACKUP_DRIVE=false
fi
echo "################################################################################"
echo "#            Updating the system and installing additional software            #"
echo "################################################################################"
dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y
dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
dnf check-update
dnf upgrade -y
dnf install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel -y
dnf install lame\* --exclude=lame-devel -y
dnf group upgrade --with-optional Multimedia -y
dnf install lm_sensors neofetch htop git android-tools gcc-c++ java-11-openjdk-devel tilp2 gedit-plugins bleachbit chromium inkscape anki codeblocks arduino freecad cura -y
if [ "$DATA_DRIVE" = true ]
then
    dnf install syncthing -y
fi
if [ "$BACKUP_DRIVE" = true ]
then
    dnf install deja-dup -y
fi
dnf autoremove -y
dnf clean all
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub fr.romainvigier.MetadataCleaner com.tutanota.Tutanota org.signal.Signal org.apache.netbeans -y
echo "################################################################################"
echo "#                           Configuring the firewall                           #"
echo "################################################################################"
firewall-cmd --remove-port=1025-65535/tcp --remove-port=1025-65535/udp
firewall-cmd --add-service=syncthing
firewall-cmd --runtime-to-permanent
echo "################################################################################"
echo "#                Configuring DNS over TLS and mac randomization                #"
echo "################################################################################"
mkdir -p /etc/systemd/resolved.conf.d
cat << EOF > /etc/systemd/resolved.conf.d/dnsforge.conf
[Resolve]
DNS=176.9.93.198#dnsforge.de
DNS=176.9.1.117#dnsforge.de
DNSOverTLS=yes
EOF
mkdir -p /etc/NetworkManager/conf.d
cat << EOF > /etc/NetworkManager/conf.d/no-dns.conf
[main]
dns=none
systemd-resolved=false
EOF
cat << EOF > /etc/NetworkManager/conf.d/mac-randomization.conf
[device]
wifi.scan-rand-mac-address=yes
[connection-mac-randomization]
ethernet.cloned-mac-address=stable
wifi.cloned-mac-address=stable
EOF
echo "################################################################################"
echo "#                       Configuring scripts and programs                       #"
echo "################################################################################"
mkdir -p /usr/share/arduino/examples/01.Basics/BareMinimum
wget -O /usr/share/arduino/examples/01.Basics/BareMinimum/BareMinimum.ino https://raw.githubusercontent.com/locxter/arduino-template/main/arduino-template.ino
if [ "$DATA_DRIVE" = true ]
then
    mkdir -p /home/locxter/.config/autostart
    cat << EOF > /home/locxter/.config/autostart/mount-data-drive.desktop
[Desktop Entry]
Type=Application
Exec=bash -c "if ! test -e /run/media/locxter/data; then while ! udisksctl unlock -b $LOCKED_DATA_DRIVE --key-file <(zenity --password --title='Mount data drive' | tr -d '\n'); do zenity --error --text='Wrong password'; done; udisksctl mount -b $UNLOCKED_DATA_DRIVE; syncthing -no-browser; fi"
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Mount data drive
EOF
    cat << EOF > /home/locxter/.config/autostart/start-file-sync.desktop
[Desktop Entry]
Type=Application
Exec=bash -c "if test -e /run/media/locxter/data; then syncthing -no-browser; fi"
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Start file sync
EOF
fi
if [ "$BACKUP_DRIVE" = true ]
then
    mkdir -p /home/locxter/.config/autostart
    cat << EOF > /home/locxter/.config/autostart/mount-backup-drive.desktop
[Desktop Entry]
Type=Application
Exec=bash -c "if ! test -e /run/media/locxter/backup; then while ! udisksctl unlock -b $LOCKED_BACKUP_DRIVE --key-file <(zenity --password --title='Mount backup drive' | tr -d '\n'); do zenity --error --text='Wrong password'; done; udisksctl mount -b $UNLOCKED_BACKUP_DRIVE; while ! test -e /run/media/locxter/data; do zenity --error --text='Data drive not mounted'; done; deja-dup --backup; fi"
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Mount backup drive
EOF
    cat << EOF > /home/locxter/.config/autostart/start-backup.desktop
[Desktop Entry]
Type=Application
Exec=bash -c "if test -e /run/media/locxter/backup && test -e /run/media/locxter/data; then deja-dup --backup; fi"
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Start backup
EOF
fi
cat << EOF > /home/locxter/.gitconfig
[user]
name=locxter
email=54595101+locxter@users.noreply.github.com
[init]
defaultBranch = main
EOF
unzip -o firefox-profile.zip -d /home/locxter/.mozilla/firefox/*.default-release
mkdir -p /home/locxter/.config/codeblocks/UserTemplates/c-template
wget -O /home/locxter/.config/codeblocks/UserTemplates/c-template/c-template.cbp https://raw.githubusercontent.com/locxter/c-template/main/c-template.cbp
wget -O /home/locxter/.config/codeblocks/UserTemplates/c-template/c-template.layout https://raw.githubusercontent.com/locxter/c-template/main/c-template.layout
wget -O /home/locxter/.config/codeblocks/UserTemplates/c-template/main.c https://raw.githubusercontent.com/locxter/c-template/main/main.c
mkdir -p /home/locxter/.config/codeblocks/UserTemplates/cpp-template
wget -O /home/locxter/.config/codeblocks/UserTemplates/cpp-template/cpp-template.cbp https://raw.githubusercontent.com/locxter/cpp-template/main/cpp-template.cbp
wget -O /home/locxter/.config/codeblocks/UserTemplates/cpp-template/cpp-template.layout https://raw.githubusercontent.com/locxter/cpp-template/main/cpp-template.layout
wget -O /home/locxter/.config/codeblocks/UserTemplates/cpp-template/main.cpp https://raw.githubusercontent.com/locxter/cpp-template/main/main.cpp
mkdir -p /home/locxter/.config/codeblocks/UserTemplates/opencv-template
wget -O /home/locxter/.config/codeblocks/UserTemplates/opencv-template/main.cpp https://raw.githubusercontent.com/locxter/opencv-template/main/main.cpp
wget -O /home/locxter/.config/codeblocks/UserTemplates/opencv-template/opencv-template.cbp https://raw.githubusercontent.com/locxter/opencv-template/main/opencv-template.cbp
wget -O /home/locxter/.config/codeblocks/UserTemplates/opencv-template/opencv-template.layout https://raw.githubusercontent.com/locxter/opencv-template/main/opencv-template.layout
mkdir -p /home/locxter/.netbeans/12.5/config/Templates/Classes
wget -O /home/locxter/.netbeans/12.5/config/Templates/Classes/Main.java https://raw.githubusercontent.com/locxter/java-template/main/Main.java
wget -O /home/locxter/.netbeans/12.5/config/Templates/Classes/Class.java https://raw.githubusercontent.com/locxter/java-template/main/Class.java
mkdir -p /home/locxter/.config/inkscape/templates
wget -O /home/locxter/.config/inkscape/templates/default.svg https://raw.githubusercontent.com/locxter/inkscape-template/main/default.svg
mkdir -p /home/locxter/.config/libreoffice/4/user/template
wget -O /home/locxter/.config/libreoffice/4/user/template/document-template.ott https://raw.githubusercontent.com/locxter/document-template/main/document-template.ott
wget -O /home/locxter/.config/libreoffice/4/user/template/report-template.ott https://raw.githubusercontent.com/locxter/report-template/main/report-template.ott
wget -O /home/locxter/.config/libreoffice/4/user/template/presentation-template.otp https://raw.githubusercontent.com/locxter/presentation-template/main/presentation-template.otp
wget -O /home/locxter/.config/libreoffice/4/user/template/spreadsheet-template.ots https://raw.githubusercontent.com/locxter/spreadsheet-template/main/spreadsheet-template.ots
wget -O /home/locxter/.config/libreoffice/4/user/template/timetable-template.ott https://raw.githubusercontent.com/locxter/timetable-template/main/timetable-template.ott
mkdir -p /home/locxter/.local/share/gtksourceview-4/language-specs
wget -O /home/locxter/.local/share/gtksourceview-4/language-specs/arduino.lang https://raw.githubusercontent.com/kaochen/GtkSourceView-Arduino/master/arduino.lang
chown -R locxter:locxter /home/locxter
echo "################################################################################"
echo "#                          Adding the profile picture                          #"
echo "################################################################################"
cp profile-picture.jpeg /usr/share/pixmaps/faces/locxter.jpeg
cp profile-picture.jpeg /var/lib/AccountsService/icons/locxter
echo "################################################################################"
echo "#                Add favorite apps to the dash and press a key:                #"
echo "################################################################################"
read -s -n 1
sudo -E -u locxter gsettings set org.gnome.shell app-picker-layout "[]"
echo "################################################################################"
echo "#        Finished the setup, please check the console output for errors        #"
echo "#             that might occurred and reboot the system afterwards             #"
echo "################################################################################"
