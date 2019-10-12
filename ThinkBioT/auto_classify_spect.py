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

import argparse
import os
import glob
import time
import datetime
import re
import sqlite3
from pathlib import Path
from edgetpu.classification.engine import ClassificationEngine
from edgetpu.utils import dataset_utils
from PIL import Image

# Function to read labels from text files.
def ReadLabelFile(file_path):
    """Reads labels from text file and store it in a dict.
    Each line in the file contains id and description separted by colon or space.
    Example: '0:cat' or '0 cat'.
    Args:
      file_path: String, path to the label file.
    Returns:
      Dict of (int, string) which maps label id to description.
    """
    counter = 0
    with open(file_path, 'r', encoding='utf-8') as f:
        lines = f.readlines()
    ret = {}
    for line in lines:
        ret[int(counter)] = line.strip()
        counter = counter + 1
    return ret

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--taskSessionId', help='taskSessionId number.', required=True)
    parser.add_argument('--epochtime', help='time sample captured.', required=True)
    args = parser.parse_args()
    # Get labels file   
    #os.chdir(os.getcwd())
    os.chdir('/home/pi/ThinkBioT/ClassProcess/CModel')
    for label_file in glob.glob("*.txt"):
        print("LabelFile: " +label_file)       
    # Prepare labels.
    labels = ReadLabelFile(label_file)
    # Get model file   
    for model_file in glob.glob("*.tflite"):       
        print("Model File: " + model_file)       
    # Initialize engine.
    time.sleep( 5 )
    engine = ClassificationEngine(model_file)
    # Prepare database connector & cursor
    try:
        conn = sqlite3.connect('/home/pi/tbt_database')
    except Error:
        print(Error)
    c = conn.cursor()
    # Run inference.
    pathlist = Path('/home/pi/ThinkBioT/ClassProcess/CSpectrograms').glob('**/*.png')
    for path in pathlist:
        # because path is object not string
        path_in_str = str(path)
        print(path_in_str)
        img = Image.open(path_in_str)
        #for result in engine.classify_with_image(img, top_k=10):
        for result in engine.classify_with_image(img, threshold=0.001, top_k=1, resample=0):
            print('---------------------------')
            print(labels[result[0]])
            print('Score : ', result[1])
            c.execute("INSERT INTO ClassTasks(ClassTaskTime, ClassTaskSourceFile, ClassTaskResult, ClassTaskPercent, SessionID) VALUES(?,?,?,?,?)", (args.epochtime, path_in_str, labels[result[0]], str(result[1]), args.taskSessionId))
            conn.commit()
            #Remove processed file
        os.remove(path_in_str)
    conn.close()
    
    #Record Completion in Log  
    f= open("/home/pi/ThinkBioT/tbt_log.txt","a+")
    f.write("auto_classify_spect Completed Classification at : " + str(datetime.datetime.now()) + "\n")
    f.close()
    
    #Update to next process
    os.system('sh /home/pi/ThinkBioT/tbt_update.sh')
        
if __name__ == '__main__':
    main()

# to test python3 auto_classify_spect.py --taskSessionId 1 --epochtime "5566"


