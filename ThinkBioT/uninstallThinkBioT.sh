[ -z $BASH ] && { exec bash "$0" "$@" || exit; }
#!/bin/bash
# file: uninstallThinkBioT.sh
#
# This script will uninstall ThinkBioT
# It is recommended to run it in your home directory.
# sudo sh uninstallThinkBioT.sh

# check if sudo is used
if [ "$(id -u)" != 0 ]; then
  echo 'Sorry, you need to run this script with sudo'
  exit 1
fi

# error counter
ERR=0

echo '========================================================================='
echo '|                                                                       |'
echo '|             ThinkBioT Software Uninstall Script                       |'
echo '|                                                                       |'
echo '========================================================================='


# Uninstall ThinkBioT
if [ $ERR -eq 0 ]; then
  echo '>>> Uninstall ThinkBioT Unit'
  #check if unit is already removed
  serviceFound= find -type f -name "tbt.service"
  if [ -n "$serviceFound"]; then
	echo 'tbt.service found, stopping & deleting'
	# stop tbt service
	systemctl stop tbt.service || ((ERR++))
	systemctl daemon-reload || ((ERR++))
	sleep 5
	# delete service
	rm /lib/systemd/system/tbt.service || ((ERR++))
  else
    echo 'tbt.service is uninstalled already, skip this step.'
  fi  
  
  echo '>>> Uninstall ThinkBioT Directory'
  cd ~
  found= find -type d -name "ThinkBioT"
  if [ -n "$found"]; then
	echo 'ThinkBioT found & deleting'
	# delete ThinkBioT directory
	rm -r /home/pi/ThinkBioT || ((ERR++))
  else
    echo 'ThinkBioT is uninstalled already, skip this step.'
  fi
  
  echo '>>> Uninstall ThinkBioT Database'
  cd ~
  rm tbt_database
  
  echo '>>> Uninstall Alsa audio configuration files'
  # delete files
  rm /etc/asound.conf || ((ERR++))
  rm /home/pi/.asoundrc || ((ERR++))
  
  echo '>>> Restore Audio Default settings'
  alsactl init
fi


echo
if [ $ERR -eq 0 ]; then
  echo '>>> ThinkBioT Uninstalled. Please reboot your Pi :-)'
else
  echo '>>> Something went wrong. Please check the messages above :-('
fi