[ -z $BASH ] && { exec bash "$0" "$@" || exit; }
#!/bin/bash
# file: installThinkBioT.sh
# sudo wget -O installThinkBioT.sh https://github.com/mefitzgerald/ThinkBioT/raw/master/installThinkBioT.sh
# sudo sh installThinkBioT.sh

# LICENSE:
# ThinkBioT is an Bioacoustic sensor framework for the collection, processing
# and satellite transmission of Bio-Taxa Classification and Acoustic Indicies data.
# Copyright (C) 2019  Marita Fitzgerald
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
# 
# SUPPORT:
# https://github.com/mefitzgerald/ThinkBioT/issues

# check if sudo is used
if [ "$(id -u)" != 0 ]; then
  echo 'Sorry, you need to run this script with sudo'
  exit 1
fi

# target directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/ThinkBioT"

# error counter
ERR=0

echo '=============================================================================='
echo '|                                                                            |'
echo '|             ThinkBioT Software Installation Script                         |'
echo '|                                                                            |'
echo '=============================================================================='
echo '    ThinkBioT  Copyright (C) 2019  Marita Fitzgerald '
echo '    This program comes with ABSOLUTELY NO WARRANTY;  '
echo '    This is free software, and you are welcome to redistribute it '
echo '    under certain conditions, For more information view the License at ; '
echo '    https://github.com/mefitzgerald/ThinkBioT/blob/master/LICENSE'


# install ThinkBioT
if [ $ERR -eq 0 ]; then
  echo '>>> Install ThinkBioT'
  #check if folder already exists
  if [ -d "ThinkBioT" ]; then
    echo 'ThinkBioT is installed already, skip this step.'
  else
	echo '>>> Begin ThinkBioT Installation'
	# get installtion files from github
	wget https://github.com/mefitzgerald/ThinkBioT/raw/master/ThinkBioT/tbtzip.zip -O tbtzip.zip || ((ERR++))
    # unzip files
	unzip tbtzip.zip -d ThinkBioT || ((ERR++))
	# move to directory files were unzipped to 
    cd ThinkBioT
	# make files executable
	chmod +x tbt_Start.py || ((ERR++))
	chmod +x tbt_DB_Ini.py	|| ((ERR++))
	chmod +x trecord.sh || ((ERR++))
	
	echo '>>> Set soundBlaster as default audio device'
	# move .asoundrc audio settings file to home
	mv -i .asoundrc ~  || ((ERR++))
	# move asound configuration file
	mv -i asound.conf /etc/asound.conf || ((ERR++))
	
	# move service unit file to systemd file (-i confirms before over writing)
	mv -i tbt.service /lib/systemd/system/tbt.service || ((ERR++))
	echo '>>> Enable start up service'
	# enable service to be started next boot
	systemctl enable tbt.service || ((ERR++))
	
	# Install rasbian packages
	echo '>>> Install dependencies'
	PACKAGES="sox sqlite3 python-scipy python-numpy python-matlplotlib git"
	apt-get install $PACKAGES -y || ((ERR++))
	
	# Install Python packages
	pip install pyyaml
	
	#setup sqlite database
	echo '>>> Create ThinkBioT database'
	python3 tbt_DB_Ini.py
	sleep 1
	rm tbt_DB_Ini.py
	rm tbt_dbSchema.sql
	
	# set ownership of ThinkBioT to pi
	cd ..
	chown -R pi:pi ThinkBioT
    sleep 2
	# delete redundant zip file
	rm tbtzip.zip
	
	echo '>>> Create Index calculation files'
	# move files for index calculation
	cd /home/pi/ThinkBioT
	# create required directories
	mkdir /home/pi/ThinkBioT/AcousticIndices
	# populate AcousticIndices
	mv -i acoustic_index.py /home/pi/ThinkBioT/AcousticIndices/acoustic_index.py || ((ERR++))
	mv -i compute_indice.py /home/pi/ThinkBioT/AcousticIndices/compute_indice.py || ((ERR++))
	mv -i tbt_indexprocess.py /home/pi/ThinkBioT/AcousticIndices/tbt_indexprocess.py || ((ERR++))
	mv -i AI_README.md /home/pi/ThinkBioT/AcousticIndices/AI_README.md || ((ERR++))
	mv -i AI_LICENSE.txt /home/pi/ThinkBioT/AcousticIndices/AI_LICENSE.txt || ((ERR++))
	mv -i __init__.py /home/pi/ThinkBioT/AcousticIndices/__init__.py || ((ERR++))
	# set executable
	chmod +x /home/pi/ThinkBioT/AcousticIndices/tbt_indexprocess.py || ((ERR++))
	# create required directories
	mkdir /home/pi/ThinkBioT/AcousticIndices/yaml
	#populate yaml/tbt_index.yaml
	mv -i tbt_index.yaml /home/pi/ThinkBioT/AcousticIndices/yaml/tbt_index.yaml || ((ERR++))
	mkdir /home/pi/ThinkBioT/AcousticIndices/IAudioIn
	
	echo '>>> Create Classification calculation files'
	# move files for classification calculation
	cd /home/pi/ThinkBioT
	mkdir /home/pi/ThinkBioT/ClassProcess
	mkdir /home/pi/ThinkBioT/ClassProcess/CAudioIn	
  fi
fi

echo
if [ $ERR -eq 0 ]; then
  echo '>>> All done. Please reboot your Pi :-)'
else
  echo '>>> Something went wrong. Please check the messages above :-('
fi
