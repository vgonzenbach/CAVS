## CAVS

This repository contains code for preprocessing and analyzing the CAVS (Cerebral Aneurysm Vulnerability Study) neuroimaging dataset.

## Scripts

- `bidsify_data.sh`: converts the input dataset to comply with the Brain Imaging Data Structure (BIDS) format. It creates a new directory called "bidsdata1" and organizes the data in subdirectories according to the BIDS specification. The T1, T2 FLAIR, and T2* post gadolinium contrast MRI images are renamed and moved to the appropriate directory structure.

- `reg.R` and `run_reg.sh`: registers T1 and FLAIR images to T2* MRI images using ANTsR. The resulting registered images are saved as NIfTI files.

- `run_mimosa.sh`: runs the MIMoSA segmentation pipeline on T1 and FLAIR MRI images using a Singularity Container. The resulting probability and binary maps are saved as NIfTI files.

- `run_fast.sh`: performs tissue segmentation using FSL's FAST algorithm on T1 MRI images. The resulting white matter masks are saved as NIfTI files.

- `frangi.R`: computes frangi filters for T2* MRI images using the ANTsR and c3d packages. The resulting vein masks are saved as NIfTI files.

- `run_frangi.sh`: runs the frangi filter and vein mask generation pipeline on T2* MRI images in the input dataset. It saves the resulting vein masks as NIfTI files.

- `stat_frangis.R`: computes the quantile distribution of frangi filters for each subject in the input dataset and saves the results as a CSV file.

- `eda_frangi.R`: performs exploratory data analysis on frangi filters in the CAVS dataset. It generates two graphs: one showing the quantile distribution of frangi filters in the CAVS data, and the other showing the same distribution after rescaling each image to a range between 0 and 1. This script was used to select an appropiate treshold. 

- `make_vein_mask.R`: generates vein masks from the frangi filter images using a thresholding approach. The resulting vein masks are saved as NIfTI files.

- `clean_output.sh`: cleans up the output of previous scripts by renaming and moving files generated during image processing to their proper BIDS-compliant names and directory structure. It also removes unused files - this ensures dataset is as light as possible to speed up uploads to Box.


## Helper scripts

- `download_data.py`: Use the Box API to download the zipped folders in a nested directory structure.
- `unzip_data.sh`: Unzips files.
- `filter_data.sh`: Filters processed data and copies relevant files to a new directory.



## Usage

To use these scripts, clone this repository and run the scripts in the following order:

1. `bidsify_data.sh`
2. `run_reg.sh`
3. `run_mimosa.sh`
4. `run_fast.sh`
5. `run_frangi.sh`
6. `make_vein_mask.R`
7.  `clean_output.sh`

## Download scripts

A few scripts that are not part of the main pipeline, but that assist in downloading are included. These are:

- `download_data.py`: Use the Box API to download the zipped folders in a nested directory structure.
- `unzip_data.sh`: Unzips files after downloading
- `filter_data.sh`: Filters processed data and copies relevant files to a new directory.

## Requirements

These scripts require the following software:

+ FSL (version 6.0.1 or later)
+ ANTs (version 2.3.1 or later)
+ R (version 3.6.1 or later)
+ R packages: ggplot2, purrr, scales, dplyr, stringr, extrantsr, neurobase, argparser, parallel, future, and neuroim.

## Data

The input data for these scripts is not included in this repository. It must be obtained separately and organized according to the following directory structure:

```
data_processed
├── sub-01  
│   ├── T1_acpc.nii.gz  
│   ├── T2_FLAIR_acpc.nii.gz  
│   └── T2_star_post_acpc.nii.gz  
├── sub-02  
│   
```
