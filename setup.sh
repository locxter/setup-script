#!/bin/bash
echo "Updating package information."
sudo apt update
echo "Installing basic tools (totem, rhythmbox, deja-dup, bleachbit, libimage-exiftool-perl)."
sudo apt install totem rhythmbox deja-dup bleachbit libimage-exiftool-perl -y
echo "Installing office tools (simple-scan, pandoc, texlive-full, libreoffice)."
sudo apt install simple-scan pandoc texlive-full libreoffice -y
echo "Installing programming tools (arduino, codeblocks, git)."
sudo apt install arduino codeblocks git -y
echo "Installing 3d printing tools (openscad, cura)."
sudo apt install openscad cura -y
echo "Installing vector graphics editor (inkscape)."
sudo apt install inkscape -y
echo "Setting up programming tools (git username and email, custom Code::Blocks templates)."
git config --global user.name "locxter"
git config --global user.email "54595101+locxter@users.noreply.github.com"
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
echo "Setting up vector graphics editor (custom template)."
mkdir -p ~/.config/inkscape/templates
wget -O ~/.config/inkscape/templates/default.svg https://raw.githubusercontent.com/locxter/inkscape-template/main/default.svg
echo "Setting up text editor (Arduino and OpenSCAD language support, gedit-plugins)."
sudo apt install gedit-plugins -y
mkdir -p ~/.local/share/gtksourceview-4/language-specs
wget -O ~/.local/share/gtksourceview-4/language-specs/arduino.lang https://raw.githubusercontent.com/kaochen/GtkSourceView-Arduino/master/arduino.lang
wget -O ~/.local/share/gtksourceview-4/language-specs/scad.lang https://raw.githubusercontent.com/AndrewJamesTurner/openSCAD-lang-file/master/scad.lang
echo "Setting up DNS-over-TLS (BlahDNS)."
sudo mkdir -p /etc/systemd/resolved.conf.d
sudo sh -c "printf '[Resolve]\nDNS=78.46.244.143#dot-de.blahdns.com\nDNSOverTLS=yes' > /etc/systemd/resolved.conf.d/upstream.conf"
sudo mkdir -p /etc/NetworkManager/conf.d
sudo sh -c "printf '[main]\ndns=none\nsystemd-resolved=false' > /etc/NetworkManager/conf.d/nodns.conf"
echo "Cleaning package cache."
sudo apt clean
echo "Setup complete."
