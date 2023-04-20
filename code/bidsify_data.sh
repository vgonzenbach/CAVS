#!/bin/bash
# BIDSify dataset

cd $(dirname $0)/..
mkdir -p bidsdata1/
for f in $(find data_processed -type f); do 
    sub=$(echo $f | cut -d/ -f2 | sed 's/_\|-//g')

    case $(basename $f) in
      T1_acpc.nii.gz)
        bids_path=bidsdata1/sub-${sub}/anat/sub-${sub}_T1w.nii.gz
      ;;
      T2_FLAIR_acpc.nii.gz)
        bids_path=bidsdata1/sub-${sub}/anat/sub-${sub}_FLAIR.nii.gz
      ;;
      T2_star_post_acpc.nii.gz)
        bids_path=bidsdata1/sub-${sub}/anat/sub-${sub}_acq-postgad_T2starw.nii.gz
      ;;
    esac

    mkdir -p $(dirname $bids_path)
    if ! [ -e $bids_path ]; then
        bsub -J bids -oo tmplog -eo tmplog cp $f $bids_path
    fi
done

echo '{
  "Name": "CAVS",
  "BIDSVersion": "1.9.6",
  "Authors": ["Organized by Virgilio Gonzenbach"]
}' > bidsdata1/dataset_description.json
