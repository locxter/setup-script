# Software setup

## Overview

This repository includes my personal setup script for most of the terminal based configuration needed on a fresh Debian installation.

## Dependencies

I generally try to minimize dependencies, but I'm a one man crew and can therefore only support Debian as I'm running it myself. Anyway, you need to have the following packages installed for everything to work properly:

- Everything needed is already preinstalled on modern Debian versions.

## How to use it

I'm providing a Debian Unstable as well as Stable setup script, so you can choose depending on your personal preferences. Both assume that you are currently running a fresh Debian Stable installation. Keep in mind that the Unstable script uses native packages wherever possible, while the Stable script prefers Flatpak packages to keep the system up-to-date.

Simply make the `setup.sh` or `stable-setup.sh` script executable via `chmod +x ./setup.sh` or `chmod +x ./stable-setup.sh` and execute it with root privileges via `sudo -E ./setup.sh` or `sudo -E ./stable-setup.sh`, tweak some more settings using the GUI to your liking and you should be ready to go.
