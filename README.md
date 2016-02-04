<!-- README.md is generated from README.Rmd. Please edit that file -->
prof.tree
=========

[![Travis-CI Build Status](https://travis-ci.org/artemklevtsov/prof.tree.svg?branch=master)](https://travis-ci.org/artemklevtsov/prof.tree) [![Coverage Status](https://img.shields.io/codecov/c/github/artemklevtsov/prof.tree/master.svg)](https://codecov.io/github/artemklevtsov/prof.tree?branch=master)

Provide an alternative profiling data diplay as tree structure.

Installation
------------

prof.tree is not yet on CRAN; it is currently available from GitHub. Make sure you have the devtools package installed, and then run:

``` r
devtools::install_github("artemklevtsov/prof.tree")
```

Example
-------

``` r
times <- 4e5
cols <- 150
data <- as.data.frame(x = matrix(rnorm(times * cols, mean = 5), ncol = cols))
data <- cbind(id = paste0("g", seq_len(times)), data)
Rprof(tmp <- tempfile())
data1 <- data   # Store in another variable for this run
# Get column means
means <- apply(data1[, names(data1) != "id"], 2, mean)
# Subtract mean from each column
for (i in seq_along(means))
    data1[, names(data1) != "id"][, i] <- data1[, names(data1) != "id"][, i] - means[i]
Rprof(NULL)
library(prof.tree)
prof.tree(tmp)
#>                           levelName real  percent  env
#> 1  calls                            1.38 100.00 %     
#> 2   ¦--apply                        0.92  66.67 % base
#> 3   ¦   ¦--as.matrix                0.12   8.70 % base
#> 4   ¦   ¦   °--... 1 nodes w/ 1 sub   NA              
#> 5   ¦   ¦--aperm                    0.26  18.84 % base
#> 6   ¦   ¦   °--... 1 nodes w/ 0 sub   NA              
#> 7   ¦   °--FUN                      0.04   2.90 %     
#> 8   ¦       °--... 1 nodes w/ 0 sub   NA              
#> 9   ¦--[<-                          0.38  27.54 % base
#> 10  ¦   °--[<-.data.frame           0.38  27.54 % base
#> 11  ¦       °--... 3 nodes w/ 7 sub   NA              
#> 12  ¦--[                            0.02   1.45 % base
#> 13  ¦   °--[.data.frame             0.02   1.45 % base
#> 14  ¦       °--... 1 nodes w/ 0 sub   NA              
#> 15  °---                            0.06   4.35 % base
unlink(tmp)
```

Bug reports
-----------

First check the changes in the latest version of the package. Type type into R:

``` r
news(package = "prof.tree", Version == packageVersion("prof.tree"))
```

Try reproduce a bug with the latest development version from Git.

To report a bug please type into R:

``` r
utils::bug.report(package = "prof.tree")
```

Post the `traceback()` and `sessionInfo()` output also may be helpful.
