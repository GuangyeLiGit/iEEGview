#!/bin/bash
# first arg is fs install directory, second arg is subject directory, third arg is subject ID

# sets up freesurfer
export FREESURFER_HOME=$1/freesurfer
source $FREESURFER_HOME/SetUpFreeSurfer.sh

# removes unnecessary files
rm $2/NIfTI/MRI/means* $2/NIfTI/MRI/rs* $2/NIfTI/CT/s*

# opens ct and mri in freeview
freeview -v $2/NIfTI/MRI/s*.img -v $2/NIfTI/CT/rs*.img
