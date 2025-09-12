#!/bin/sh

if bluetoothctl show | grep -q "Powered: yes"; then
    if bluetoothctl devices Connected | grep -q "Device";then 
        echo "󰂰" 
    else
        echo "󰂯" 
    fi

else
    echo "󰂲"
fi
