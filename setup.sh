#!/bin/bash
echo "Started the setup."
read -p "Add data scripts and programs to this computer? [Y/n] " REPLY
if [[ $REPLY == [Yy]* ]]
then
    DATA=true
    read -p "Enter the device representing the locked data drive: " REPLY
    LOCKED_DATA_DRIVE=$REPLY
    read -p "Enter the device representing the unlocked data drive: " REPLY
    UNLOCKED_DATA_DRIVE=$REPLY
else
    DATA=false
fi
read -p "Add backup scripts and programs to this computer? [Y/n] " REPLY
if [[ $REPLY == [Yy]* ]]
then
    BACKUP=true
    read -p "Enter the device representing the locked backup drive: " REPLY
    LOCKED_BACKUP_DRIVE=$REPLY
    read -p "Enter the device representing the unlocked backup drive: " REPLY
    UNLOCKED_BACKUP_DRIVE=$REPLY
else
    BACKUP=false
fi
apt update
apt full-upgrade -y
apt install totem rhythmbox simple-scan libreoffice bleachbit libimage-exiftool-perl lm-sensors git default-jdk gedit-plugins arduino codeblocks freecad cura inkscape -y
if [ "$DATA" = true ]
then
    apt install syncthing -y
fi
if [ "$BACKUP" = true ]
then
    apt install deja-dup -y
fi
apt autoremove --purge
apt clean
snap install netbeans --classic
if [ "$DATA" = true ]
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
if [ "$BACKUP" = true ]
then
    mkdir -p /home/locxter/.config/autostart
    cat << EOF > /home/locxter/.config/autostart/mount-backup-drive.desktop
[Desktop Entry]
Type=Application
Exec=bash -c "if ! test -e /media/locxter/backup; then while ! udisksctl unlock -b $LOCKED_BACKUP_DRIVE --key-file <(zenity --password --title='Mount backup drive' | tr -d '\n'); do zenity --error --text='Wrong password.'; done; udisksctl mount -b $UNLOCKED_BACKUP_DRIVE; while ! test -e /media/locxter/data; do zenity --error --text='Data drive not mounted.'; done; deja-dup --backup; fi"
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
mkdir -p /home/locxter/.config/inkscape/templates
wget -O /home/locxter/.config/inkscape/templates/default.svg https://raw.githubusercontent.com/locxter/inkscape-template/main/default.svg
mkdir -p /home/locxter/.config/libreoffice/4/user/template
wget -O /home/locxter/.config/libreoffice/4/user/template/document-template.ott https://raw.githubusercontent.com/locxter/document-template/main/document-template.ott
wget -O /home/locxter/.config/libreoffice/4/user/template/report-template.ott https://raw.githubusercontent.com/locxter/report-template/main/report-template.ott
wget -O /home/locxter/.config/libreoffice/4/user/template/presentation-template.otp https://raw.githubusercontent.com/locxter/presentation-template/main/presentation-template.otp
wget -O /home/locxter/.config/libreoffice/4/user/template/spreadsheet-template.ots https://raw.githubusercontent.com/locxter/spreadsheet-template/main/spreadsheet-template.ots
mkdir -p /home/locxter/.local/share/gtksourceview-4/language-specs
wget -O /home/locxter/.local/share/gtksourceview-4/language-specs/arduino.lang https://raw.githubusercontent.com/kaochen/GtkSourceView-Arduino/master/arduino.lang
chown -R locxter:locxter /home/locxter
mkdir -p /etc/systemd/resolved.conf.d
cat << EOF > /etc/systemd/resolved.conf.d/upstream.conf
[Resolve]
DNS=78.46.244.143#dot-de.blahdns.com
DNSOverTLS=yes
EOF
mkdir -p /etc/NetworkManager/conf.d
cat << EOF > /etc/NetworkManager/conf.d/nodns.conf
[main]
dns=none
systemd-resolved=false
EOF
echo "Finished the setup successfully."
