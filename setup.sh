#!/bin/bash
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
curl -o ~/.config/codeblocks/UserTemplates/c-template/c-template.cbp https://raw.githubusercontent.com/locxter/c-template/main/c-template.cbp
curl -o ~/.config/codeblocks/UserTemplates/c-template/c-template.layout https://raw.githubusercontent.com/locxter/c-template/main/c-template.layout
curl -o ~/.config/codeblocks/UserTemplates/c-template/main.c https://raw.githubusercontent.com/locxter/c-template/main/main.c
curl -o ~/.config/codeblocks/UserTemplates/cpp-template/cpp-template.cbp https://raw.githubusercontent.com/locxter/cpp-template/main/cpp-template.cbp
curl -o ~/.config/codeblocks/UserTemplates/cpp-template/cpp-template.layout https://raw.githubusercontent.com/locxter/cpp-template/main/cpp-template.layout
curl -o ~/.config/codeblocks/UserTemplates/cpp-template/main.cpp https://raw.githubusercontent.com/locxter/cpp-template/main/main.cpp
curl -o ~/.config/codeblocks/UserTemplates/opencv-template/main.cpp https://raw.githubusercontent.com/locxter/opencv-template/main/main.cpp
curl -o ~/.config/codeblocks/UserTemplates/opencv-template/opencv-template.cbp https://raw.githubusercontent.com/locxter/opencv-template/main/opencv-template.cbp
curl -o ~/.config/codeblocks/UserTemplates/opencv-template/opencv-template.layout https://raw.githubusercontent.com/locxter/opencv-template/main/opencv-template.layout
echo "Setting up vector graphics editor."
cp default.svg ~/.config/inkscape/templates/default.svg
curl -o ~/.config/inkscape/templates/default.svg https://raw.githubusercontent.com/locxter/inkscape-template/main/default.svg
echo "Setting up text editor (Arduino and OpenSCAD language support, gedit-plugins)."
sudo apt install gedit-plugins -y
curl -o ~/.local/share/gtksourceview-4/language-specs/arduino.lang https://raw.githubusercontent.com/kaochen/GtkSourceView-Arduino/master/arduino.lang
curl -o ~/.local/share/gtksourceview-4/language-specs/scad.lang https://raw.githubusercontent.com/AndrewJamesTurner/openSCAD-lang-file/master/scad.lang
echo "Setting up DNS-over-TLS."
sudo cat > /etc/systemd/resolved.conf.d/upstream.conf << EOF
[Resolve]
DNS=78.46.244.143#dot-de.blahdns.com
DNSOverTLS=yes
EOF
sudo cat > /etc/NetworkManager/conf.d/nodns.conf << EOF
[main]
dns=none
systemd-resolved=false 
EOF
echo "Setup complete."
