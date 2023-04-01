#!/bin/bash
# Run mimosa with container
cd $(dirname $0)/..

module load singularity
export TMPDIR=/scratch
export PWD=$(pwd)

for anat in $(find bidsdata -name anat -not -path '*derivatives*'); do

        sub=$(echo $anat | cut -d/ -f2)
        t1=$(find $anat -name '*T1w.nii.gz' | xargs -n1 basename )
        flair=$(find $anat -name '*FLAIR.nii.gz' | xargs -n1 basename)

        bsub -J mimosa_${sub} -oo logs/mimosa/$sub -eo logs/mimosa/$sub singularity exec --cleanenv -B ${PWD} -B ${TMPDIR} \
                /project/singularity_images/mimosa_0.3.0.sif /run.R \
                --indir $anat \
                --outdir $anat \
                --flair $flair \
                --t1 $t1 \
                --strip bet \
                --n4 \
                --debug \
                --whitestripe
        
done