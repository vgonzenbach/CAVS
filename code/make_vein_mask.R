library(neurobase)
library(parallel)
library(future)
library(dplyr)
library(neuroim)

# read frangi
frangi_paths <- system("find bidsdata -name '*frangi.nii.gz'", intern = TRUE)

# rescale each to 1
get_img_quantile <- function(img, q){
  values <- img %>% 
    as.vector()
  quantile(values[values > 0], q)
}

clean_frangi <- function(path){
  img <- neurobase::readnii(path)
  mask <- img >= get_img_quantile(img, 0.90)
  comps <- neuroim::connComp3D(mask)
  img@.Data <- comps$size > 3
  writenii(img, path |> stringr::str_replace("_frangi", "_label-vein_mask"))
}

frangi_paths |>
  parallel::mclapply(clean_frangi, 
                     mc.cores = future::availableCores())
