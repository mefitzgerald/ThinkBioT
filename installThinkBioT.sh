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

echo '================================================================================'
echo '|                                                                              |'
echo '|                   ThinkBioT Software Installation Script                     |'
echo '|                                                                              |'
echo '================================================================================'

# install ThinkBioT test
if [ $ERR -eq 0 ]; then
  echo '>>> Install ThinkBioT'
  if [ -d "ThinkBioT2" ]; then
    echo 'ThinkBioT is installed already, skip this step.'
  else
    echo '>>> Making Directory'
    mkdir ThinkBioT
   
    echo '>>> Install dependencies'
    # Install rasbian packages
    PACKAGES="git sox sqlite3 python-scipy=0.18.1-2 python-numpy=1:1.12.1-3 python-matplotlib git screen usbutils"
    apt-get install $PACKAGES -y || ((ERR++))  
  
    # Install Python packages
    pip install pyyaml==5.1.1 || ((ERR++))
    pip install pyserial || ((ERR++))
  
    # get RockBlock files
    git clone https://github.com/MakerSnake/pyRockBlock || ((ERR++))
  
    # get ThinkBioT install files
    wget https://github.com/mefitzgerald/ThinkBioT/raw/master/ThinkBioT/tbtzip.zip -O tbtzip.zip || ((ERR++))
    # unzip files
    unzip tbtzip.zip -d ThinkBioT || ((ERR++))
    # move to directory files were unzipped to 
    cd ThinkBioT
  
    # make files executable
    chmod +x tbt_Start.py || ((ERR++))
    chmod +x tbt_DB_Ini.py	|| ((ERR++))
    chmod +x transmit.sh || ((ERR++))
    chmod +x tbt_mode_updater.sh || ((ERR++))
    
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
  
    #setup sqlite database
    echo '>>> Create ThinkBioT database'
    python3 tbt_DB_Ini.py
    sleep 1
	#leave in for option to clear db
    #rm tbt_DB_Ini.py 
    #rm tbt_dbSchema.sql
    
    echo '>>> Create Index calculation files'  
    mkdir AcousticIndices
    # populate AcousticIndices
    mv -i arecord.sh ./AcousticIndices/arecord.sh || ((ERR++))
    mv -i acoustic_index.py ./AcousticIndices/acoustic_index.py || ((ERR++))
    mv -i compute_indice.py ./AcousticIndices/compute_indice.py || ((ERR++))
    mv -i tbt_indexprocess.py ./AcousticIndices/tbt_indexprocess.py || ((ERR++))
    mv -i AI_README.md ./AcousticIndices/AI_README.md || ((ERR++))
    mv -i AI_LICENSE.txt ./AcousticIndices/AI_LICENSE.txt || ((ERR++))
    mv -i __init__.py ./AcousticIndices/__init__.py || ((ERR++))
    # set executable
    chmod +x ./AcousticIndices/tbt_indexprocess.py || ((ERR++))
    chmod +x ./AcousticIndices/arecord.sh || ((ERR++))
    # create required directories
    mkdir ./AcousticIndices/yaml
    #populate yaml/tbt_index.yaml
    mv -i tbt_index.yaml ./AcousticIndices/yaml/tbt_index.yaml || ((ERR++))
    mkdir ./AcousticIndices/IAudioIn
    
    echo '>>> Create Classification calculation files'
    # move files for classification calculation
    mkdir ./ClassProcess
    mkdir ./ClassProcess/CAudioIn	
    mkdir ./ClassProcess/CModel
    mkdir ./ClassProcess/CSpectrograms
    mv -i trecord.sh ./ClassProcess/trecord.sh || ((ERR++))
    mv -i classify_spect.py ./ClassProcess/CModel/classify_spect.py || ((ERR++))
    mv -i classify_spect.py ./ClassProcess/CModel/auto_classify_spect.py || ((ERR++))
    chmod +x ./ClassProcess/trecord.sh || ((ERR++))
    chmod +x ./ClassProcess/CModel/classify_spect.py || ((ERR++))
    chmod +x ./ClassProcess/CModel/auto_classify_spect.py || ((ERR++))
	cd ..
    chown -R pi:pi ThinkBioT
	chown -R pi:pi tbt_database
	chown -R pi:pi pyRockBlock
    sleep 2
    rm tbtzip.zip
  fi
fi

echo
if [ $ERR -eq 0 ]; then
  echo '>>> All done. Please reboot your Pi :-)'
else
  echo '>>> Something went wrong. Please check the messages above :-('
fi

