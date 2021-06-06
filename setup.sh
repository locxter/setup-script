#!/bin/bash
echo "Updating package information."
apt update
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
echo "Setting up programming tools (git username and email, custom Code::Blocks templates)."
sudo -u $SUDOUSER git config --global user.name "locxter"
sudo -u $SUDOUSER git config --global user.email "54595101+locxter@users.noreply.github.com"
sudo -u $SUDOUSER mkdir -p ~/.config/codeblocks/UserTemplates/c-template
sudo -u $SUDOUSER wget -O ~/.config/codeblocks/UserTemplates/c-template/c-template.cbp https://raw.githubusercontent.com/locxter/c-template/main/c-template.cbp
sudo -u $SUDOUSER wget -O ~/.config/codeblocks/UserTemplates/c-template/c-template.layout https://raw.githubusercontent.com/locxter/c-template/main/c-template.layout
sudo -u $SUDOUSER wget -O ~/.config/codeblocks/UserTemplates/c-template/main.c https://raw.githubusercontent.com/locxter/c-template/main/main.c
sudo -u $SUDOUSER mkdir -p ~/.config/codeblocks/UserTemplates/cpp-template
sudo -u $SUDOUSER wget -O ~/.config/codeblocks/UserTemplates/cpp-template/cpp-template.cbp https://raw.githubusercontent.com/locxter/cpp-template/main/cpp-template.cbp
sudo -u $SUDOUSER wget -O ~/.config/codeblocks/UserTemplates/cpp-template/cpp-template.layout https://raw.githubusercontent.com/locxter/cpp-template/main/cpp-template.layout
sudo -u $SUDOUSER wget -O ~/.config/codeblocks/UserTemplates/cpp-template/main.cpp https://raw.githubusercontent.com/locxter/cpp-template/main/main.cpp
sudo -u $SUDOUSER mkdir -p ~/.config/codeblocks/UserTemplates/opencv-template
sudo -u $SUDOUSER wget -O ~/.config/codeblocks/UserTemplates/opencv-template/main.cpp https://raw.githubusercontent.com/locxter/opencv-template/main/main.cpp
sudo -u $SUDOUSER wget -O ~/.config/codeblocks/UserTemplates/opencv-template/opencv-template.cbp https://raw.githubusercontent.com/locxter/opencv-template/main/opencv-template.cbp
sudo -u $SUDOUSER wget -O ~/.config/codeblocks/UserTemplates/opencv-template/opencv-template.layout https://raw.githubusercontent.com/locxter/opencv-template/main/opencv-template.layout
echo "Setting up vector graphics editor (custom template)."
sudo -u $SUDOUSER mkdir -p ~/.config/inkscape/templates
sudo -u $SUDOUSER wget -O ~/.config/inkscape/templates/default.svg https://raw.githubusercontent.com/locxter/inkscape-template/main/default.svg
echo "Setting up text editor (Arduino and OpenSCAD language support, gedit-plugins)."
apt install gedit-plugins -y
sudo -u $SUDOUSER mkdir -p ~/.local/share/gtksourceview-4/language-specs
sudo -u $SUDOUSER wget -O ~/.local/share/gtksourceview-4/language-specs/arduino.lang https://raw.githubusercontent.com/kaochen/GtkSourceView-Arduino/master/arduino.lang
sudo -u $SUDOUSER wget -O ~/.local/share/gtksourceview-4/language-specs/scad.lang https://raw.githubusercontent.com/AndrewJamesTurner/openSCAD-lang-file/master/scad.lang
echo "Setting up DNS-over-TLS (BlahDNS)."
mkdir -p /etc/systemd/resolved.conf.d
printf "[Resolve]\nDNS=78.46.244.143#dot-de.blahdns.com\nDNSOverTLS=yes" > /etc/systemd/resolved.conf.d/upstream.conf
mkdir -p /etc/NetworkManager/conf.d
printf "[main]\ndns=none\nsystemd-resolved=false" > /etc/NetworkManager/conf.d/nodns.conf
echo "Cleaning package cache."
apt clean
echo "Setup complete."
