#!/bin/bash
# to run use ./trecord.sh

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

cd /home/pi/ThinkBioT/ClassProcess/CAudioIn

cmd="SELECT * FROM Settings WHERE SettingActive = 1"
IFS=$'|'
TBT=(`sqlite3 /home/pi/tbt_database "$cmd"`)

Tr_Sil_dur="${TBT[5]}"
# echo $Tr_Sil_dur
Tr_Sil_dur_perc="${TBT[6]}"
# echo $Tr_Sil_dur_perc
Tr_Sil_below_dur="${TBT[7]}"
# echo $Tr_Sil_below_dur
Tr_Sil_below_dur_perc="${TBT[8]}"
# echo $Tr_Sil_below_dur_perc
Tr_Hpfilter="${TBT[9]}"
# echo $Tr_Hpfilter

# timeout loops for 10 seconds
timeout 10 rec -c1 -r 48000 record.wav sinc $Tr_Hpfilter silence 1 $Tr_Sil_dur $Tr_Sil_dur_perc% 1 $Tr_Sil_below_dur $Tr_Sil_below_dur_perc% : newfile : restart
