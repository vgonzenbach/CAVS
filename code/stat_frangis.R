library(dplyr)
library(stringr)

frangis <- system("find bidsdata -name '*frangi*'", intern=TRUE)

get_sub <- function(path) stringr::str_split(path, "/")[[1]][2]
get_quant_df <- function(path){
  img <- neurobase::readnii(path)
  df <- data.frame(value = img[img > 0] |> quantile(seq(0,1,.01)),
                   percentile = seq(0, 100)) 
  rownames(df) <- NULL
  return(df)
}

subs <- purrr::map(frangis, get_sub) |> 
  purrr::reduce(c)
df <- parallel::mclapply(frangis, 
                   get_quant_df,
                   mc.cores = future::availableCores()) |>
  setNames(subs) %>%
  dplyr::bind_rows(.id = 'sub')

write.csv(df, here::here('frangi_quantiles.csv'))
