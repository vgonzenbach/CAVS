
#!/binbash
module load ANTs
module load c3d

cd $(dirname $0)/..
mkdir -p logs/frangi
for anat in $(find bidsdata -name anat -not -path '*derivatives*'); do

        sub=$(echo $anat | cut -d/ -f2)
        t2starw=$(find $anat -name '*T2starw.nii.gz')
        mask=$(find $anat -name 'brainmask.nii.gz')

        bsub -J frangi_$sub -oo logs/frangi/$sub -eo logs/frangi/$sub Rscript code/frangi.R \
            --t2starw $t2starw \
            --mask $mask \
            --outdir $anat
done