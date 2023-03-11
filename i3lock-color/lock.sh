#!/bin/sh

BLANK='#00000000'
CLEAR='#ffffff22'
DEFAULT='#89b4facc'
TEXT='#ee00eeee'
WRONG='#880000bb'
VERIFYING='#bb00bbbb'

i3lock \
--insidever-color=$CLEAR     \
--ringver-color=$VERIFYING   \
\
--insidewrong-color=$CLEAR   \
--ringwrong-color=$WRONG     \
\
--inside-color=$BLANK        \
--ring-color=$DEFAULT        \
--line-color=$BLANK          \
--separator-color=$DEFAULT   \
\
--verif-color=$TEXT          \
--wrong-color=$TEXT          \
--time-color=$DEFAULT           \
--date-color=$DEFAULT           \
--keyhl-color=$WRONG         \
--bshl-color=$WRONG          \
\
--screen 1                   \
--clock                      \
--color 0d0d0d                \
--indicator                  \
--time-str="%R"        \
--date-str="%A, %d-%m-%Y"       \           