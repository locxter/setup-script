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
sudo apt update
sudo apt purge flatpak gir1.2-flatpak-1.0 libflatpak0 sticky onboard seahorse drawing pix hexchat thunderbird gnome-calendar thingy mintbackup baobab timeshift mintwelcome warpinator mintstick -y
sudo apt full-upgrade -y
sudo apt install libserialport0 patchelf python3-serial git build-essential gdb cmake openjdk-17-jdk maven rust-all nodejs android-sdk-platform-tools python3-pip htop minicom mat2 bleachbit dconf-editor gnome-boxes tilp2 cura inkscape anki kiwix freecad arduino chromium codium signal-desktop xournalpp musescore3 -y
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
tee ~/.local/share/applications/webapp-Beatbump8822.desktop << EOF
[Desktop Entry]
Version=1.0
Name=Beatbump
Comment=Web App
Exec=chromium --app=https://beatbump.ml/home --class=WebApp-Beatbump8822 --user-data-dir=/home/locxter/.local/share/ice/profiles/Beatbump8822
Terminal=false
X-MultipleArgs=false
Type=Application
Icon=/home/locxter/.local/share/ice/icons/Beatbump.png
Categories=GTK;AudioVideo;
MimeType=text/html;text/xml;application/xhtml_xml;
StartupWMClass=WebApp-Beatbump8822
StartupNotify=true
X-WebApp-Browser=Chromium
X-WebApp-URL=https://beatbump.ml/home
X-WebApp-CustomParameters=
X-WebApp-Isolated=true
EOF
tee ~/.local/share/applications/webapp-Lofimusic7613.desktop << EOF
[Desktop Entry]
Version=1.0
Name=Lofimusic
Comment=Web App
Exec=chromium --app=https://lofimusic.app --class=WebApp-Lofimusic7613 --user-data-dir=/home/locxter/.local/share/ice/profiles/Lofimusic7613
Terminal=false
X-MultipleArgs=false
Type=Application
Icon=/home/locxter/.local/share/ice/icons/Lofimusic.png
Categories=GTK;AudioVideo;
MimeType=text/html;text/xml;application/xhtml_xml;
StartupWMClass=WebApp-Lofimusic7613
StartupNotify=true
X-WebApp-Browser=Chromium
X-WebApp-URL=https://lofimusic.app
X-WebApp-CustomParameters=
X-WebApp-Isolated=true
EOF
tee ~/.local/share/applications/webapp-PomodoroKitty9459.desktop << EOF
[Desktop Entry]
Version=1.0
Name=Pomodoro Kitty
Comment=Web App
Exec=chromium --app=https://pomodorokitty.com --class=WebApp-PomodoroKitty9459 --user-data-dir=/home/locxter/.local/share/ice/profiles/PomodoroKitty9459
Terminal=false
X-MultipleArgs=false
Type=Application
Icon=/home/locxter/.local/share/ice/icons/PomodoroKitty.png
Categories=GTK;Office;
MimeType=text/html;text/xml;application/xhtml_xml;
StartupWMClass=WebApp-PomodoroKitty9459
StartupNotify=true
X-WebApp-Browser=Chromium
X-WebApp-URL=https://pomodorokitty.com
X-WebApp-CustomParameters=
X-WebApp-Isolated=true
EOF
tee ~/.local/share/applications/webapp-StandardNotes5817.desktop << EOF
[Desktop Entry]
Version=1.0
Name=Standard Notes
Comment=Web App
Exec=chromium --app=https://app.standardnotes.com --class=WebApp-StandardNotes5817 --user-data-dir=/home/locxter/.local/share/ice/profiles/StandardNotes5817
Terminal=false
X-MultipleArgs=false
Type=Application
Icon=/home/locxter/.local/share/ice/icons/StandardNotes.png
Categories=GTK;Network;
MimeType=text/html;text/xml;application/xhtml_xml;
StartupWMClass=WebApp-StandardNotes5817
StartupNotify=true
X-WebApp-Browser=Chromium
X-WebApp-URL=https://app.standardnotes.com
X-WebApp-CustomParameters=
X-WebApp-Isolated=true
EOF
tee ~/.local/share/applications/webapp-Tutanota3274.desktop << EOF
[Desktop Entry]
Version=1.0
Name=Tutanota
Comment=Web App
Exec=chromium --app=https://mail.tutanota.com --class=WebApp-Tutanota3274 --user-data-dir=/home/locxter/.local/share/ice/profiles/Tutanota3274
Terminal=false
X-MultipleArgs=false
Type=Application
Icon=/home/locxter/.local/share/ice/icons/Tutanota.png
Categories=GTK;Network;
MimeType=text/html;text/xml;application/xhtml_xml;
StartupWMClass=WebApp-Tutanota3274
StartupNotify=true
X-WebApp-Browser=Chromium
X-WebApp-URL=https://mail.tutanota.com
X-WebApp-CustomParameters=
X-WebApp-Isolated=true
EOF
tee ~/.local/share/applications/webapp-WhatsApp6942.desktop << EOF
[Desktop Entry]
Version=1.0
Name=WhatsApp
Comment=Web App
Exec=chromium --app=https://web.whatsapp.com --class=WebApp-WhatsApp6942 --user-data-dir=/home/locxter/.local/share/ice/profiles/WhatsApp6942
Terminal=false
X-MultipleArgs=false
Type=Application
Icon=/home/locxter/.local/share/ice/icons/WhatsApp.png
Categories=GTK;Network;
MimeType=text/html;text/xml;application/xhtml_xml;
StartupWMClass=WebApp-WhatsApp6942
StartupNotify=true
X-WebApp-Browser=Chromium
X-WebApp-URL=https://web.whatsapp.com
X-WebApp-CustomParameters=
X-WebApp-Isolated=true
EOF
mkdir -p ~/.local/share/ice/profiles/Beatbump8822
mkdir -p ~/.local/share/ice/profiles/Lofimusic7613
mkdir -p ~/.local/share/ice/profiles/PomodoroKitty9459
mkdir -p ~/.local/share/ice/profiles/StandardNotes5817
mkdir -p ~/.local/share/ice/profiles/Tutanota3274
mkdir -p ~/.local/share/ice/profiles/WhatsApp6942
mkdir -p ~/.local/share/ice/icons
unzip -o webapp-icons.zip -d ~/.local/share/ice/icons
echo "################################################################################"
echo "#                       Configuring scripts and programs                       #"
echo "################################################################################"
mkdir -p ~/.config/autostart
cp redshift-gtk.desktop ~/.config/autostart/redshift-gtk.desktop
if $DATA_DRIVE
then
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
sudo usermod -a -G dialout locxter
sudo usermod -a -G tty locxter
sudo patchelf --add-needed libserialport.so.0 /usr/lib/x86_64-linux-gnu/liblistSerialsj.so.1.4.0
sudo mkdir -p /etc/minicom
sudo tee /etc/minicom/minirc.dfl << EOF
pu port
pu rtscts           No
pu logconn          No
pu logxfer          No
pu addcarreturn     Yes
EOF
mkdir -p ~/.local/share/nemo/scripts
tee ~/.local/share/nemo/scripts/add-pdf-to-xopp.sh << "EOF"
#!/bin/bash
for FILE in $NEMO_SCRIPT_SELECTED_FILE_PATHS
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
chmod +x ~/.local/share/nemo/scripts/add-pdf-to-xopp.sh
tee ~/.local/share/nemo/scripts/convert-pdf-to-png.sh << "EOF"
#!/bin/bash
for FILE in $NEMO_SCRIPT_SELECTED_FILE_PATHS
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
chmod +x ~/.local/share/nemo/scripts/convert-pdf-to-png.sh
tee ~/.local/share/nemo/scripts/merge-pdfs.sh << "EOF"
#!/bin/bash
I=0
for FILE in $NEMO_SCRIPT_SELECTED_FILE_PATHS
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
chmod +x ~/.local/share/nemo/scripts/merge-pdfs.sh
tee ~/.local/share/nemo/scripts/remove-metadata.sh << "EOF"
#!/bin/bash
for FILE in $NEMO_SCRIPT_SELECTED_FILE_PATHS
do
    mat2 --inplace --lightweight $FILE
done
EOF
chmod +x ~/.local/share/nemo/scripts/remove-metadata.sh
tee ~/.gitconfig << EOF
[user]
name=locxter
email=54595101+locxter@users.noreply.github.com
[init]
defaultBranch = main
EOF
mkdir -p ~/.config/VSCodium
unzip -o vscodium-config.zip -d ~/.config/VSCodium
codium --install-extension vsciot-vscode.vscode-arduino --install-extension ms-vscode.cpptools --install-extension twxs.cmake --install-extension ms-vscode.cmake-tools --install-extension vscjava.vscode-java-debug --install-extension redhat.java --install-extension vscjava.vscode-maven --install-extension eg2.vscode-npm-script --install-extension vscjava.vscode-java-dependency --install-extension Tyriar.sort-lines --install-extension vscjava.vscode-java-test --install-extension rangav.vscode-thunder-client --install-extension rust-lang.rust-analyzer --install-extension serayuzgur.crates --install-extension panicbit.cargo
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
tee ~/.mozilla/firefox/profiles.ini << EOF
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
echo "#                      Tweaking the desktop to my likings                      #"
echo "################################################################################"
sudo cp wallpaper.jpeg /usr/share/backgrounds/wallpaper.jpeg
sudo mkdir -p /etc/lightdm
sudo tee /etc/lightdm/slick-greeter.conf << EOF
[Greeter]
theme-name=Mint-Y-Dark-Aqua
icon-theme-name=Mint-Y-Dark-Aqua
background=/usr/share/backgrounds/wallpaper.jpeg
EOF
cp profile-picture.jpeg ~/.face
gsettings set org.cinnamon.desktop.background picture-uri "file:///usr/share/backgrounds/wallpaper.jpeg"
gsettings set org.cinnamon.muffin center-new-windows true
gsettings set org.cinnamon.muffin workspace-cycle true
gsettings set org.cinnamon.muffin workspaces-only-on-primary true
gsettings set org.cinnamon alttab-switcher-show-all-workspaces true
gsettings set org.cinnamon.desktop.notifications display-notifications false
gsettings set org.cinnamon.desktop.privacy remember-recent-files false
gsettings set org.nemo.desktop volumes-visible false
gsettings set org.cinnamon.desktop.interface icon-theme "Mint-Y-Dark-Aqua"
gsettings set org.cinnamon.desktop.interface gtk-theme "Mint-Y-Dark-Aqua"
gsettings set org.cinnamon favorite-apps "['firefox.desktop', 'mintinstall.desktop', 'cinnamon-settings.desktop', 'nemo.desktop', 'org.gnome.Terminal.desktop']"
gsettings set org.cinnamon panels-enabled "['1:0:left']"
gsettings set org.cinnamon enabled-applets "['panel1:left:0:menu@cinnamon.org:0', 'panel1:left:2:grouped-window-list@cinnamon.org:2', 'panel1:right:3:systray@cinnamon.org:3', 'panel1:right:4:xapp-status@cinnamon.org:4', 'panel1:right:6:notifications@cinnamon.org:5', 'panel1:right:7:printers@cinnamon.org:6', 'panel1:right:8:network@cinnamon.org:10', 'panel1:right:9:sound@cinnamon.org:11', 'panel1:right:10:power@cinnamon.org:12', 'panel1:right:11:calendar@cinnamon.org:13', 'panel1:right:5:desaturate-cinnamon@locxter:57', 'panel1:right:12:cornerbar@cinnamon.org:31', 'panel1:left:1:separator@cinnamon.org:32']"
mkdir -p ~/.cinnamon/configs
unzip -o applet-configs.zip -d ~/.cinnamon/configs
mkdir -p ~/.local/share/cinnamon/applets
unzip -o desaturate-cinnamon@locxter.zip -d ~/.local/share/cinnamon/applets
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
sudo systemctl start systemd-resolved
sudo systemctl start NetworkManager
sleep 30
echo "################################################################################"
echo "#        Finished the setup, please check the console output for errors        #"
echo "#             that might occurred and reboot the system afterwards             #"
echo "################################################################################"
