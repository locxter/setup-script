#!/bin/bash
echo "Started the setup."
apt update
apt full-upgrade -y
apt install totem rhythmbox deja-dup simple-scan libreoffice bleachbit libimage-exiftool-perl git gedit-plugins arduino codeblocks openscad cura inkscape -y
apt clean
printf "[user]\nname=locxter\nemail=54595101+locxter@users.noreply.github.com" > /home/locxter/.gitconfig
chown -R locxter:locxter /home/locxter/.gitconfig
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
chown -R locxter:locxter /home/locxter/.config
mkdir -p /home/locxter/.local/share/gtksourceview-4/language-specs
wget -O /home/locxter/.local/share/gtksourceview-4/language-specs/arduino.lang https://raw.githubusercontent.com/kaochen/GtkSourceView-Arduino/master/arduino.lang
wget -O /home/locxter/.local/share/gtksourceview-4/language-specs/scad.lang https://raw.githubusercontent.com/AndrewJamesTurner/openSCAD-lang-file/master/scad.lang
chown -R locxter:locxter /home/locxter/.local
mkdir -p /etc/systemd/resolved.conf.d
printf "[Resolve]\nDNS=78.46.244.143#dot-de.blahdns.com\nDNSOverTLS=yes" > /etc/systemd/resolved.conf.d/upstream.conf
mkdir -p /etc/NetworkManager/conf.d
printf "[main]\ndns=none\nsystemd-resolved=false" > /etc/NetworkManager/conf.d/nodns.conf
echo "Finished the setup successfully."
