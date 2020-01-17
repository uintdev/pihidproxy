#!/bin/bash
devicename="Bluetooth Keyboard"

echo "Finding BT device *$devicename* ..."
scan=$(sudo hcitool scan)
found=$(grep "$devicename" <<< $scan)
if [ $? -eq 0 ]
then
        mac=$(cut -f 2 <<< $found)
        echo $mac
        sudo bluetoothctl agent on
        sudo rfcomm bind 0 $mac
        sudo rfcomm connect 0 $mac
        sudo bluetoothctl pair $mac
        sudo bluetoothctl trust $mac
        sudo bluetoothctl connect $mac
else
        echo not found
fi
