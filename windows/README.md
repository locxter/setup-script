# Windows

## Overview

Even though I hate it, I have to use Windows 11 without admin privileges at my job for everything from word processing to development. This creates a few challenges since I have rather unique requirements about how I like to use my computer (tiling window manager with the Pop!_OS keymap), but thankfully I was able to resolve most of them.

## Installation process

- Generally speaking, I like to configure everything exactly the same as on Linux or as minimalistic as possible. This includes:
    - Installing [Notepad++ Portable](https://notepad-plus-plus.org/) as a basic text editor and VSCode with all my favourite extensions.
    - Disabling desktop icons, configuring the taskbar to be minimal and left aligned as well as showing all extensions and hidden files in the file explorer.
    - Using Firefox with my config and plugins for most browsing.
- FancyWM setup:
    - Install via `winget install fancywm`.
    - Copy the `settings.json` to `%localappdata%\Packages\2203VeselinKaraganev.FancyWM_9x2ndwrcmyd2c\LocalCache\Roaming\FancyWM`.
    - Check that FancyWM is enable for autostart.
- PowerToys setup:
    - Install via `winget install Microsoft.PowerToys -s winget`
    - Copy the entire `.customization` folder to `C:\Users\schultl` (or your user).
    - Copy the `default.json` to `%localappdata%\Microsoft\PowerToys\Keyboard Manager` (and adapt the paths to your user).
    - Enable `Keyboard Manager` in the PowerToys settings.
    - Check that PowerToys is enable for autostart.
- With that done, you should now have a somewhat usable Windows setup - at least as far as window management goes ;)