#!/bin/bash
echo "Updating package information."
apt update
echo "Updating system"
apt full-upgrade -y
echo "Installing basic tools (totem, rhythmbox, deja-dup, bleachbit, libimage-exiftool-perl)."
apt install totem rhythmbox deja-dup bleachbit libimage-exiftool-perl -y
echo "Installing office tools (simple-scan, pandoc, texlive-full, libreoffice)."
apt install simple-scan pandoc texlive-full libreoffice -y
echo "Installing programming tools (arduino, codeblocks, git)."
apt install arduino codeblocks git -y
echo "Installing 3d printing tools (openscad, cura)."
apt install openscad cura -y
echo "Installing vector graphics editor (inkscape)."
apt install inkscape -y
echo "Setting up programming tools (Git name and email, custom Code::Blocks templates)."
printf "[user]\nname=locxter\nemail=54595101+locxter@users.noreply.github.com" > /home/locxter/.gitconfig
chown -R locxter:locxter /home/locxter/.gitconfig
mkdir -p /home/locxter/.config/codeblocks/UserTemplates/c-template
chown -R locxter:locxter /home/locxter/.config
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
echo "Setting up vector graphics editor (custom template)."
mkdir -p /home/locxter/.config/inkscape/templates
wget -O /home/locxter/.config/inkscape/templates/default.svg https://raw.githubusercontent.com/locxter/inkscape-template/main/default.svg
echo "Setting up text editor (Arduino and OpenSCAD language support, Plugins)."
apt install gedit-plugins -y
mkdir -p /home/locxter/.local/share/gtksourceview-4/language-specs
chown -R locxter:locxter /home/locxter/.local
wget -O /home/locxter/.local/share/gtksourceview-4/language-specs/arduino.lang https://raw.githubusercontent.com/kaochen/GtkSourceView-Arduino/master/arduino.lang
wget -O /home/locxter/.local/share/gtksourceview-4/language-specs/scad.lang https://raw.githubusercontent.com/AndrewJamesTurner/openSCAD-lang-file/master/scad.lang
echo "Setting up DNS-over-TLS (BlahDNS)."
mkdir -p /etc/systemd/resolved.conf.d
printf "[Resolve]\nDNS=78.46.244.143#dot-de.blahdns.com\nDNSOverTLS=yes" > /etc/systemd/resolved.conf.d/upstream.conf
mkdir -p /etc/NetworkManager/conf.d
printf "[main]\ndns=none\nsystemd-resolved=false" > /etc/NetworkManager/conf.d/nodns.conf
echo "Cleaning package cache."
apt clean
echo "Setup complete."
