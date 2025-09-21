#!/bin/bash

nmcli -t -f active,ssid,signal dev wifi | awk -F: '
$1 == "no" {
    if ($3 > 75) icon = "󰤨"
    else if ($3 > 50) icon = "󰤥"
    else if ($3 > 25) icon = "󰤢"
    else icon = "󰤟"
    print icon " " $2 
}'
