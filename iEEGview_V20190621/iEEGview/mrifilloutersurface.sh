#!/bin/bash
# first arg is fs install directory, second arg is subject directory

# sets up freesurfer
export FREESURFER_HOME=$1/freesurfer
source $FREESURFER_HOME/SetUpFreeSurfer.sh

mris_fill -c -r 1 $2.pial $2.pial.filled.mgz

