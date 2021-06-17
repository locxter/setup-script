# Software setup

## Overview

This repository includes my personal setup script for most of the terminal based configuration needed on a fresh Ubuntu minimal installation.

## Dependencies

I generally try to minimize dependencies, but I'm a one man crew and can therefore only support Ubuntu as I'm running it myself. Anyway, you need to have the following packages installed for everything to work properly:

- Everything needed is already preinstalled on modern Ubuntu versions.

## How to use it

Simply execute the `setup.sh` script with root privileges via `sudo ./setup.sh` and you should be ready to go. On Ubuntu 21.04 Hirsute Hippo you additionally have to run the `fix-arduino-on-hirsute-hippo.sh` script with root privileges via `sudo ./fix-arduino-on-hirsute-hippo.sh` to get the Arduino IDE to work.
