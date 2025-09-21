#!/usr/bin/env bash

# Current Theme
dir="$HOME/.config/rofi/applets"
theme='bt-theme'

shutdown='tmp'

# Rofi CMD
rofi_cmd() {
    xdotool mousemove 960 540 &&
}

# Pass variables to rofi dmenu
run_rofi() {
	echo "$tmp" | rofi_cmd
}

# Execute Command
run_cmd() {
    echo "$1"	
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
   $tmp)
       run_cmd --tmp
       ;;

esac
