#!/bin/bash
cd $(dirname $0)/..

for anat in $(find bidsdata -name 'anat'); do 
    # get subject
    sub=$(echo $anat | cut -d/ -f2)
    # move outputs
    #mv $anat/t1_ss.nii.gz $anat/${sub}_space-T2starw_desc-brain_T1w.nii.gz
    #mv $anat/flair_ss.nii.gz  $anat/${sub}_space-T2starw_desc-brain_FLAIR.nii.gz
    #mv $anat/brainmask.nii.gz $anat/${sub}_space-T2starw_label-brain_mask.nii.gz
    #mv $anat/mimosa_probability_map.nii.gz $anat/${sub}_space-T2starw_label-mimosa_probseg.nii.gz
    #mv $anat/mimosa_binary_mask_0.2.nii.gz $anat/${sub}_space-T2starw_label-mimosa_desc-0.2_mask.nii.gz
    #
    ## change these in their own scripts and delete these lines
    #mv $anat/${sub}_label-WM_mask.nii.gz $anat/${sub}_space-T2starw_label-WM_mask.nii.gz
    #mv $anat/${sub}_acq-postgad_frangi.nii.gz $anat/${sub}_acq-postgad_space-T2starw_frangi.nii.gz 
    mv  $anat/${sub}_acq-postgad__space-T2starw_label-vein_mask.nii.gz  $anat/${sub}_acq-postgad_space-T2starw_label-vein_mask.nii.gz 
    # remove unused
    rm $anat/${sub}_FLAIR.nii.gz $anat/${sub}_T1w.nii.gz $anat/${sub}_space-T2starw_FLAIR.nii.gz $anat/*.RData $anat/t1*  $anat/flair*
done
