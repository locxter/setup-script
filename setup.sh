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
echo "#               Changing the apt repositories to Debian Unstable               #"
echo "################################################################################"
cat << EOF > /etc/apt/sources.list
deb https://deb.debian.org/debian sid main contrib non-free
deb-src https://deb.debian.org/debian sid main contrib non-free
EOF
echo "################################################################################"
echo "#              Removing unnecessary software, updating the system              #"
echo "#                      and installing additional software                      #"
echo "################################################################################"
apt update
apt purge aisleriot five-or-more four-in-a-row gnome-2048 gnome-chess gnome-klotski gnome-mahjongg gnome-mines gnome-nibbles gnome-robots gnome-sudoku gnome-taquin gnome-tetravex hitori iagno lightsoff quadrapassel swell-foop tali gnome-calendar gnome-clocks gnome-contacts gnome-documents evolution gnome-maps gnome-music malcontent shotwell gnome-todo gnome-weather seahorse synaptic gnome-tweaks gnome-shell-extensions gnome-shell-extension-prefs -y
apt full-upgrade -y
apt install neofetch htop git lm-sensors ufw cups locales-all flatpak gnome-software-plugin-flatpak default-jdk adb fastboot poppler-utils gedit-plugins bleachbit metadata-cleaner gnome-boxes tilp2 arduino codeblocks freecad cura inkscape anki chromium -y
if [ "$DATA_DRIVE" = true ]
then
    apt install syncthing -y
fi
if [ "$BACKUP_DRIVE" = true ]
then
    apt install deja-dup -y
fi
apt autoremove --purge -y
apt clean
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub com.tutanota.Tutanota org.signal.Signal org.apache.netbeans -y
echo "################################################################################"
echo "#                          Configuring the bootloader                          #"
echo "################################################################################"
mkdir -p /etc/default
cat << EOF > /etc/default/grub
GRUB_DEFAULT=0
GRUB_TIMEOUT=0
GRUB_DISTRIBUTOR="Debian"
GRUB_CMDLINE_LINUX_DEFAULT="quiet loglevel=3"
EOF
update-grub
echo "################################################################################"
echo "#                           Configuring the firewall                           #"
echo "################################################################################"
ufw enable
ufw allow syncthing
ufw allow transmission
echo "################################################################################"
echo "#                Configuring DNS over TLS and mac randomization                #"
echo "################################################################################"
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
mkdir -p /etc
cat << EOF > /etc/resolv.conf
nameserver 127.0.0.53
EOF
mkdir -p /etc/systemd
cat << EOF > /etc/systemd/resolved.conf
[Resolve]
DNS=176.9.93.198#dnsforge.de
DNS=176.9.1.117#dnsforge.de
DNSOverTLS=yes
EOF
systemctl enable systemd-resolved
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
Exec=bash -c "if ! test -e /media/locxter/data; then while ! udisksctl unlock -b $LOCKED_DATA_DRIVE --key-file <(zenity --password --title='Mount data drive' | tr -d '\n'); do zenity --error --text='Wrong password'; done; udisksctl mount -b $UNLOCKED_DATA_DRIVE; syncthing -no-browser; fi"
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Mount data drive
EOF
    cat << EOF > /home/locxter/.config/autostart/start-file-sync.desktop
[Desktop Entry]
Type=Application
Exec=bash -c "if test -e /media/locxter/data; then syncthing -no-browser; fi"
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
Exec=bash -c "if ! test -e /media/locxter/backup; then while ! udisksctl unlock -b $LOCKED_BACKUP_DRIVE --key-file <(zenity --password --title='Mount backup drive' | tr -d '\n'); do zenity --error --text='Wrong password'; done; udisksctl mount -b $UNLOCKED_BACKUP_DRIVE; while ! test -e /media/locxter/data; do zenity --error --text='Data drive not mounted'; done; deja-dup --backup; fi"
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Mount backup drive
EOF
    cat << EOF > /home/locxter/.config/autostart/start-backup.desktop
[Desktop Entry]
Type=Application
Exec=bash -c "if test -e /media/locxter/backup && test -e /media/locxter/data; then deja-dup --backup; fi"
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
mkdir -p /home/locxter/.mozilla/firefox
sudo -E -u locxter firefox -createProfile "locxter /home/locxter/.mozilla/firefox/locxter"
unzip -o firefox-profile.zip -d /home/locxter/.mozilla/firefox/locxter
cat << EOF > /home/locxter/.mozilla/firefox/profiles.ini
[Profile0]
Name=locxter
IsRelative=1
Path=locxter

[General]
StartWithLastProfile=0
Version=2
EOF
mkdir -p /home/locxter/.local/share/rhythmbox
cat << EOF > /home/locxter/.local/share/rhythmbox/rhythmdb.xml
<?xml version="1.0" standalone="yes"?>
<rhythmdb version="2.0">
  <entry type="iradio">
    <title>NDR N-Joy AAC 48kHz</title>
    <location>http://www.ndr.de/resources/metadaten/audio/aac/n-joy.m3u</location>
  </entry>
  <entry type="iradio">
    <title>NDR N-JOY Club</title>
    <location>https://www.ndr.de/resources/metadaten/audio_ssl/m3u/ndrloop5.m3u</location>
  </entry>
  <entry type="iradio">
    <title>NDR N-JOY Morningshow</title>
    <location>http://www.ndr.de/resources/metadaten/audio/m3u/ndrloop27.m3u</location>
  </entry>
  <entry type="iradio">
    <title>NDR N-JOY Pop</title>
    <location>https://www.ndr.de/resources/metadaten/audio_ssl/m3u/ndrloop29.m3u</location>
  </entry>
  <entry type="iradio">
    <title>NDR N-JOY Soundfiles Hip-Hop</title>
    <location>https://www.ndr.de/resources/metadaten/audio_ssl/m3u/ndrloop6.m3u</location>
  </entry>
  <entry type="iradio">
    <title>NDR N-JOY Weltweit</title>
    <location>https://www.ndr.de/resources/metadaten/audio_ssl/m3u/ndrloop28.m3u</location>
  </entry>
</rhythmdb>
EOF
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
mkdir -p /home/locxter/.config/libreoffice/4/user/autocorr
cp autocorrect-de.dat /home/locxter/.config/libreoffice/4/user/autocorr/acor_de-DE.dat
mkdir -p /home/locxter/.local/share/gtksourceview-4/language-specs
wget -O /home/locxter/.local/share/gtksourceview-4/language-specs/arduino.lang https://raw.githubusercontent.com/kaochen/GtkSourceView-Arduino/master/arduino.lang
chown -R locxter:locxter /home/locxter
echo "################################################################################"
echo "#                          Setting my profile picture                          #"
echo "################################################################################"
cp profile-picture.jpeg /home/locxter/.face
echo "################################################################################"
echo "#              Adding apps to the dash and resorting the app grid              #"
echo "################################################################################"
sudo -E -u locxter gsettings set org.gnome.shell favorite-apps "['firefox-esr.desktop', 'com.tutanota.Tutanota.desktop', 'org.signal.Signal.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop']"
sudo -E -u locxter gsettings set org.gnome.desktop.app-folders folder-children "['']"
sudo -E -u locxter gsettings set org.gnome.shell app-picker-layout "[]"
echo "################################################################################"
echo "#        Finished the setup, please check the console output for errors        #"
echo "#             that might occurred and reboot the system afterwards             #"
echo "################################################################################"
