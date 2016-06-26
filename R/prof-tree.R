#' @title Summarise Output of R Sampling Profiler
#' @description Summarise the output of the \code{\link{Rprof}} function to show the amount of time used by different R functions as tree structure.
#' @param filename Name of a file produced by \code{Rprof()}.
#' @return An object of \code{ProfTree} and \code{Node} classes.
#' @include parse.R env.R
#' @importFrom data.tree FromDataFrameTable isNotRoot isNotLeaf Aggregate SetFormat FormatPercent
#' @export
#' @seealso \code{\link{Rprof}} \code{\link{summaryRprof}} \code{\link[data.tree]{plot.Node}}
#' @examples
#' Rprof(tmp <- tempfile())
#' example(glm)
#' Rprof(NULL)
#' tree <- prof.tree(tmp)
#' print(tree, limit = 20)
#' unlink(tmp)
#'
prof.tree <- function(filename = "Rprof.out") {
    tree <- FromDataFrameTable(parse_log(filename))
    tree$Set(real = 0, filterFun = function(node) is.null(node$real))
    tree$Set(percent = 0, filterFun = function(node) is.null(node$percent))
    tree$Do(function(node) node$real <- node$real + Aggregate(node, "real", sum),
            traversal = "post-order", filterFun = isNotLeaf)
    tree$Do(function(node) node$percent <- node$percent + Aggregate(node, "percent", sum),
            traversal = "post-order", filterFun = isNotLeaf)
    tree$Do(function(node) node$env <- get_envname(node$name), filterFun = isNotRoot)
    tree$Do(function(node) node$name <- sprintf("`%s`", node$name), filterFun = isNotRoot)
    if ("line" %in% res$fieldsAll) {
        tree$Do(function(node) node$file <- node$parent$file,
                traversal = "pre-order", filterFun = function(node) is.null(node$file))
        tree$Do(function(node) node$line <- node$parent$line,
                traversal = "pre-order", filterFun = function(node) is.null(node$line))
    }
    SetFormat(tree, "percent", function(x) FormatPercent(x, digits = 1))
    class(tree) <- c("ProfTree", class(tree))
    return(tree)
}

#' @param x A \code{ProfTree} object.
#' @param limit The maximum number of nodes to print. Can be \code{NULL} if the entire tree should be printed.
#' @param ... not used.
#' @rdname prof.tree
#' @export
#'
print.ProfTree <- function(x, limit = 25, ...) {
    if ("line" %in% res$fieldsAll)
        NextMethod("print", x, "real", "percent", "env", "file", "line",
                   pruneMethod = "dist", limit = limit)
    else
        NextMethod("print", x, "real", "percent", "env",
                   pruneMethod = "dist", limit = limit)
}
