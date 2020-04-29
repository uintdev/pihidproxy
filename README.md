# pihidproxy
Bridge Bluetooth keyboard and mouse to USB (hid proxy)

![Imgur](https://i.imgur.com/cpGkjXw.png)

If you have a bluetooth keyboard, you can't access BIOS or OS without a BT stack.
This project acts as a bridge so the PC only sees a USB keyboard and so works without drivers.
It works by copying keypresses from the bluetooth keyboard to the piZero's USB.

## Requirements:

- Raspberry Pi Zero
- Bluetooth keyboard

## Tested

- Raspbian Buster

## Initial setup:

To pull this off, a few changes have to be made:

```bash
echo "dtoverlay=dwc2" | sudo tee -a /boot/config.txt
echo "dwc2" | sudo tee -a /etc/modules
echo "libcomposite" | sudo tee -a /etc/modules
sudo modprobe g_mass_storage
pip install evdev
```

Ensure the files from this repository are stored under `bash /home/pi/pihidproxy` and run the following:

```bash
chmod +x /home/pi/pihidproxy/*.sh
```

## Setting up service

Run `sudo nano /etc/systemd/system/hidproxy.service` and save the contents below:

```ini
[Unit]
Description=HID Proxy
After=bluetooth.service
Requires=bluetooth.service

[Service]
ExecStart=/home/pi/pihidproxy/start.sh
Restart=on-failure
    
[Install]
WantedBy=multi-user.target
```

Enable the systemd service:

```bash
sudo systemctl enable hidproxy
```

## Device identity

The name or the MAC address of the Bluetooth keyboard will need to go into the value of `devicename` found in `pair.sh`.

## Connecting

If not done so already, the RPi will need to be rebooted.
Before rebooting or powering on the RPi, connect the RPi to the device that the input would be proxied to via USB OTG.
When rebooting or powering on the RPi, put the Bluetooth keyboard into discoverable mode. If the Bluetooth keyboard does not stay in discoverable mode for long or the RPi takes a while to boot, put the Bluetooth keyboard in discoverable mode around the time it would take for the graphical boot screen to be displayed.


| File        | About                                                                           |
| ----------- | ------------------------------------------------------------------------------- |
| pair.sh     | Bash script to pair & connect Bluetooth on boot                                 |
| setuphid.sh | Installs the USB keyboard driver                                                |
| keys.py     | Reads keyboard (e.g. Bluetooth) and translates keycodes, then sends it over USB |
| start.sh    | Execute scripts in order -- used by systemd service                             |

## Troubleshooting

From testing, keyboards that go into a sleep state may have a hard time recovering their connection, meaning having to reboot the RPi.
To help avoid this issue, initially pair the Bluetooth keyboard via the Bluetooth menu on the desktop UI. If not done in the first place, connect a mouse (via USB [receiver]) to the RPi and redo the pairing.

If after installation there is no keyboard input going through to the device that is connected to the RPi via USB OTG at any time, try the following suggestions:
-  Put the keyboard into discoverable mode for around 10 seconds
-  Turn the keyboard off and on
-  Increase or decrease the sleep time in `start.sh` (what is required may need more or less time before `hcitool` is able to properly collect results)
