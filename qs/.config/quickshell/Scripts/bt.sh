#!/bin/sh

power=$(bluetoothctl show | grep "Powered:")
connect=$(bluetoothctl devices Connected)
echo "$power $connect"
