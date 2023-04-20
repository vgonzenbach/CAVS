#!/bin/bash
# Script to view DWI with corresponding segmentation on itksnap
get_sub () {
    img=$1
    cut -d/ -f2 <<< $img
}
export -f get_sub

# pair flair to mimosa mask
flair=($(find bidsdata -name '*FLAIR*'))
mask=($(echo ${flair[@]} | xargs -n1 bash -c 'get_sub $0' | xargs -n1 -I{} find bidsdata/derivatives/mimosa -type f -name *{}*0.2.nii.gz))

# check pairs
#paste <(printf "%s\n" "${dwi[@]}") <(printf "%s\n" "${seg[@]}") | xargs -n2 bash -c '[[ `get_sub $0` == `get_sub $1` ]] && echo true || echo false'
# open itksnap with overlay
paste <(printf "%s\n" "${dwi[@]}") <(printf "%s\n" "${seg[@]}") | sed -n '21,40p;' | xargs -n2 bash -c 'itksnap -g "$0" -s "$1"'