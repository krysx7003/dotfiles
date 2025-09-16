#!/bin/bash

WIRED_IF="eno1"
WIRELESS_IF="wlp0s20f3"

if ip link show $WIRED_IF 2>/dev/null | grep -q "state UP"; then
    echo "󰈀"
    exit 0
fi

if iwconfig $WIRELESS_IF 2>/dev/null | grep -q "ESSID"; then
    SIGNAL=$(iwconfig $WIRELESS_IF | grep "Quality" | awk '{print $2}' | cut -d= -f2 | cut -d/ -f1)
    if [ $SIGNAL -gt 75 ]; then
        echo "󰤨"
    elif [ $SIGNAL -gt 50 ]; then
        echo "󰤥"
    elif [ $SIGNAL -gt 25 ]; then
        echo "󰤢"
    else
        echo "󰤟"
    fi
    exit 0
fi

# No network
echo "󰤮"
