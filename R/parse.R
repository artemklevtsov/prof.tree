parse_log <- function(filename, remove.frame = c("source", "knitr")) {
    if (filename == "")
        stop("'filename' not specified.")
    proflog <- scan(filename, what = "character", quote = "\"", sep = "\n",
                     strip.white = TRUE, multi.line = FALSE, quiet = TRUE)
    if (length(proflog) < 2L)
        stop(sprintf("'%s' file is empty.", filename))
    first <- proflog[1L]
    proflog <- proflog[-1L]
    interval <- as.numeric(strsplit(first, "=", fixed = TRUE)[[1L]][2L]) / 1e06
    calls <- unique(proflog, fromLast = TRUE)
    if (grepl("line profiling", first, fixed = TRUE))
        calls <- calls[!grepl("#File ", calls, fixed = TRUE)]
    real.time <- tabulate(match(proflog, calls)) * interval
    total.time <- sum(real.time)
    pct.time <- real.time / total.time
    calls <- remove_extra_info(calls, first)
    if ("source" %in% remove.frame)
        calls <- remove_source_frame(calls)
    if ("knitr" %in% remove.frame)
        calls <- remove_knitr_frame(calls)
    calls <- lapply(strsplit(calls, split = " ", fixed = TRUE), rev)
    calls <- vapply(calls, function(x) paste(c("calls", x), collapse = "/"), character(1L))
    res <- list(pathString = calls, real = real.time, percent = pct.time)
    class(res) <- "data.frame"
    attr(res, "row.names") <- .set_row_names(length(calls))
    res
}

remove_source_frame <- function(calls) {
    ind <- grep(" eval eval withVisible source$", calls)
    if (length(ind) == length(calls))
        calls <- sub(" eval eval withVisible source$", "", calls)
    calls
}

remove_knitr_frame <- function(calls) {
    ind <- grep(" process_file <Anonymous>", calls)
    if (length(ind) != length(calls))
        return(calls)
    calls <- sub(" eval eval withVisible withCallingHandlers( doTryCatch tryCatchOne tryCatchList tryCatch try)? handle evaluate_call <Anonymous> in_dir block_exec call_block process_group.block process_group withCallingHandlers process_file <Anonymous>( <Anonymous>)?$", "", calls)
    calls <- sub("", "", calls)
    calls
}

remove_extra_info <- function(calls, meta) {
    if (!grepl("profiling", meta, fixed = TRUE))
        return(calls)
    if (grepl("line profiling", meta, fixed = TRUE))
        calls <- gsub("\\d+#\\d+", "", calls)
    if (grepl("memory profiling", meta, fixed = TRUE))
        calls <- gsub("^:.*:", "", calls)
    if (grepl("GC profiling", meta, fixed = TRUE))
        calls <- gsub("<GC>", "", calls, fixed = TRUE)
    calls <- calls[nzchar(calls)]
    gsub("(?<=[\\s])\\s*|^\\s+|\\s+$", "", calls, perl = TRUE)
}
