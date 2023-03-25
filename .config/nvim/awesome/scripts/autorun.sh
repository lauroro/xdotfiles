#! /bin/sh

xinput set-prop 13 304 1
xinput set-prop 13 283 1
setxkbmap it

betterlockscreen -u $HOME/.config/background
xss-lock -- betterlockscreen -l &
