#!/bin/bash
# first arg is fs install directory, second arg is subject directory, third arg is subject # ID, fourth is the filename of the first dicom file

export FREESURFER_HOME=$1/freesurfer
source $FREESURFER_HOME/SetUpFreeSurfer.sh
recon-all -s $3 \ -i $2/DICOM/MRI/$4 
#-i $2/DICOM/MRI/$4
recon-all -s $3 -all 
#-cw256