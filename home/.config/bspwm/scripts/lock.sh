#!/bin/bash

BLANK="#00000000"
FOREGROUND="#d4be98"
IMAGE=~/.config/wallpaper
RING="#282828"
FONT="JetBrainsMonoNerdFont"
BACKSPACE="#e78a4e"
WRONG="#ea6962"
VERIFY="#7daea3"
COLOR="#32302f"


i3lock \
--image $IMAGE \
--nofork \
--composite \
--tiling \
--clock \
--force-clock \
--indicator \
--ind-pos "x+170:y+h-120" \
--ring-color $RING \
--ringver-color $FOREGROUND \
--line-color $BLANK \
--inside-color $BLANK \
--insidewrong-color $WRONG \
--insidever-color $VERIFY \
--keyhl-color $FOREGROUND \
--bshl-color $BACKSPACE \
--separator-color $BLANK \
--time-str "%R" \
--date-str "%d-%m-%Y" \
--time-font=$FONT \
--date-font=$FONT \
--verif-text="" \
--wrong-text="" \
--noinput-text="" \
--time-pos x+80:y+h-120 \
--time-color $FOREGROUND \
--date-color $FOREGROUND \
--radius 30 \
--ignore-empty-password \
#--color $COLOR \
