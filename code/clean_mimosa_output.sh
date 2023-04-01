#!/bin/bash
cd $(dirname $0)/..

for anat in $(find bidsdata -name 'anat'); do 
    # get subject
    sub=$(echo $anat | cut -d/ -f2)
    # move outputs
    mv $anat/t1_ss.nii.gz $anat/${sub}_desc-brain_T1w.nii.gz
    mv $anat/flair_ss.nii.gz  $anat/${sub}_desc-brain_FLAIR.nii.gz
    mv $anat/brainmask.nii.gz $anat/${sub}_label-brain_mask.nii.gz
    mv $anat/probability_map.nii.gz $anat/${sub}_mimosa_probability_map.nii.gz
    mv $anat/mimosa_binary_mask_0.2.nii.gz $anat/${sub}_mimosa_binary_mask_0.2.nii.gz
    # remove unused
    rm $anat/*.RData $anat/flair_* $anat/t1_* 
done
