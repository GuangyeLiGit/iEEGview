#!/bin/bash
# first arg is fs install directory, second arg is subject directory, third arg is subject ID

# sets up freesurfer
export FREESURFER_HOME=$1/freesurfer
source $FREESURFER_HOME/SetUpFreeSurfer.sh

mris_extract_main_component $2.pial-outer $2.pial-outer-main
mris_smooth -nw -n 30 $2.pial-outer-main $2.pial-outer-smoothed

