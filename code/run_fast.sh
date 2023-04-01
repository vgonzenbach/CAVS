#!/bin/bash
module load fsl
cd $(dirname $0)/..

for t1 in $(find bidsdata -name '*desc-brain_T1w.nii.gz'); do 

    sub=$(echo $t1 | cut -d/ -f2)
    out_file=$(dirname $t1)/${sub}_label-WM_mask.nii.gz
    bsub -oo fastlog -eo fastlog Rscript -e "fast_seg <- neurobase::readnii('$t1') |> fslr::fast(retimg = TRUE, bias_correct = FALSE); neurobase::writenii(fast_seg == 3, '$out_file')"
done