# prof.tree

Provied an alternative profiling data diplay as tree structure.

## Installation

prof.tree is not yet on CRAN; it is currently available from GitHub. Make sure you have the devtools package installed, and then run:

```r
devtools::install_github("artemklevtsov/prof.tree")
```

## Example

```r
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
```

## Bug reports

First check the changes in the latest version of the package. Type type into R:

```r
news(package = "prof.tree", Version == packageVersion("prof.tree"))
```

Try reproduce a bug with the latest development version from Git.

To report a bug please type into R:

```r
utils::bug.report(package = "prof.tree")
```

Post the `traceback()` and `sessionInfo()` output also may be helpful.