#!/bin/bash
echo "################################################################################"
echo "#                              Starting the setup                              #"
echo "################################################################################"
echo "################################################################################"
echo "#          Add data drive scripts and programs to this computer?[y/N]          #"
echo "################################################################################"
read REPLY
if [[ $REPLY =~ [Yy]* ]]
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
if [[ $REPLY =~ [Yy]* ]]
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
wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg | gpg --dearmor | sudo dd of=/usr/share/keyrings/vscodium-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/vscodium-keyring.gpg] https://download.vscodium.com/debs vscodium main" | sudo tee /etc/apt/sources.list.d/vscodium.list
wget -qO - https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor | sudo dd of=/usr/share/keyrings/signal-desktop-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main" | sudo tee /etc/apt/sources.list.d/signal-desktop.list
echo "deb http://deb.debian.org/debian bullseye-backports main non-free contrib" | sudo tee /etc/apt/sources.list.d/bullseye-backports.list
sudo apt update
sudo apt purge gnome-games gnome-calendar gnome-clocks gnome-contacts gnome-documents evolution gnome-maps gnome-music malcontent shotwell gnome-todo gnome-weather seahorse synaptic gnome-tweaks gnome-shell-extensions gnome-shell-extension-prefs gnome-characters baobab gnome-font-viewer im-config -y
sudo apt full-upgrade -y
sudo apt install ufw cups locales-all aspell-de hunspell-de-de git build-essential gdb cmake openjdk-17-jdk maven nodejs npm adb fastboot lm-sensors neofetch minicom curl mat2 poppler-utils bleachbit gnome-boxes tilp2 cura inkscape anki kiwix freecad arduino chromium codium signal-desktop xournalpp -y
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
mkdir -p ~/Applications
wget -O ~/Applications/tutanota-desktop-linux.AppImage https://mail.tutanota.com/desktop/tutanota-desktop-linux.AppImage
chmod +x ~/Applications/tutanota-desktop-linux.AppImage
echo "################################################################################"
echo "#                          Configuring the bootloader                          #"
echo "################################################################################"
sudo mkdir -p /etc/default
sudo tee /etc/default/grub << EOF
GRUB_DEFAULT=0
GRUB_TIMEOUT=0
GRUB_DISTRIBUTOR="Debian"
GRUB_CMDLINE_LINUX_DEFAULT="quiet loglevel=3"
GRUB_CMDLINE_LINUX=""
EOF
sudo update-grub
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
sudo mkdir -p /etc
sudo tee /etc/resolv.conf << EOF
nameserver 127.0.0.53
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
sleep 15
echo "################################################################################"
echo "#                       Configuring scripts and programs                       #"
echo "################################################################################"
if $DATA_DRIVE
then
    mkdir -p ~/.config/autostart
    tee ~/.config/autostart/mount-data-drive.desktop << EOF
[Desktop Entry]
Type=Application
Exec=bash -c "if ! test -e /media/$USER/data; then while ! udisksctl unlock -b $LOCKED_DATA_DRIVE --key-file <(zenity --password --title='Mount data drive' | tr -d '\n'); do zenity --error --text='Wrong password'; done; udisksctl mount -b $UNLOCKED_DATA_DRIVE; syncthing -no-browser; fi"
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
mkdir -p ~/.local/share/cura/4.8
unzip -o cura-config.zip -d ~/.local/share/cura/4.8
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
wget -O ~/.config/libreoffice/4/user/template/document-template.ott https://raw.githubusercontent.com/locxter/libreoffice-templates/main/document-template.ott
wget -O ~/.config/libreoffice/4/user/template/report-template.ott https://raw.githubusercontent.com/locxter/libreoffice-templates/main/report-template.ott
wget -O ~/.config/libreoffice/4/user/template/presentation-template.otp https://raw.githubusercontent.com/locxter/libreoffice-templates/main/presentation-template.otp
wget -O ~/.config/libreoffice/4/user/template/spreadsheet-template.ots https://raw.githubusercontent.com/locxter/libreoffice-templates/main/spreadsheet-template.ots
wget -O ~/.config/libreoffice/4/user/template/timetable-template.ott https://raw.githubusercontent.com/locxter/libreoffice-templates/main/timetable-template.ott
mkdir -p ~/.config/libreoffice/4/user/autocorr
cp libreoffice-autocorrect.dat ~/.config/libreoffice/4/user/autocorr/acor_de-DE.dat
mkdir -p ~/.local/share/rhythmbox
tee ~/.local/share/rhythmbox/rhythmdb.xml << EOF
<?xml version="1.0" standalone="yes"?>
<rhythmdb version="2.0">
  <entry type="iradio">
    <title>NDR N-JOY</title>
    <genre>Unknown</genre>
    <location>http://www.ndr.de/resources/metadaten/audio/aac/n-joy.m3u</location>
  </entry>
  <entry type="iradio">
    <title>NDR N-JOY Club</title>
    <genre>Unknown</genre>
    <location>https://www.ndr.de/resources/metadaten/audio_ssl/m3u/ndrloop5.m3u</location>
  </entry>
  <entry type="iradio">
    <title>NDR N-JOY Morningshow</title>
    <genre>Unknown</genre>
    <location>http://www.ndr.de/resources/metadaten/audio/m3u/ndrloop27.m3u</location>
  </entry>
  <entry type="iradio">
    <title>NDR N-JOY Pop</title>
    <genre>Unknown</genre>
    <location>https://www.ndr.de/resources/metadaten/audio_ssl/m3u/ndrloop29.m3u</location>
  </entry>
  <entry type="iradio">
    <title>NDR N-JOY Soundfiles Hip-Hop</title>
    <genre>Unknown</genre>
    <location>https://www.ndr.de/resources/metadaten/audio_ssl/m3u/ndrloop6.m3u</location>
  </entry>
  <entry type="iradio">
    <title>NDR N-JOY Weltweit</title>
    <genre>Unknown</genre>
    <location>https://www.ndr.de/resources/metadaten/audio_ssl/m3u/ndrloop28.m3u</location>
  </entry>
</rhythmdb>
EOF
echo "################################################################################"
echo "#                          Setting my profile picture                          #"
echo "################################################################################"
cp profile-picture.jpeg ~/.face
echo "################################################################################"
echo "#                      Tweaking the desktop to my likings                      #"
echo "################################################################################"
gsettings set org.gnome.mutter center-new-windows true
gsettings set org.gnome.desktop.interface enable-hot-corners false
gsettings set org.gnome.mutter workspaces-only-on-primary false
gsettings set org.gnome.desktop.wm.keybindings switch-applications "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-applications-backward "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Super>Tab', '<Alt>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-windows-backward "['<Shift><Super>Tab', '<Shift><Alt>Tab']"
gsettings set org.gnome.shell.window-switcher current-workspace-only false
gsettings set org.gnome.shell favorite-apps "['firefox-esr.desktop', 'tutanota-desktop.desktop', 'signal-desktop.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop']"
gsettings set org.gnome.desktop.app-folders folder-children "['']"
gsettings set org.gnome.shell app-picker-layout "[]"
echo "################################################################################"
echo "#        Finished the setup, please check the console output for errors        #"
echo "#             that might occurred and reboot the system afterwards             #"
echo "################################################################################"
