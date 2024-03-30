#!/bin/bash
echo "################################################################################"
echo "#                              Starting the setup                              #"
echo "################################################################################"
echo "################################################################################"
echo "#          Add data drive scripts and programs to this computer?[y/N]          #"
echo "################################################################################"
read REPLY
if [[ $REPLY =~ [Yy]+ ]]
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
if [[ $REPLY =~ [Yy]+ ]]
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
sudo apt purge brltty gnome-calendar gnome-contacts geary gnome-weather baobab seahorse com.github.donadigo.eddy popsicle popsicle-gtk totem -y
sudo apt full-upgrade -y
sudo apt install libserialport0 patchelf python3-serial ubuntu-restricted-extras qt5-style-plugins snapd git build-essential gdb cmake qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils android-sdk-platform-tools python3-pip htop lm-sensors neofetch minicom curl mat2 gedit-plugins bleachbit dconf-editor texlive-latex-extra pdfarranger gnome-boxes tilp2 cura inkscape kiwix freecad arduino xournalpp musescore3 mixxx gnome-feeds audacity shotcut ffmpeg easytag solaar kicad vlc rhythmbox -y
if $DATA_DRIVE
then
    sudo apt install syncthing -y
fi
if $BACKUP_DRIVE
then
    sudo apt install deja-dup -y
fi
sudo apt autoremove --purge -y
sudo apt autoclean
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
sudo flatpak install flathub org.gnome.NetworkDisplays net.ankiweb.Anki org.signal.Signal org.telegram.desktop org.standardnotes.standardnotes com.tutanota.Tutanota -y
sudo snap install pop-themes
sudo snap install chromium
sudo snap install node --classic
sudo snap install codium --classic
sudo snap install intellij-idea-community --classic
sudo snap install android-studio --classic
for i in $(snap connections | grep gtk-common-themes:gtk-3-themes | awk '{print $2}'); do sudo snap connect $i pop-themes:gtk-3-themes; done
for i in $(snap connections | grep gtk-common-themes:gtk-2-themes | awk '{print $2}'); do sudo snap connect $i pop-themes:gtk-2-themes; done
for i in $(snap connections | grep gtk-common-themes:icon-themes | awk '{print $2}'); do sudo snap connect $i pop-themes:icon-themes; done
pip3 install trimesh
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
curl -s "https://get.sdkman.io" | bash
source "/home/locxter/.sdkman/bin/sdkman-init.sh"
sdk install java
sdk install maven
sdk install kotlin
sdk install gradle
wget http://packages.linuxmint.com/pool/main/w/webapp-manager/webapp-manager_1.3.4_all.deb
sudo apt install ./webapp-manager_1.3.4_all.deb -y
rm webapp-manager_1.3.4_all.deb
mkdir -p ~/.local/share/applications
unzip -o webapp-config-1.zip -d ~/.local/share/applications
mkdir -p ~/.local/share/ice
unzip -o webapp-config-2.zip -d ~/.local/share/ice
echo "################################################################################"
echo "#                       Configuring scripts and programs                       #"
echo "################################################################################"
sudo usermod -a -G dialout locxter
sudo usermod -a -G tty locxter
sudo patchelf --add-needed libserialport.so.0 /usr/lib/x86_64-linux-gnu/liblistSerialsj.so.1.4.0
sudo mkdir -p /etc/minicom
sudo cp minicom-config.dfl /etc/minicom/minirc.dfl
echo "export QT_QPA_PLATFORMTHEME=gtk2" >> ~/.profile
mkdir -p ~/.config/autostart
if $DATA_DRIVE
then
    tee ~/.config/autostart/mount-data-drive.desktop << EOF
[Desktop Entry]
Type=Application
Exec=bash -c "sleep 5; if ! test -e /media/locxter/data; then while ! udisksctl unlock -b $LOCKED_DATA_DRIVE --key-file <(zenity --password --title='Mount data drive' | tr -d '\n'); do zenity --error --text='Wrong password'; done; udisksctl mount -b $UNLOCKED_DATA_DRIVE; syncthing -no-browser; fi"
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Mount data drive
EOF
    cp start-file-sync.desktop ~/.config/autostart/start-file-sync.desktop
fi
if $BACKUP_DRIVE
then
    tee ~/.config/autostart/mount-backup-drive.desktop << EOF
[Desktop Entry]
Type=Application
Exec=bash -c "sleep 5; if ! test -e /media/locxter/backup; then while ! udisksctl unlock -b $LOCKED_BACKUP_DRIVE --key-file <(zenity --password --title='Mount backup drive' | tr -d '\n'); do zenity --error --text='Wrong password'; done; udisksctl mount -b $UNLOCKED_BACKUP_DRIVE; while ! test -e /media/locxter/data; do zenity --error --text='Data drive not mounted'; done; deja-dup --backup; fi"
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Mount backup drive
EOF
    cp start-backup.desktop ~/.config/autostart/start-backup.desktop
fi
cp .gitconfig ~/.gitconfig
mkdir -p ~/.local/share/nautilus/scripts
unzip -o nautilus-scripts.zip -d ~/.local/share/nautilus/scripts
mkdir -p ~/.config/VSCodium
unzip -o vscodium-config.zip -d ~/.config/VSCodium
codium --install-extension esbenp.prettier-vscode --install-extension ms-vscode.cmake-tools --install-extension ms-vscode.cpptools --install-extension ms-vscode.vscode-serial-monitor --install-extension panicbit.cargo --install-extension rangav.vscode-thunder-client --install-extension rust-lang.rust-analyzer --install-extension serayuzgur.crates --install-extension svelte.svelte-vscode --install-extension twxs.cmake --install-extension Tyriar.sort-lines --install-extension vsciot-vscode.vscode-arduino
mkdir -p ~/.arduino15
cp arduino-config.txt ~/.arduino15/preferences.txt
mkdir -p ~/Arduino/tools
wget -O ESP8266LittleFS-2.6.0.zip https://github.com/earlephilhower/arduino-esp8266littlefs-plugin/releases/download/2.6.0/ESP8266LittleFS-2.6.0.zip
unzip -o ESP8266LittleFS-2.6.0.zip -d ~/Arduino/tools
rm -rf ESP8266LittleFS-2.6.0.zip
mkdir -p ~/Arduino/tools/ESP32FS/tool
wget -O esp32fs.zip https://github.com/lorol/arduino-esp32fs-plugin/releases/download/2.0.7/esp32fs.zip
unzip -o esp32fs.zip -d ~/Arduino/tools/ESP32FS/tool
rm -rf esp32fs.zip
mkdir -p ~/.local/share/cura
unzip -o cura-config-1.zip -d ~/.local/share/cura
mkdir -p ~/.config/cura
unzip -o cura-config-2.zip -d ~/.config/cura
mkdir -p ~/.mozilla/firefox
firefox -createProfile "locxter /home/locxter/.mozilla/firefox/locxter"
unzip -o firefox-profile.zip -d ~/.mozilla/firefox/locxter
cp firefox-profiles.ini ~/.mozilla/firefox/profiles.ini
mkdir -p ~/.config/inkscape/templates
cp inkscape-template.svg ~/.config/inkscape/templates/default.svg
mkdir -p ~/.config/libreoffice/4/user/template
cp libreoffice-document-template.ott ~/.config/libreoffice/4/user/template/document-template.ott
cp libreoffice-report-template.ott ~/.config/libreoffice/4/user/template/report-template.ott
cp libreoffice-presentation-template.otp ~/.config/libreoffice/4/user/template/presentation-template.otp
cp libreoffice-spreadsheet-template.ots ~/.config/libreoffice/4/user/template/spreadsheet-template.ots
mkdir -p ~/.config/libreoffice/4/user/autocorr
cp libreoffice-autocorrect.dat ~/.config/libreoffice/4/user/autocorr/acor_de-DE.dat
mkdir -p ~/.config/xournalpp
unzip -o xournalpp-config.zip -d ~/.config/xournalpp
mkdir -p ~/.local/share/rhythmbox
cp rhythmbox-database.xml ~/.local/share/rhythmbox/rhythmdb.xml
if $DATA_DRIVE
then
    rm -rf ~/.local/share/gnome-boxes
    ln -s /media/locxter/data/tech-stuff/gnome-boxes/ ~/.local/share/gnome-boxes
    rm -rf ~/Documents
    ln -s /media/locxter/data/documents/ ~/Documents
    rm -rf ~/Downloads
    ln -s /media/locxter/data/downloads/ ~/Downloads
    rm -rf ~/Music
    ln -s /media/locxter/data/music/ ~/Music
    rm -rf ~/Pictures
    ln -s /media/locxter/data/pictures/ ~/Pictures
    rm -rf ~/Videos
    ln -s /media/locxter/data/videos/ ~/Videos
fi
echo "################################################################################"
echo "#                      Tweaking the desktop to my likings                      #"
echo "################################################################################"
sudo cp wallpaper.jpeg /usr/share/backgrounds/wallpaper.jpeg
gsettings set org.gnome.shell app-picker-layout "[{'ca.desrt.dconf-editor.desktop': <{'position': <0>}>, 'Pop-Office': <{'position': <1>}>, 'org.gnome.DejaDup.desktop': <{'position': <2>}>, 'syncthing-start.desktop': <{'position': <3>}>, 'syncthing-ui.desktop': <{'position': <4>}>, 'codium_codium.desktop': <{'position': <5>}>, 'org.gnome.Calculator.desktop': <{'position': <6>}>, 'org.gnome.gedit.desktop': <{'position': <7>}>, 'arduino.desktop': <{'position': <8>}>, 'audacity.desktop': <{'position': <9>}>, 'org.bleachbit.BleachBit.desktop': <{'position': <10>}>, 'org.gnome.Boxes.desktop': <{'position': <11>}>, 'bleachbit-root.desktop': <{'position': <12>}>, 'org.gnome.NetworkDisplays.desktop': <{'position': <13>}>, 'easytag.desktop': <{'position': <14>}>, 'org.gabmus.gfeeds.desktop': <{'position': <15>}>, 'htop.desktop': <{'position': <16>}>, 'display-im6.q16.desktop': <{'position': <17>}>, 'com.ultimaker.cura.desktop': <{'position': <18>}>, 'org.inkscape.Inkscape.desktop': <{'position': <19>}>, 'org.kicad.kicad.desktop': <{'position': <20>}>, 'org.kicad.gerbview.desktop': <{'position': <21>}>}, {'org.kicad.bitmap2component.desktop': <{'position': <0>}>, 'org.kicad.pcbcalculator.desktop': <{'position': <1>}>, 'org.kicad.pcbnew.desktop': <{'position': <2>}>, 'org.kicad.eeschema.desktop': <{'position': <3>}>, 'org.kiwix.desktop.desktop': <{'position': <4>}>, 'intellij-idea-community_intellij-idea-community.desktop': <{'position': <5>}>, 'minicom.desktop': <{'position': <6>}>, 'org.mixxx.Mixxx.desktop': <{'position': <7>}>, 'mscore3.desktop': <{'position': <8>}>, 'com.github.jeromerobert.pdfarranger.desktop': <{'position': <9>}>, 'org.shotcut.Shotcut.desktop': <{'position': <10>}>, 'solaar.desktop': <{'position': <11>}>, 'com.tutanota.Tutanota.desktop': <{'position': <12>}>, 'tilp.desktop': <{'position': <13>}>, 'vlc.desktop': <{'position': <14>}>, 'com.github.xournalpp.xournalpp.desktop': <{'position': <15>}>, 'org.zealdocs.Zeal.desktop': <{'position': <16>}>, 'org.signal.Signal.desktop': <{'position': <17>}>, 'chromium_chromium.desktop': <{'position': <18>}>, 'freecad.desktop': <{'position': <19>}>, 'net.ankiweb.Anki.desktop': <{'position': <20>}>, 'org.standardnotes.standardnotes.desktop': <{'position': <21>}>, 'org.telegram.desktop.desktop': <{'position': <22>}>, 'org.gnome.FileRoller.desktop': <{'position': <23>}>}, {'webapp-manager.desktop': <{'position': <0>}>, 'gucharmap.desktop': <{'position': <1>}>, 'simple-scan.desktop': <{'position': <2>}>, 'org.gnome.Evince.desktop': <{'position': <3>}>, 'org.gnome.Extensions.desktop': <{'position': <4>}>, 'org.gnome.font-viewer.desktop': <{'position': <5>}>, 'yelp.desktop': <{'position': <6>}>, 'org.gnome.eog.desktop': <{'position': <7>}>, 'pop-cosmic-applications.desktop': <{'position': <8>}>, 'pop-cosmic-workspaces.desktop': <{'position': <9>}>, 'info.desktop': <{'position': <10>}>, 'org.gnome.Totem.desktop': <{'position': <11>}>, 'nm-connection-editor.desktop': <{'position': <12>}>, 'org.gnome.DiskUtility.desktop': <{'position': <13>}>, 'gnome-language-selector.desktop': <{'position': <14>}>, 'org.gnome.PowerStats.desktop': <{'position': <15>}>, 'gnome-session-properties.desktop': <{'position': <16>}>, 'gnome-system-monitor.desktop': <{'position': <17>}>, 'libreoffice-startcenter.desktop': <{'position': <18>}>, 'libreoffice-calc.desktop': <{'position': <19>}>, 'libreoffice-draw.desktop': <{'position': <20>}>, 'libreoffice-impress.desktop': <{'position': <21>}>, 'libreoffice-math.desktop': <{'position': <22>}>, 'libreoffice-writer.desktop': <{'position': <23>}>}]"
gsettings set org.gnome.shell favorite-apps "['pop-cosmic-launcher.desktop', 'firefox.desktop', 'com.tutanota.Tutanota.desktop', 'org.standardnotes.standardnotes.desktop', 'webapp-Notion6139.desktop', 'webapp-WhatsApp6317.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop']"
gsettings set org.gnome.shell enabled-extensions "['pop-cosmic@system76.com', 'pop-shell@system76.com', 'system76-power@system76.com', 'ubuntu-appindicators@ubuntu.com', 'cosmic-dock@system76.com', 'cosmic-workspaces@system76.com', 'popx11gestures@system76.com']"
gsettings set org.gnome.shell disabled-extensions "['ding@rastersoft.com']"
gsettings set org.gnome.shell.extensions.pop-shell tile-by-default true
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 36
gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'LEFT'
gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false
gsettings set org.gnome.shell.extensions.dash-to-dock intellihide true
gsettings set org.gnome.shell.extensions.dash-to-dock show-mounts false
gsettings set org.gnome.mutter center-new-windows true
gsettings set org.gnome.mutter dynamic-workspaces false
gsettings set org.gnome.desktop.wm.preferences num-workspaces 10
gsettings set org.gnome.desktop.background picture-uri 'file:///usr/share/backgrounds/wallpaper.jpeg'
gsettings set org.gnome.desktop.background picture-uri-dark 'file:///usr/share/backgrounds/wallpaper.jpeg'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface gtk-theme 'Pop-dark'
gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:close'
gsettings set org.gnome.shell.extensions.pop-shell activate-launcher "['<Super>']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-1 "['<Super>Home', '<Super>1']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-2 "['<Super>2']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-3 "['<Super>3']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-4 "['<Super>4']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-5 "['<Super>5']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-6 "['<Super>6']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-7 "['<Super>7']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-8 "['<Super>8']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-9 "['<Super>9']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-10 "['<Super>0']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-1 "['<Shift><Super>Home', '<Shift><Super>1']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-2 "['<Shift><Super>2']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-3 "['<Shift><Super>3']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-4 "['<Shift><Super>4']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-5 "['<Shift><Super>5']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-6 "['<Shift><Super>6']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-7 "['<Shift><Super>7']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-8 "['<Shift><Super>8']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-9 "['<Shift><Super>9']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-10 "['<Shift><Super>0']"
gsettings set org.gnome.desktop.wm.keybindings switch-applications "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-applications-backward "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Super>Tab', '<Alt>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-windows-backward "['<Shift><Super>Tab', '<Shift><Alt>Tab']"
gsettings set org.gnome.shell.window-switcher current-workspace-only false
echo "################################################################################"
echo "#                           Configuring the firewall                           #"
echo "################################################################################"
sudo ufw enable
if $DATA_DRIVE
then
    sudo ufw allow syncthing
fi
echo "################################################################################"
echo "#                Configuring DNS over TLS and mac randomization                #"
echo "################################################################################"
sudo systemctl stop NetworkManager
sudo mkdir -p /etc/NetworkManager/conf.d
sudo unzip -o networkmanager-config.zip -d /etc/NetworkManager/conf.d
sudo mkdir -p /etc/systemd
sudo cp systemd-resolved.conf /etc/systemd/resolved.conf
sudo systemctl enable systemd-resolved
sudo systemctl start systemd-resolved
sudo systemctl start NetworkManager
sleep 30
echo "################################################################################"
echo "#        Finished the setup, please check the console output for errors        #"
echo "#             that might occurred and reboot the system afterwards             #"
echo "################################################################################"
