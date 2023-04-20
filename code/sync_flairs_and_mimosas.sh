#!/bin/bash
# Sync mimosa and flair

for anat in $(ssh takim find /home/vgonzenb/CAVS/bidsdata -name 'anat'); do
    sub=$(echo $anat | cut -d/ -f6)
    FLAIR=$anat/${sub}_FLAIR.nii.gz
    mimosa_mask=$anat/${sub}_mimosa_binary_mask_0.2.nii.gz
    # rsync
    rsync -azv --partial --progress vgonzenb@takim:$FLAIR ${FLAIR#/*/*/*/}
    rsync -azv --partial --progress vgonzenb@takim:$mimosa_mask ${mimosa_mask#/*/*/*/}
done


