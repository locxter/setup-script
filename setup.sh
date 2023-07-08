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
sudo flatpak uninstall --all --delete-data
wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg | gpg --dearmor | sudo dd of=/usr/share/keyrings/vscodium-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/vscodium-keyring.gpg]   https://download.vscodium.com/debs vscodium main" | sudo tee /etc/apt/sources.list.d/vscodium.list
wget -qO - https://deb.nodesource.com/gpgkey/nodesource.gpg.key | gpg --dearmor | sudo dd of=/usr/share/keyrings/nodesource-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/nodesource-keyring.gpg] https://deb.nodesource.com/node_18.x jammy main" | sudo tee /etc/apt/sources.list.d/nodesource.list
echo "deb-src [arch=amd64 signed-by=/usr/share/keyrings/nodesource-keyring.gpg] https://deb.nodesource.com/node_18.x jammy main" | sudo tee -a /etc/apt/sources.list.d/nodesource.list
wget -qO - https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor | sudo dd of=/usr/share/keyrings/signal-desktop-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main" | sudo tee /etc/apt/sources.list.d/signal-desktop.list
wget -qO - https://s3.eu-central-1.amazonaws.com/jetbrains-ppa/0xA6E8698A.pub.asc | gpg --dearmor | sudo tee /usr/share/keyrings/jetbrains-ppa-archive-keyring.gpg > /dev/null
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/jetbrains-ppa-archive-keyring.gpg] http://jetbrains-ppa.s3-website.eu-central-1.amazonaws.com any main" | sudo tee /etc/apt/sources.list.d/jetbrains-ppa.list > /dev/null
curl -s "https://get.sdkman.io" | bash
source "/home/locxter/.sdkman/bin/sdkman-init.sh"
sdk install java
sdk install maven
sdk install kotlin
sdk install gradle
sudo apt update
sudo apt purge *flatpak* *xfwm4*  *metacity* *compiz* xfce4-appfinder mintbackup mintstick mintwelcome warpinator hexchat drawing seahorse xfce4-dict baobab thingy sticky mintdesktop light-locker-settings pix thunderbird timeshift -y
sudo apt full-upgrade -y
sudo apt install libserialport0 patchelf python3-serial mint-meta-codecs git build-essential gdb cmake rust-all rust-src nodejs android-sdk-platform-tools python3-pip bspwm htop minicom mat2 bleachbit dconf-editor workrave pdfarranger gnome-boxes tilp2 cura inkscape anki kiwix freecad arduino chromium codium intellij-idea-community signal-desktop telegram-desktop xournalpp musescore3 scribus mixxx -y
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
pip3 install trimesh
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
sudo cp java-fix.sh /etc/profile.d/java-fix.sh
mkdir -p ~/.config/autostart
unzip -o autostart.zip -d ~/.config/autostart
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
mkdir -p ~/.config/Thunar
unzip -o thunar-config.zip -d ~/.config/Thunar
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
gsettings set org.workrave.breaks.daily-limit max-preludes 1
gsettings set org.workrave.breaks.micro-pause max-preludes 1
gsettings set org.workrave.breaks.rest-break max-preludes 1
gsettings set org.workrave.sound enabled false
gsettings set org.workrave.sound volume 0
gsettings set org.workrave.timers.daily-limit limit 28800
gsettings set org.workrave.timers.daily-limit snooze 900
gsettings set org.workrave.timers.micro-pause auto-reset 30
gsettings set org.workrave.timers.micro-pause limit 1770
gsettings set org.workrave.timers.micro-pause snooze 0
gsettings set org.workrave.timers.rest-break auto-reset 150
gsettings set org.workrave.timers.rest-break limit 3450
gsettings set org.workrave.timers.rest-break snooze 0
gsettings set org.workrave.gui.breaks.daily-limit skippable-break false
gsettings set org.workrave.gui.breaks.micro-pause ignorable-break false
gsettings set org.workrave.gui.breaks.micro-pause skippable-break false
gsettings set org.workrave.gui.breaks.rest-break enable-shutdown false
gsettings set org.workrave.gui.breaks.rest-break exercises 5
gsettings set org.workrave.gui.breaks.rest-break ignorable-break false
gsettings set org.workrave.gui.breaks.rest-break skippable-break false
gsettings set org.workrave.gui trayicon-enabled true
gsettings set org.workrave.gui.main-window enabled false
gsettings set org.workrave.general usage-mode 1e
mkdir -p ~/.local/share/onboard/themes/
cp onboard.theme ~/.local/share/onboard/themes/locxter.theme
gsettings set org.onboard layout '/usr/share/onboard/layouts/Small.onboard'
gsettings set org.onboard schema-version '2.3'
gsettings set org.onboard start-minimized true
gsettings set org.onboard system-theme-associations "{'HighContrast': 'HighContrast', 'HighContrastInverse': 'HighContrastInverse', 'LowContrast': 'LowContrast', 'ContrastHighInverse': 'HighContrastInverse', 'Default': '', 'Mint-Y-Dark-Aqua': '/home/locxter/.local/share/onboard/themes/locxter.theme'}"
gsettings set org.onboard theme '/home/locxter/.local/share/onboard/themes/locxter.theme'
gsettings set org.onboard use-system-defaults false
gsettings set org.onboard.window docking-enabled true
gsettings set org.onboard.window docking-monitor 'primary'
gsettings set org.onboard.window docking-shrink-workarea true
gsettings set org.onboard.window.landscape dock-height 300
gsettings set org.onboard.window.landscape height 300
gsettings set org.onboard.window.portrait dock-height 300
gsettings set org.onboard.window.portrait height 300
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
sudo mkdir -p /etc/lightdm
sudo cp slick-greeter.conf /etc/lightdm/slick-greeter.conf
sudo rm -rf /usr/share/xsessions/bspwm.desktop
mkdir -p ~/.config/bspwm
cp bspwmrc ~/.config/bspwm/bspwmrc
chmod +x ~/.config/bspwm/bspwmrc
mkdir -p ~/.config/xfce4
unzip -o xfce4-config.zip -d ~/.config/xfce4
cp profile-picture.jpeg ~/.face
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
