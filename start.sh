#!/bin/sh -
sleep 10
sudo /home/pi/pihidproxy/pair.sh
sudo /home/pi/pihidproxy/setuphid.sh
sudo python /home/pi/pihidproxy/keys.py
