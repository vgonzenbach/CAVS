library(neurobase)
library(ANTsR)
library(extrantsr)
library(fslr)
library(stringr)

#' Registers flair to fixed_img
p <- argparser::arg_parser("Run JLF segmentation", hide.opts = FALSE)
p <- argparser::add_argument(p, "--moving", help = "Moving image")
p <- argparser::add_argument(p, "--fixed", help = "Fixed image")
p <- argparser::add_argument(p, "--interp", help = "Which interpolation method", default='welchWindowedSinc')
p <- argparser::add_argument(p, "--n4", help = "Whether to run N4", default=TRUE)
p <- argparser::add_argument(p, "--outpath", help = "Output path")
argv <- argparser::parse_args(p)

if (argv$n4){
    moving <- bias_correct(argv$moving, "N4")
    fixed <- bias_correct(argv$fixed, "N4")
} else {
    moving <- neurobase::readnii(argv$moving)
    fixed <- neurobase::readnii(argv$fixed)
}
message('Computing transformation...')
transformation = antsRegistration(fixed = extrantsr::oro2ants(fixed), 
                                 moving = extrantsr::oro2ants(moving),
                                 typeofTransform = "Rigid",
                                 verbose = TRUE)

message('Applying transformation...')                            
moving_reg = antsApplyTransforms(fixed=extrantsr::oro2ants(fixed), 
                                moving=extrantsr::oro2ants(moving),
                                transformlist = transformation$fwdtransforms,
                                interpolator = argv$interp,
                                verbose = TRUE)

message('Saving transformed image...')
antsImageWrite(moving_reg, argv$outpath)
message('Registration complete.')