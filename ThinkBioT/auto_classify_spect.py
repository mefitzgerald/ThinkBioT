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
import re
import sqlite3
from pathlib import Path
from edgetpu.classification.engine import ClassificationEngine
from PIL import Image

# Function to read labels from text files.
def ReadLabelFile(file_path):
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
    print(args.taskSessionId)
    print(args.epochtime)
    # Get labels file   
    os.chdir(os.getcwd())
    for label_file in glob.glob("*.txt"):
        print(label_file)       
    # Prepare labels.
    labels = ReadLabelFile(label_file)
    # Get labels file   
    os.chdir(os.getcwd())
    for model_file in glob.glob("*.tflite"):
        print(model_file)       
    # Initialize engine.
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
        for result in engine.ClassifyWithImage(img, top_k=3):
            print('---------------------------')
            print(labels[result[0]])
            print('Score : ', result[1])
            c.execute("INSERT INTO ClassTasks(ClassTaskTime, ClassTaskSourceFile, ClassTaskResult, ClassTaskPercent, SessionID) VALUES(?,?,?,?,?)", (args.epochtime, path_in_str, labels[result[0]], str(result[1]), args.taskSessionId))
            conn.commit()
    conn.close()
        
if __name__ == '__main__':
    main()



