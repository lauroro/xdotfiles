#! /bin/sh

xinput set-prop 12 288 1
xinput set-prop 12 296 1
setxkbmap it

# betterlockscreen -u $HOME/.config/background
xss-lock -- bash $HOME/.config/i3lock-color/lock.sh &
