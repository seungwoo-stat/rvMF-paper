# rvMF-paper

This repository contains code to reproduce figures and experiments from the paper "Novel Sampling Method for the von Mises--Fisher Distribution" (Kang and Oh, 2023)

`Figures-upload.R` reproduces Figures 1 and 2.

`Experiments-upload.R` reproduces Tables 1, 2 and 3. It also reproduces experiments in the paper.

Experiments were conducted on the machine with the following session information:

``` r
sessionInfo()
#> R version 3.6.3 (2020-02-29)
#> Platform: x86_64-pc-linux-gnu (64-bit)
#> Running under: Ubuntu 18.04.5 LTS
#> 
#> Matrix products: default
#> BLAS:   /usr/lib/x86_64-linux-gnu/blas/libblas.so.3.7.1
#> LAPACK: /usr/lib/x86_64-linux-gnu/lapack/liblapack.so.3.7.1
#> 
#> locale:
#>  [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C              
#>  [3] LC_TIME=en_US.UTF-8        LC_COLLATE=en_US.UTF-8    
#>  [5] LC_MONETARY=en_US.UTF-8    LC_MESSAGES=en_US.UTF-8   
#>  [7] LC_PAPER=en_US.UTF-8       LC_NAME=C                 
#>  [9] LC_ADDRESS=C               LC_TELEPHONE=C            
#> [11] LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C       
#> 
#> attached base packages:
#> [1] stats     graphics  grDevices utils     datasets  methods   base     
#> 
#> other attached packages:
#> [1] Rfast_2.0.7          RcppZiggurat_0.1.6   rotasym_1.1.5       
#> [4] Rcpp_1.0.10          microbenchmark_1.4.9 rvMF_0.0.8          
#> 
#> loaded via a namespace (and not attached):
#>  [1] rstudioapi_0.13 knitr_1.30      magrittr_2.0.1  rlang_1.0.6    
#>  [5] fastmap_1.1.1   stringr_1.4.0   highr_0.8       tools_3.6.3    
#>  [9] parallel_3.6.3  xfun_0.20       cli_3.6.0       withr_2.5.0    
#> [13] htmltools_0.5.4 yaml_2.2.1      digest_0.6.27   lifecycle_1.0.3
#> [17] fs_1.6.1        glue_1.4.2      evaluate_0.14   rmarkdown_2.6  
#> [21] reprex_2.0.2    stringi_1.5.3   compiler_3.6.3
```

### Reference

-   Seungwoo Kang and Hee-Seok Oh. (2023) Novel Sampling Method for the von Mises--Fisher Distribution. *Statistics and Computing*. To appear.
