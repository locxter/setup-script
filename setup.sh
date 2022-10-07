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
sudo apt purge brltty aisleriot gnome-calendar gnome-mahjongg gnome-mines shotwell remmina gnome-sudoku gnome-todo seahorse thunderbird baobab gnome-font-viewer usb-creator-gtk -y
if ! $BACKUP_DRIVE
then
    sudo apt purge deja-dup -y
fi
sudo apt full-upgrade -y
sudo apt install libfuse2 libserialport0 patchelf ubuntu-restricted-extras git build-essential gdb cmake openjdk-17-jdk maven android-sdk-platform-tools lm-sensors neofetch minicom curl gedit-plugins mat2 bleachbit gnome-boxes tilp2 cura inkscape anki kiwix freecad arduino xournalpp musescore3 -y
if $DATA_DRIVE
then
    sudo apt install syncthing -y
fi
sudo apt autoremove --purge -y
sudo apt autoclean
sudo snap refresh
sudo snap install node --classic
sudo snap install codium --classic
sudo snap install chromium signal-desktop whatsapp-for-linux
mkdir -p ~/Applications
wget -O ~/Applications/tutanota-desktop-linux.AppImage https://mail.tutanota.com/desktop/tutanota-desktop-linux.AppImage
chmod +x ~/Applications/tutanota-desktop-linux.AppImage
echo "################################################################################"
echo "#                           Configuring the firewall                           #"
echo "################################################################################"
sudo ufw enable
sudo ufw allow transmission
if $DATA_DRIVE
then
    sudo ufw allow syncthing
fi
echo "################################################################################"
echo "#                Configuring DNS over TLS and mac randomization                #"
echo "################################################################################"
sudo systemctl stop NetworkManager
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
sudo systemctl enable systemd-resolved
sudo systemctl start NetworkManager
sudo systemctl start systemd-resolved
sleep 30
echo "################################################################################"
echo "#                       Configuring scripts and programs                       #"
echo "################################################################################"
if $DATA_DRIVE
then
    mkdir -p ~/.config/autostart
    tee ~/.config/autostart/mount-data-drive.desktop << EOF
[Desktop Entry]
Type=Application
Exec=bash -c "if ! test -e /media/locxter/data; then while ! udisksctl unlock -b $LOCKED_DATA_DRIVE --key-file <(zenity --password --title='Mount data drive' | tr -d '\n'); do zenity --error --text='Wrong password'; done; udisksctl mount -b $UNLOCKED_DATA_DRIVE; syncthing -no-browser; fi"
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
if $BACKUP_DRIVE
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
sudo patchelf --add-needed libserialport.so.0 /usr/lib/x86_64-linux-gnu/liblistSerialsj.so.1.4.0
sudo mkdir -p /etc/minicom
sudo tee /etc/minicom/minirc.dfl << EOF
pu port             
pu rtscts           No
pu logconn          No 
pu logxfer          No 
pu addcarreturn     Yes
EOF
mkdir -p ~/.local/share/nautilus/scripts
tee ~/.local/share/nautilus/scripts/add-pdf-to-xopp.sh << "EOF"
#!/bin/bash
for FILE in $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS
do
    TYPE=$(echo $FILE | grep -P -o ".*\K\..*")
    if [[ $TYPE == .xopp ]]
    then
        TARGET=$(basename $FILE)
        TARGET+=".bg.pdf"
    else
        SOURCES+=$FILE
        SOURCES+=" "
    fi
done
pdfunite $TARGET $SOURCES .pdfunite-tmp.pdf
mv .pdfunite-tmp.pdf $TARGET
EOF
chmod +x ~/.local/share/nautilus/scripts/add-pdf-to-xopp.sh
tee ~/.local/share/nautilus/scripts/convert-pdf-to-png.sh << "EOF"
#!/bin/bash
for FILE in $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS
do
    PAGES=$(pdfinfo $FILE | grep -P -o "Pages:\s*\K\d+")
    TARGET=$(basename $FILE .pdf)
    if [[ $PAGES == 1 ]]
    then
        pdftoppm -singlefile -png $FILE $TARGET
    else
        pdftoppm -png $FILE $TARGET
    fi
done
EOF
chmod +x ~/.local/share/nautilus/scripts/convert-pdf-to-png.sh
tee ~/.local/share/nautilus/scripts/merge-pdfs.sh << "EOF"
#!/bin/bash
I=0
for FILE in $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS
do
    if (( $I == 0 ))
    then 
        TARGET=$(basename $FILE .pdf)
        TARGET+="-merged.pdf"
    fi
    SOURCES+=$FILE
    SOURCES+=" "
    (( I++ ))
done
pdfunite $SOURCES $TARGET
EOF
chmod +x ~/.local/share/nautilus/scripts/merge-pdfs.sh
tee ~/.local/share/nautilus/scripts/remove-metadata.sh << "EOF"
#!/bin/bash
for FILE in $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS
do
    mat2 --inplace --lightweight $FILE
done
EOF
chmod +x ~/.local/share/nautilus/scripts/remove-metadata.sh
tee ~/.gitconfig << EOF
[user]
name=locxter
email=54595101+locxter@users.noreply.github.com
[init]
defaultBranch = main
EOF
mkdir -p ~/.config/VSCodium
unzip -o vscodium-config.zip -d ~/.config/VSCodium
codium --install-extension vsciot-vscode.vscode-arduino --install-extension ms-vscode.cpptools --install-extension twxs.cmake --install-extension ms-vscode.cmake-tools --install-extension vscjava.vscode-java-debug --install-extension redhat.java --install-extension vscjava.vscode-maven --install-extension eg2.vscode-npm-script --install-extension vscjava.vscode-java-dependency --install-extension Tyriar.sort-lines --install-extension vscjava.vscode-java-test --install-extension rangav.vscode-thunder-client
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
mkdir -p ~/.local/share/cura/4.13
unzip -o cura-config.zip -d ~/.local/share/cura/4.13
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
echo "################################################################################"
echo "#                          Setting my profile picture                          #"
echo "################################################################################"
cp profile-picture.jpeg ~/.face
echo "################################################################################"
echo "#                      Tweaking the desktop to my likings                      #"
echo "################################################################################"
gsettings set org.gnome.mutter center-new-windows true
gsettings set org.gnome.mutter workspaces-only-on-primary false
gsettings set org.gnome.desktop.wm.keybindings switch-applications "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-applications-backward "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Super>Tab', '<Alt>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-windows-backward "['<Shift><Super>Tab', '<Shift><Alt>Tab']"
gsettings set org.gnome.shell.window-switcher current-workspace-only false
gsettings set org.gnome.shell.extensions.dash-to-dock show-trash false
gsettings set org.gnome.shell.extensions.dash-to-dock show-mounts false
gsettings set org.gnome.shell favorite-apps "['firefox_firefox.desktop', 'tutanota-desktop.desktop', 'signal-desktop_signal-desktop.desktop', 'whatsapp-for-linux_whatsapp-for-linux.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop']"
gsettings set org.gnome.desktop.app-folders folder-children "['']"
gsettings set org.gnome.shell app-picker-layout "[]"
echo "################################################################################"
echo "#        Finished the setup, please check the console output for errors        #"
echo "#             that might occurred and reboot the system afterwards             #"
echo "################################################################################"