#!/bin/sh

data=$(upower -i $(upower -e | grep BAT0))
percentage=$(echo "$data" | grep 'percentage' | awk '{print $2}')
state=$(echo "$data" | grep 'state' | awk '{print $2}')
echo "$percentage $state"
