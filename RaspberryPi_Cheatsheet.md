# Raspberry Pi


## Internet
Get system info (e.g. IP): `ifconfig`

Get network info: `iwconfig`

Get hostname: `hostname`

Get hostname IP: `hostname -I`

Check for all connected USB devices: `lsusb`

## System

Configure Raspberry Pi: `sudo raspi-config`

Reboot system: `sudo reboot`

Shutdown: `sudo shutdown -h now`

Update system: `sudo apt-get update` & `sudo apt-get upgrade`

## Audio

Check ALSA modules `cat /proc/asound/modules`

View Audio Hardware `cat /proc/asound/cards`

View information on selected card (use Audio Hardware query to get card no) `amixer -c <card index no>`




### Setup
- [Via interface](http://youtu.be/sXDqMapgU_M)
- [Via terminal](http://www.maketecheasier.com/setup-wifi-on-raspberry-pi/)
