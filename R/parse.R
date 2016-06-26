parse_log <- function(filename) {
    stopifnot(is.character(filename))
    stopifnot(length(filename) == 1L)
    if (!file.exists(filename))
        stop(sprintf("File '%s' does not exists.", filename))
    proflog <- scan(filename, what = "character", quote = "\"", sep = "\n",
                    strip.white = TRUE, multi.line = FALSE, quiet = TRUE)
    if (length(proflog) < 2L)
        stop(sprintf("'%s' file is empty.", filename))
    metadata <- get_prof_info(proflog[1L])
    proflog <- proflog[-1L]
    calls <- unique(proflog, fromLast = TRUE)
    if (metadata$line.profiling) {
        ind <- grep("#File ", calls, fixed = TRUE)
        fnames <- sub("#File \\d+: ?", "", calls[ind])
        calls <- calls[-ind]
        tmp <- strsplit(gsub(".*(\\d#\\d).*", "\\1", calls), "#", fixed = TRUE)
        tmp <- lapply(tmp, as.integer)
        fnums <- vapply(tmp, .subset2, 1L, FUN.VALUE = 1L)
        files <- fnames[fnums]
        lines <- vapply(tmp, .subset2, 2L, FUN.VALUE = 1L)
    }
    real.time <- tabulate(match(proflog, calls)) * metadata$interval
    total.time <- sum(real.time)
    pct.time <- real.time / total.time
    calls <- remove_extra_info(calls, metadata)
    calls <- remove_source_frame(calls)
    calls <- lapply(strsplit(calls, split = " ", fixed = TRUE), rev)
    calls <- vapply(calls, function(x) paste(c(" \u00B0", x), collapse = "/"), character(1L))
    res <- list(pathString = calls, real = real.time, percent = pct.time)
    if (metadata$line.profiling)
        res <- append(res, list(file = files, line = lines))
    class(res) <- "data.frame"
    attr(res, "row.names") <- .set_row_names(length(calls))
    res
}

get_prof_info <- function(firstline) {
    list(line.profiling = grepl("line profiling", firstline, fixed = TRUE),
         memory.profiling = grepl("memory profiling", firstline, fixed = TRUE),
         gc.profiling = grepl("GC profiling", firstline, fixed = TRUE),
         interval = as.numeric(strsplit(firstline, "=", fixed = TRUE)[[1L]][2L]) / 1e6)
}

remove_source_frame <- function(calls) {
    pattern <- " eval eval withVisible source$"
    ind <- grep(pattern, calls)
    if (length(ind) == length(calls))
        calls <- sub(pattern, "", calls)
    calls
}

remove_extra_info <- function(calls, meta) {
    if (!any(unlist(meta[-4])))
        return(calls)
    if (meta$line.profiling)
        calls <- gsub("\\d+#\\d+", "", calls)
    if (meta$memory.profiling)
        calls <- gsub("^:.*:", "", calls)
    if (meta$gc.profiling)
        calls <- gsub("<GC>", "", calls, fixed = TRUE)
    calls <- calls[nzchar(calls)]
    gsub("(?<=[\\s])\\s*|^\\s+|\\s+$", "", calls, perl = TRUE)
}
