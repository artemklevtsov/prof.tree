library(prof.tree)
tmp <- tempfile(fileext = ".log")
x <- runif(10e5)
f <- function(x) {
    c(mean(x), median(x), sd(x))
}
f2 <- function(x) {
    c(sum(x) / length(x), median.default(x), sqrt(sum((x - sum(x) / length(x))^2L) / (length(x) - 1L)))
}
Rprof(tmp, interval = 0.01)
for (i in 1:100) f(x)
for (i in 1:100) f2(x)
Rprof(NULL)
tree <- prof.tree(tmp)
tree
unlink(tmp)
