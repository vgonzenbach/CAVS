#!/bin/bash
cd $(dirname $0)/..

for img in $(find data_processed_all -type f); do
    dir=$(dirname $img)
    out_dir=$(echo $dir | sed 's/data_processed_all/data_processed/g')
    mkdir -p $out_dir
    #cp $dir/T1_acpc.nii.gz  $out_dir/T1_acpc.nii.gz 
    #cp $dir/T2_FLAIR_acpc.nii.gz  $out_dir/T2_FLAIR_acpc.nii.gz
    #cp $dir/T2_star_post_acpc.nii.gz  $out_dir/T2_star_post_acpc.nii.gz 
    cp $dir/T2_star_acpc.nii.gz  $out_dir/T2_star_acpc.nii.gz
done