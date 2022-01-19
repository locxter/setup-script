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
echo "#              Removing unnecessary software, updating the system              #"
echo "#                      and installing additional software                      #"
echo "################################################################################"
sudo apt update
sudo apt purge aisleriot gnome-calendar seahorse thunderbird gnome-mahjongg gnome-mines remmina shotwell gnome-sudoku gnome-todo baobab cheese -y
if [ "$BACKUP_DRIVE" = false ]
then
    sudo apt purge deja-dup -y
fi
sudo apt full-upgrade -y
sudo apt install git gcc g++ openjdk-17-jdk lm-sensors neofetch adb fastboot gedit-plugins ubuntu-restricted-extras libserialport0 patchelf bleachbit metadata-cleaner gnome-boxes tilp2 codeblocks cura inkscape anki freecad arduino -y
if [ "$DATA_DRIVE" = true ]
then
    sudo apt install syncthing -y
fi
sudo apt autoremove --purge -y
sudo apt autoclean
sudo snap install chromium signal-desktop
sudo snap install netbeans --classic
echo "################################################################################"
echo "#                           Configuring the firewall                           #"
echo "################################################################################"
sudo ufw enable
if [ "$DATA_DRIVE" = true ]
then
    sudo ufw allow syncthing
fi
echo "################################################################################"
echo "#                Configuring DNS over TLS and mac randomization                #"
echo "################################################################################"
sudo mkdir -p /etc/NetworkManager/conf.d
sudo tee /etc/NetworkManager/conf.d/no-dns.conf << EOF
[main]
dns=none
systemd-resolved=false
EOF
sudo tee /etc/NetworkManager/conf.d/mac-randomization.conf << EOF
[device]
wifi.scan-rand-mac-address=yes
[connection-mac-randomization]
ethernet.cloned-mac-address=stable
wifi.cloned-mac-address=stable
EOF
sudo mkdir -p /etc/systemd
sudo tee /etc/systemd/resolved.conf << EOF
[Resolve]
DNS=176.9.93.198#dnsforge.de
DNS=176.9.1.117#dnsforge.de
DNSOverTLS=yes
EOF
echo "################################################################################"
echo "#                       Configuring scripts and programs                       #"
echo "################################################################################"
sudo mkdir -p /usr/share/arduino/examples/01.Basics/BareMinimum
sudo wget -O /usr/share/arduino/examples/01.Basics/BareMinimum/BareMinimum.ino https://raw.githubusercontent.com/locxter/arduino-template/main/arduino-template.ino
sudo patchelf --add-needed libserialport.so.0 /usr/lib/x86_64-linux-gnu/liblistSerialsj.so.1.4.0
if [ "$DATA_DRIVE" = true ]
then
    mkdir -p ~/.config/autostart
    tee ~/.config/autostart/mount-data-drive.desktop << EOF
[Desktop Entry]
Type=Application
Exec=bash -c "if ! test -e /media/$USER/data; then while ! udisksctl unlock -b $LOCKED_DATA_DRIVE --key-file <(zenity --password --title='Mount data drive' | tr -d '\n'); do zenity --error --text='Wrong password'; done; udisksctl mount -b $UNLOCKED_DATA_DRIVE; syncthing -no-browser; fi"
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Mount data drive
EOF
    tee ~/.config/autostart/start-file-sync.desktop << EOF
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
    mkdir -p ~/.config/autostart
    tee ~/.config/autostart/mount-backup-drive.desktop << EOF
[Desktop Entry]
Type=Application
Exec=bash -c "if ! test -e /media/locxter/backup; then while ! udisksctl unlock -b $LOCKED_BACKUP_DRIVE --key-file <(zenity --password --title='Mount backup drive' | tr -d '\n'); do zenity --error --text='Wrong password'; done; udisksctl mount -b $UNLOCKED_BACKUP_DRIVE; while ! test -e /media/locxter/data; do zenity --error --text='Data drive not mounted'; done; deja-dup --backup; fi"
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Mount backup drive
EOF
    tee ~/.config/autostart/start-backup.desktop << EOF
[Desktop Entry]
Type=Application
Exec=bash -c "if test -e /media/locxter/backup && test -e /media/locxter/data; then deja-dup --backup; fi"
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Start backup
EOF
fi
tee ~/.gitconfig << EOF
[user]
name=locxter
email=54595101+locxter@users.noreply.github.com
[init]
defaultBranch = main
EOF
mkdir -p ~/.local/share/cura
unzip -o cura-config.zip -d ~/.local/share/cura
mkdir -p ~/snap/firefox/common/.mozilla/firefox
firefox -createProfile "locxter /home/locxter/snap/firefox/common/.mozilla/firefox/locxter"
unzip -o firefox-profile.zip -d ~/snap/firefox/common/.mozilla/firefox/locxter
tee ~/snap/firefox/common/.mozilla/firefox/profiles.ini << EOF
[Profile0]
Name=locxter
IsRelative=1
Path=locxter

[General]
StartWithLastProfile=0
Version=2
EOF
mkdir -p ~/snap/netbeans/52/config/Templates/Classes
wget -O ~/snap/netbeans/52/config/Templates/Classes/Main.java https://raw.githubusercontent.com/locxter/java-template/main/Main.java
wget -O ~/snap/netbeans/52/config/Templates/Classes/Class.java https://raw.githubusercontent.com/locxter/java-template/main/Class.java
mkdir -p ~/.config/codeblocks/UserTemplates/c-template
wget -O ~/.config/codeblocks/UserTemplates/c-template/c-template.cbp https://raw.githubusercontent.com/locxter/c-template/main/c-template.cbp
wget -O ~/.config/codeblocks/UserTemplates/c-template/c-template.layout https://raw.githubusercontent.com/locxter/c-template/main/c-template.layout
wget -O ~/.config/codeblocks/UserTemplates/c-template/main.c https://raw.githubusercontent.com/locxter/c-template/main/main.c
mkdir -p ~/.config/codeblocks/UserTemplates/cpp-template
wget -O ~/.config/codeblocks/UserTemplates/cpp-template/cpp-template.cbp https://raw.githubusercontent.com/locxter/cpp-template/main/cpp-template.cbp
wget -O ~/.config/codeblocks/UserTemplates/cpp-template/cpp-template.layout https://raw.githubusercontent.com/locxter/cpp-template/main/cpp-template.layout
wget -O ~/.config/codeblocks/UserTemplates/cpp-template/main.cpp https://raw.githubusercontent.com/locxter/cpp-template/main/main.cpp
mkdir -p ~/.config/codeblocks/UserTemplates/opencv-template
wget -O ~/.config/codeblocks/UserTemplates/opencv-template/main.cpp https://raw.githubusercontent.com/locxter/opencv-template/main/main.cpp
wget -O ~/.config/codeblocks/UserTemplates/opencv-template/opencv-template.cbp https://raw.githubusercontent.com/locxter/opencv-template/main/opencv-template.cbp
wget -O ~/.config/codeblocks/UserTemplates/opencv-template/opencv-template.layout https://raw.githubusercontent.com/locxter/opencv-template/main/opencv-template.layout
mkdir -p ~/.config/inkscape/templates
wget -O ~/.config/inkscape/templates/default.svg https://raw.githubusercontent.com/locxter/inkscape-template/main/default.svg
mkdir -p ~/.config/libreoffice/4/user/template
wget -O ~/.config/libreoffice/4/user/template/document-template.ott https://raw.githubusercontent.com/locxter/document-template/main/document-template.ott
wget -O ~/.config/libreoffice/4/user/template/report-template.ott https://raw.githubusercontent.com/locxter/report-template/main/report-template.ott
wget -O ~/.config/libreoffice/4/user/template/presentation-template.otp https://raw.githubusercontent.com/locxter/presentation-template/main/presentation-template.otp
wget -O ~/.config/libreoffice/4/user/template/spreadsheet-template.ots https://raw.githubusercontent.com/locxter/spreadsheet-template/main/spreadsheet-template.ots
wget -O ~/.config/libreoffice/4/user/template/timetable-template.ott https://raw.githubusercontent.com/locxter/timetable-template/main/timetable-template.ott
mkdir -p ~/.config/libreoffice/4/user/autocorr
cp libreoffice-autocorrect.dat ~/.config/libreoffice/4/user/autocorr/acor_de-DE.dat
mkdir -p ~/.local/share/rhythmbox
tee ~/.local/share/rhythmbox/rhythmdb.xml << EOF
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
mkdir -p ~/.local/share/gtksourceview-4/language-specs
wget -O ~/.local/share/gtksourceview-4/language-specs/arduino.lang https://raw.githubusercontent.com/kaochen/GtkSourceView-Arduino/master/arduino.lang
echo "################################################################################"
echo "#                          Setting my profile picture                          #"
echo "################################################################################"
cp profile-picture.jpeg ~/.face
echo "################################################################################"
echo "#              Adding apps to the dash and resorting the app grid              #"
echo "################################################################################"
gsettings set org.gnome.shell favorite-apps "['firefox_firefox.desktop', 'signal-desktop_signal-desktop.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop']"
gsettings set org.gnome.desktop.app-folders folder-children "['']"
gsettings set org.gnome.shell app-picker-layout "[]"
echo "################################################################################"
echo "#        Finished the setup, please check the console output for errors        #"
echo "#             that might occurred and reboot the system afterwards             #"
echo "################################################################################"
