#!/bin/sh
state=$(nmcli device show wlp0s20f3 | awk '/GENERAL.STATE:/ {print $2}')

strength=$(iw dev wlp0s20f3 link | awk '/SSID:/ {ssid=$2} /signal:/ {print ssid,$2}')

echo "$state $strength"
