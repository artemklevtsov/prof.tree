#' @title Summarise Output of R Sampling Profiler
#' @description Summarise the output of the Rprof function to show the amount of time used by different R functions.
#' @param filename Name of a file produced by Rprof().
#' @include parse.R env.R
#' @importFrom data.tree FromDataFrameTable isNotRoot isNotLeaf Aggregate SetFormat FormatPercent
#' @export
#' @examples
#' \dontrun{
#' Rprof()
#' some code to be profiled
#' Rprof(NULL)
#' prof.tree()
#' }
#'
prof.tree <- function(filename = "Rprof.out") {
    calls <- parse_log(filename)
    tree <- FromDataFrameTable(calls)
    tree$Set(real = 0, filterFun = function(node) is.null(node$real))
    tree$Set(percent = 0, filterFun = function(node) is.null(node$percent))
    tree$Do(function(node) node$real <- node$real + Aggregate(node, "real", sum),
            traversal = "post-order", filterFun = isNotLeaf)
    tree$Do(function(node) node$percent <- node$percent + Aggregate(node, "percent", sum),
            traversal = "post-order", filterFun = isNotLeaf)
    tree$Do(function(node) node$env <- fun_env(node$name), filterFun = isNotRoot)
    SetFormat(tree, "percent", function(x) FormatPercent(x, digits = 2))
    class(tree) <- c("ProfTree", class(tree))
    return(tree)
}

#' @importFrom data.tree ToDataFrameTree
#' @export
print.ProfTree <- function(x, ...) {
    print(ToDataFrameTree(x, "real", "percent", "env"))
}
