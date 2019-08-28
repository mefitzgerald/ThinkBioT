# Sample edge tpu model for Raspberry pi 3B+

## Specific Dependencies
Tensorflow 1.13.1
Google Coral USB installed
 
## To use 
Simply run the following the command line
"""
python3 classify_spect.py \
--model models_edge_ICN6523845954615069405_2019-08-18_05-37-53-123_edgetpu-tflite_edgetpu_model.tflite \
--label models_edge_ICN6523845954615069405_2019-08-18_05-37-53-123_edgetpu-tflite_dict.txt \
--image galerita002.png
"""

