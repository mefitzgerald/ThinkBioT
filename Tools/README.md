# Tools

## Dependencies
Directory mad-lame-libs contains the libraries required for mp3 conversion    
To use download and install [sox](http://sox.sourceforge.net/) and [exiftool](https://www.sno.phy.queensu.ca/~phil/exiftool/)  
Add libmad-0.dll and libmp3lame-0.dll to the folder where SOX was installed    

## Examples
### tbt_csv_example.sh   
How read in files and file data from csv (esc50 dataset used in example)   

### tbt_exif_example.sh  
How to convert from mp3 to wav and access mp3 metadata (xeno-canto data used in example)  

### tbt_spect_example.sh 
Generates a dataset label csv file for GoogleAutoML and converts wav files to spectrograms ready for upload.
NOTE: Script should be run in a directory with directories of wav forms, each directory should have the   
class name as directory name. 

### tbt_spect_example.sh    
Make a single spectrogram     

### testTRansmit.py  
Test rockblock with ThinkBioT data   


