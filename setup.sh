#!/bin/bash
echo "Started the setup."
read -e -p "Add backup stuff to this computer? [Y/n]"
echo $REPLY
if [[ $REPLY == [Yy]* ]]
then
    BACKUP_STUFF=true
else
    BACKUP_STUFF=false
fi
apt update
apt full-upgrade -y
apt install totem rhythmbox simple-scan libreoffice bleachbit libimage-exiftool-perl syncthing git gedit-plugins arduino codeblocks openscad cura inkscape -y
if [ "$BACKUP_STUFF" = true ]
then
    apt install deja-dup -y
fi
apt clean
printf "[user]\nname=locxter\nemail=54595101+locxter@users.noreply.github.com" > /home/locxter/.gitconfig
chown -R locxter:locxter /home/locxter/.gitconfig
if [ "$BACKUP_STUFF" = true ]
then
    mkdir -p /home/locxter/.config/autostart
    cat << EOF > /home/locxter/.config/autostart/mount-backup-drive.desktop
[Desktop Entry]
Type=Application
Exec=bash -c "if ! test -e /media/locxter/backup; then until udisksctl unlock -b /dev/sdb1 --key-file <(zenity --password --title='Mount backup drive' | tr -d '\n'); do zenity --error --text='Wrong password.'; done; udisksctl mount -b /dev/dm-4 && deja-dup --backup; fi"
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Mount backup drive
EOF
    cat << EOF > /home/locxter/.config/autostart/mount-data-drive.desktop
[Desktop Entry]
Type=Application
Exec=bash -c "if ! test -e /media/locxter/data; then until udisksctl unlock -b /dev/sda1 --key-file <(zenity --password --title='Mount data drive' | tr -d '\n'); do zenity --error --text='Wrong password'; done; udisksctl mount -b /dev/dm-3 && syncthing -no-browser; fi"
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Mount data drive
EOF
fi
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
chown -R locxter:locxter /home/locxter/.config
mkdir -p /home/locxter/.local/share/gtksourceview-4/language-specs
wget -O /home/locxter/.local/share/gtksourceview-4/language-specs/arduino.lang https://raw.githubusercontent.com/kaochen/GtkSourceView-Arduino/master/arduino.lang
wget -O /home/locxter/.local/share/gtksourceview-4/language-specs/scad.lang https://raw.githubusercontent.com/AndrewJamesTurner/openSCAD-lang-file/master/scad.lang
chown -R locxter:locxter /home/locxter/.local
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

apt install deja-dup -y
