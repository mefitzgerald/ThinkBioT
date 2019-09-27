# Copyright 2019 Google LLC & Marita Fitzgerald
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# Amended by Marita Fitzgerald 2019


# To run classification with demo model
"""
python3 classify_spect.py \
--model edgetpu-tflite_edgetpu_model.tflite \
--label edgetpu-tflite_dict.txt \
--image Sonus.png
"""

import argparse
import re
from edgetpu.classification.engine import ClassificationEngine
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
    parser.add_argument(
        '--model', help='File path of Tflite model.', required=True)
    parser.add_argument(
        '--label', help='File path of label file.', required=True)
    parser.add_argument(
        '--image', help='File path of the image to be recognized.', required=True)
    args = parser.parse_args()
    # Prepare labels.
    labels = ReadLabelFile(args.label)
    # Initialize engine.
    engine = ClassificationEngine(args.model)
    # Run inference.
    img = Image.open(args.image)
    for result in engine.ClassifyWithImage(img, top_k=3):
        print('---------------------------')
        print(labels[result[0]])
        print('Score : ', result[1])


if __name__ == '__main__':
    main()
