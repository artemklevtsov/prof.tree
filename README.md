<!-- README.md is generated from README.Rmd. Please edit that file -->
prof.tree
=========

[![Travis-CI Build Status](https://travis-ci.org/artemklevtsov/prof.tree.svg?branch=master)](https://travis-ci.org/artemklevtsov/prof.tree) [![Coverage Status](https://img.shields.io/codecov/c/github/artemklevtsov/prof.tree/master.svg)](https://codecov.io/github/artemklevtsov/prof.tree?branch=master) [![CRAN Status](http://www.r-pkg.org/badges/version/prof.tree)](https://cran.r-project.org/package=prof.tree)

Provide an alternative profiling data diplay as tree structure.

Installation
------------

To install the latest release version from CRAN with:

``` r
install.packages("prof.tree")
```

To install the development version the `install_github()` function from `devtools` package can be used:

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
unlink(tmp)
#>                               levelName real percent  env
#> 1   *                                   1.50 100.0 %     
#> 2   ¦--`apply`                          0.94  62.7 % base
#> 3   ¦   ¦--`as.matrix`                  0.16  10.7 % base
#> 4   ¦   ¦   °--`as.matrix.data.frame`   0.16  10.7 % base
#> 5   ¦   ¦       °--... 1 nodes w/ 0 sub   NA             
#> 6   ¦   ¦--`aperm`                      0.30  20.0 % base
#> 7   ¦   ¦   °--... 1 nodes w/ 0 sub       NA             
#> 8   ¦   °--`FUN`                        0.04   2.7 %     
#> 9   ¦       °--... 1 nodes w/ 0 sub       NA             
#> 10  ¦--`[<-`                            0.44  29.3 % base
#> 11  ¦   °--`[<-.data.frame`             0.44  29.3 % base
#> 12  ¦       ¦--`order`                  0.26  17.3 % base
#> 13  ¦       ¦   °--... 3 nodes w/ 3 sub   NA             
#> 14  ¦       °--... 1 nodes w/ 6 sub       NA             
#> 15  °--`-`                              0.12   8.0 % base
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
