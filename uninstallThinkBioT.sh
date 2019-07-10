[ -z $BASH ] && { exec bash "$0" "$@" || exit; }
#!/bin/bash
# file: uninstallThinkBioT.sh
#
# This script will install required software for testInst V1.
# It is recommended to run it in your home directory.
# Command to download file;
# sudo wget -O uninstallThinkBioT.sh https://github.com/mefitzgerald/ThinkBioT/raw/master/uninstallThinkBioT.sh
# Command to run file
# sudo sh uninstallThinkBioT.sh

# check if sudo is used
if [ "$(id -u)" != 0 ]; then
  echo 'Sorry, you need to run this script with sudo'
  exit 1
fi

# error counter
ERR=0

echo '================================================================================'
echo '|                                                                              |'
echo '|             ThinkBioT Software Uninstall Script                           |'
echo '|                                                                              |'
echo '================================================================================'


# Uninstall ThinkBioT
if [ $ERR -eq 0 ]; then
  echo '>>> Uninstall ThinkBioT Unit'
  #check if unit is already removed
  serviceFound= find -type f -name "tbt.service"
  if [ -n "$serviceFound"]; then
	echo 'tbt.service found, stopping & deleting'
	# stop tbt service
	sudo systemctl stop tbt.service || ((ERR++))
	sudo systemctl daemon-reload || ((ERR++))
	sleep 5
	# delete service
	rm /lib/systemd/system/tbt.service || ((ERR++))
  else
    echo 'tbt.service is uninstalled already, skip this step.'
  fi  
  echo '>>> Uninstall ThinkBioT Directory'
  cd ThinkBioT
  rm -rf ThinkBioT
  cd ~
###
fi

# Uninstall packaged dependencies
#apt-get remove --purge sox python-pip -y ((ERR++))
#apt-get autoremove -y ((ERR++))
#sudo apt-get autoclean ((ERR++))

echo
if [ $ERR -eq 0 ]; then
  echo '>>> ThinkBioT Uninstalled. Please reboot your Pi :-)'
else
  echo '>>> Something went wrong. Please check the messages above :-('
fi