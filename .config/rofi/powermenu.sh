#!/bin/bash
 
lock=" Lock"
exit=" Exit"
shutdown="襤 Poweroff"
reboot=" Reboot"
sleep=" Suspend"
 
selected_option=$(echo "$lock
$exit
$sleep
$reboot
$shutdown" | rofi -dmenu -i -p "Powermenu" \
		  -theme "~/.config/rofi/powermenu.rasi")

if [ "$selected_option" == "$lock" ]
then
  betterlockscreen -l
elif [ "$selected_option" == "$exit" ]
then
  echo -E "awesome.quit()" | awesome-client
elif [ "$selected_option" == "$shutdown" ]
then
  loginctl poweroff
elif [ "$selected_option" == "$reboot" ]
then
  loginctl reboot
elif [ "$selected_option" == "$sleep" ]
then
  loginctl suspend
else
  echo "No match"
fi