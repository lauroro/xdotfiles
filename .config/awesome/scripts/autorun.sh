#! /bin/sh

xinput set-prop 13 312 1
xinput set-prop 13 285 1
setxkbmap it

xss-lock -- bash $HOME/.config/awesome/scripts/lock &
