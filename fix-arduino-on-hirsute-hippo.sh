#!/bin/bash
echo "Started fixing the Arduino IDE."
apt update
apt full-upgrade -y
apt install libserialport0 patchelf
apt clean
patchelf --add-needed libserialport.so.0 /usr/lib/x86_64-linux-gnu/liblistSerialsj.so.1.4.0
echo "Fixed the Arduino IDE successfully."
