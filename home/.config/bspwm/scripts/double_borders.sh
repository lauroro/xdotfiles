#!/bin/sh
#  double borders
# needs chwb2 from wmutils/opt:
# https://github.com/wmutils/opt

outer='0x282828'   # outer
inner1='0xa89984'  # focused
inner2='0x32302f'  # normal

trap 'bspc config border_width 0; kill -9 -$$' INT TERM

targets() {
	case $1 in
		focused) bspc query -N -n .local.focused.\!fullscreen;;
		normal)  bspc query -N -n .\!focused.\!fullscreen
	esac
}
bspc config border_width 8

# fix this with whatever is the path of chwb2
draw() { $HOME/opt/chwb2 -I "$inner" -O "$outer" -i "2" -o "5" $*; }

# initial draw, and then subscribe to events
{ echo; bspc subscribe node_geometry node_focus; } |
	while read -r _; do
		[ "$v" ] || v='abcdefg'
		inner=$inner1 draw $(targets focused)
		inner=$inner2 draw $(targets  normal)
	done
