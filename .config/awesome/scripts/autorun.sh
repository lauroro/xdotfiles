#! /bin/bash

# Xinput
ID="$(xinput list | grep Touchpad | awk '{print $6}' | tr -dc '0-9')"
TAPPING="$(xinput list-props $ID | grep "libinput Tapping Enabled (" | awk '{print $4}' | tr -dc '0-9')"
NATSCR="$(xinput list-props $ID | grep "libinput Natural Scrolling Enabled (" | awk '{print $5}' | tr -dc '0-9')"
xinput set-prop $ID $TAPPING 1
xinput set-prop $ID $NATSCR 1

# Keymap
setxkbmap it

# Lockscreen
xss-lock -- bash $HOME/.config/awesome/scripts/lock &
