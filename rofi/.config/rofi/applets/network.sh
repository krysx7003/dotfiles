#!/usr/bin/env bash

# Current Theme
dir="$HOME/.config/rofi/applets"
theme='net-theme'


network=$(nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2)

wired='wired'
wireless='wireless'

# Rofi CMD
rofi_cmd() {
    xdotool mousemove 960 540 &&
	rofi \
        -show script \
        -theme ${dir}/${theme}.rasi \
        -theme-str "textbox {str: \"Connected: $network\";}"
}

# Pass variables to rofi dmenu
run_rofi() {
	 rofi_cmd
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
