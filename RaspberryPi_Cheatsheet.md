# Raspberry Pi Debian Quick reference


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

Update system & packages: `sudo apt-get update` & `sudo apt-get upgrade`

Uninstall package (will remove about everything regarding the package packagename, 
but not the dependencies installed with it on installation): `sudo apt-get purge packagename`

Uninstall orphaned packaged dependencies(will also attempt to remove other packages
which were required by packagename on but are not required by 
any remaining packages): `sudo aptitude purge packagename`

Remove orphaned packages: `sudo apt-get autoremove`

## Audio

Check ALSA modules `cat /proc/asound/modules`

View Audio Hardware `cat /proc/asound/cards`

View information on selected card (use Audio Hardware query to get card no) `amixer -c <card index no>`

View Recording devices `arecord -l`

View Playback devices `aplay -l`


### Setup
- [Via interface](http://youtu.be/sXDqMapgU_M)
- [Via terminal](http://www.maketecheasier.com/setup-wifi-on-raspberry-pi/)
