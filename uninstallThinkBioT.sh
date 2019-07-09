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
  echo '>>> Uninstall ThinkBioT'
  #check if folder is deleted
  if [ -d "ThinkBioT" ]; then
	cd ~
	# stop tbt service
	systemctl stop tbt.service || ((ERR++))
	sleep 5
	# delete service
	rm /lib/systemd/system/tbt.service || ((ERR++))
	# delete ThinkBioT directory
	rm -r ThinkBioT || ((ERR++))
  else
    echo 'Seems ThinkBioT is uninstalled already, skip this step.'
  fi
fi

echo
if [ $ERR -eq 0 ]; then
  echo '>>> ThinkBioT Uninstalled. Please reboot your Pi :-)'
else
  echo '>>> Something went wrong. Please check the messages above :-('
fi