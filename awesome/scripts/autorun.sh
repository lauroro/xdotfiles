#! /bin/sh

xinput set-prop 12 283 1
xinput set-prop 12 291 1
setxkbmap it

betterlockscreen -u $HOME/.config/background
xss-lock -- betterlockscreen -l &
