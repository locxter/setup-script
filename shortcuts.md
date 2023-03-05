# Shortcuts

## Terminal emulator

- Shortcut: `super + return`
- Command: `exo-open --launch TerminalEmulator`

## Web browser

- Shortcut: `super + shift + return`
- Command: `exo-open --launch WebBrowser`

## File manager

- Shortcut: `super + ctrl + return`
- Command: `exo-open --launch FileManager`

## Program launcher

- Shortcut: `super + space`
- Command: `xfce4-popup-whiskermenu`

## Screenshot

- Shortcut: `print`
- Command: `xfce4-screenshooter -f`

## Regional screenshot

- Shortcut: `shift + print`
- Command: `xfce4-screenshooter -r`

## Screenshot to clipboard

- Shortcut: `ctrl + print`
- Command: `xfce4-screenshooter -f -c`

## Regional screenshot to clipboard

- Shortcut: `ctrl + shift + print`
- Command: `xfce4-screenshooter -r -c`

## Quit desktop

- Shortcut: `super + alt + q`
- Command: `xfce4-session-logout`

## Lock desktop

- Shortcut: `super + alt + w`
- Command: `xflock4`

## Restart desktop

- Shortcut: `super + alt + r`
- Command: `bspc wm -r`

## Close window

- Shortcut: `super + w`
- Command: `bspc node -c`

## Kill window

- Shortcut: `super + shift + w`
- Command: `bspc node -k`

## Alternate between the tiled and monocle layout

- Shortcut: `super + m`
- Command: `bspc desktop -l next`

## Send the newest marked node to the newest preselected node

- Shortcut: `super + z`
- Command: `bspc node newest.marked.local -n newest.!automatic.local`

## Swap the current node and the biggest window

- Shortcut: `super + g`
- Command: `bspc node -s biggest.window`

## Set the window state

- Shortcut: `super + t`
- Command: `bspc node -t tiled`

- Shortcut: `super + shift + t`
- Command: `bspc node -t pseudo_tiled`

- Shortcut: `super + s`
- Command: `bspc node -t floating`

- Shortcut: `super + f`
- Command: `bspc node -t fullscreen`

## Set the node flags

- Shortcut: `super + ctrl + m`
- Command: `bspc node -g marked`

- Shortcut: `super + ctrl + x`
- Command: `bspc node -g locked`

- Shortcut: `super + ctrl + z`
- Command: `bspc node -g sticky`

- Shortcut: `super + ctrl + y`
- Command: `bspc node -g private`

## Focus the node in the given direction

- Shortcut: `super + h`
- Command: `bspc node -f west`

- Shortcut: `super + j`
- Command: `bspc node -f south`

- Shortcut: `super + k`
- Command: `bspc node -f north`

- Shortcut: `super + l`
- Command: `bspc node -f east`

- Shortcut: `super + shift + h`
- Command: `bspc node -s west`

- Shortcut: `super + shift + j`
- Command: `bspc node -s south`

- Shortcut: `super + shift + k`
- Command: `bspc node -s north`

- Shortcut: `super + shift + l`
- Command: `bspc node -s east`

## Focus the node for the given path jump

- Shortcut: `super + p`
- Command: `bspc node -f @parent`

- Shortcut: `super + b`
- Command: `bspc node -f @brother`

- Shortcut: `super + comma`
- Command: `bspc node -f @first`

- Shortcut: `super + period`
- Command: `bspc node -f @second`

## Focus the next/previous window in the current desktop

- Shortcut: `super + c`
- Command: `bspc node -f next.local.!hidden.window`

- Shortcut: `super + shift + c`
- Command: `bspc node -f prev.local.!hidden.window`

## Focus the next/previous desktop in the current monitor

- Shortcut: `super + ü`
- Command: `bspc desktop -f prev.local`

- Shortcut: `super + plus`
- Command: `bspc desktop -f next.local`

## Focus the last node/desktop

- Shortcut: `super + circumflex`
- Command: `bspc node -f last`

- Shortcut: `super + tab`
- Command: `bspc desktop -f last`

## Focus the older or newer node in the focus history

- Shortcut: `super + o`
- Command: `bash -c "bspc wm -h off; bspc node older -f; bspc wm -h on"`

- Shortcut: `super + i`
- Command: `bash -c "bspc wm -h off; bspc node newer -f; bspc wm -h on"`

## Focus or send to the given desktop

- Shortcut: `super + 1`
- Command: `bspc desktop -f '^1'`

- Shortcut: `super + 2`
- Command: `bspc desktop -f '^2'`

- Shortcut: `super + 3`
- Command: `bspc desktop -f '^3'`

- Shortcut: `super + 4`
- Command: `bspc desktop -f '^4'`

- Shortcut: `super + 5`
- Command: `bspc desktop -f '^5'`

- Shortcut: `super + 6`
- Command: `bspc desktop -f '^6'`

- Shortcut: `super + 7`
- Command: `bspc desktop -f '^7'`

- Shortcut: `super + 8`
- Command: `bspc desktop -f '^8'`

- Shortcut: `super + 9`
- Command: `bspc desktop -f '^9'`

- Shortcut: `super + 0`
- Command: `bspc desktop -f '^10'`

- Shortcut: `super + shift + 1`
- Command: `bspc node -d '^1'`

- Shortcut: `super + shift + 2`
- Command: `bspc node -d '^2'`

- Shortcut: `super + shift + 3`
- Command: `bspc node -d '^3'`

- Shortcut: `super + shift + 4`
- Command: `bspc node -d '^4'`

- Shortcut: `super + shift + 5`
- Command: `bspc node -d '^5'`

- Shortcut: `super + shift + 6`
- Command: `bspc node -d '^6'`

- Shortcut: `super + shift + 7`
- Command: `bspc node -d '^7'`

- Shortcut: `super + shift + 8`
- Command: `bspc node -d '^8'`

- Shortcut: `super + shift + 9`
- Command: `bspc node -d '^9'`

- Shortcut: `super + shift + 0`
- Command: `bspc node -d '^10'`

## Peselect the direction

- Shortcut: `super + ctrl + h`
- Command: `bspc node -p west`

- Shortcut: `super + ctrl + j`
- Command: `bspc node -p south`

- Shortcut: `super + ctrl + k`
- Command: `bspc node -p north`

- Shortcut: `super + ctrl + l`
- Command: `bspc node -p east`

## Preselect the ratio

- Shortcut: `super + ctrl + 1`
- Command: `bspc node -o 0.1`

- Shortcut: `super + ctrl + 2`
- Command: `bspc node -o 0.2`

- Shortcut: `super + ctrl + 3`
- Command: `bspc node -o 0.3`

- Shortcut: `super + ctrl + 4`
- Command: `bspc node -o 0.4`

- Shortcut: `super + ctrl + 5`
- Command: `bspc node -o 0.5`

- Shortcut: `super + ctrl + 6`
- Command: `bspc node -o 0.6`

- Shortcut: `super + ctrl + 7`
- Command: `bspc node -o 0.7`

- Shortcut: `super + ctrl + 8`
- Command: `bspc node -o 0.8`

- Shortcut: `super + ctrl + 9`
- Command: `bspc node -o 0.9`

## Cancel the preselection for the focused node

- Shortcut: `super + ctrl + space`
- Command: `bspc node -p cancel`

## Cancel the preselection for the focused desktop

- Shortcut: `super + ctrl + shift + space`
- Command: `bash -c "bspc query -N -d | xargs -I id -n 1 bspc node id -p cancel"`

## Expand a window by moving one of its side outward

- Shortcut: `super + alt + h`
- Command: `bspc node -z left -20 0`

- Shortcut: `super + alt + j`
- Command: `bspc node -z bottom 0 20`

- Shortcut: `super + alt + k`
- Command: `bspc node -z top 0 -20`

- Shortcut: `super + alt + l`
- Command: `bspc node -z right 20 0`

## Contract a window by moving one of its side inward

- Shortcut: `super + alt + shift + h`
- Command: `bspc node -z right -20 0`

- Shortcut: `super + alt + shift + j`
- Command: `bspc node -z top 0 20`

- Shortcut: `super + alt + shift + k`
- Command: `bspc node -z bottom 0 -20`

- Shortcut: `super + alt + shift + l`
- Command: `bspc node -z left 20 0`


## Move a floating window

- Shortcut: `super + left`
- Command: `bspc node -v -20 0`

- Shortcut: `super + down`
- Command: `bspc node -v 0 20`

- Shortcut: `super + up`
- Command: `bspc node -v 0 -20`

- Shortcut: `super + right`
- Command: `bspc node -v 20 0`
