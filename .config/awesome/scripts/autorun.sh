#! /bin/sh

xinput set-prop 12 293 1
xinput set-prop 12 285 1
setxkbmap it

betterlockscreen -u $HOME/.config/background
xss-lock -- betterlockscreen -l &
