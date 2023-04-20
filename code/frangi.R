library(extrantsr)
library(fslr)
library(neurobase)
library(argparser)
library(stringr)


getFrangi=function(epi,min.scale=0.5,max.scale=0.5){
  tempinv=tempfile(pattern="file", tmpdir=tempdir(), fileext=".nii.gz")
  writenii(-1*epi,tempinv)
  tempvein=tempfile(pattern="file", tmpdir=tempdir(), fileext=".nii.gz")
  system(paste0("c3d ",tempinv," -hessobj 1 ",min.scale," ",max.scale," -oo ",tempvein))
  
  veinmask=readnii(tempvein)
  return(veinmask)
}

##FSL FAST segmentation for GM, WM, and CSF
p <- arg_parser("Run FAST segmentation")
p <- add_argument(p, "--t2starw", help = 'T2*-weighted image from which to get frangi filter.')
p <- add_argument(p, "--mask", help = 'Mask to apply to T2*')
p <- add_argument(p, "--outdir", help = 'Output directory')
argv <- parse_args(p)

t2star <- neurobase::readnii(argv$t2)

# n4
t2star_n4 <- extrantsr::bias_correct(file=t2star, correction="N4") # n4 bias correction
# outpath <- sprintf("%s/%s", dirname(argv$T2starw), str_replace(basename(argv$T2starw), "_T2", "_desc-preproc_T2"))
# writenii(t2star_n4, outpath)

message("Obtaining Frangi filter")
# frangi filter
mask <- neurobase::readnii(argv$mask)
frangi <- getFrangi(t2star_n4) * mask
outpath <- file.path(argv$outdir, nii.stub(argv$t2starw, bn = TRUE) |> str_replace("_T2starw", "_frangi"))
writenii(frangi,  outpath)
