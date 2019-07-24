#!/bin/bash
for i in *.mp3
do
    sox "$i" "converted/$(basename -s .mp3 "$i").wav"
done