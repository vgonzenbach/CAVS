#!/bin/bash
# Register T1 and FLAIR to T2*
cd $(dirname $0)/..
module load ANTs
module load fsl

for dir in $(find bidsdata -name 'anat'); do
        sub=$(echo $dir | cut -d/ -f2)
        bsub -o logs/reg.log -e logs/reg.log Rscript code/reg.R \
            --moving $dir/${sub}_T1w.nii.gz \
            --fixed $dir/${sub}_acq-postgad_T2starw.nii.gz \
            --outpath $dir/${sub}_space-T2starw_T1w.nii.gz


         bsub -o logs/reg.log -e logs/reg.log Rscript code/reg.R \
            --moving $dir/${sub}_FLAIR.nii.gz \
            --fixed $dir/${sub}_acq-postgad_T2starw.nii.gz \
            --outpath $dir/${sub}_space-T2starw_FLAIR.nii.gz
done