parse_log <- function(filename) {
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
    calls <- remove_source_frame(calls)
    calls <- lapply(strsplit(calls, split = " ", fixed = TRUE), rev)
    calls <- vapply(calls, function(x) paste(c("calls", x), collapse = "/"), character(1L))
    data.frame(pathString = calls, real = real.time, percent = pct.time, stringsAsFactors = FALSE)
}

remove_source_frame <- function(calls) {
    pattern <- " eval eval withVisible source$"
    idx <- grepl(pattern, calls)
    if (sum(idx) == length(calls))
        calls <- sub(pattern, "", calls)
    calls
}

remove_knitr_frame <- function(calls) {
    pattern <- " process_file <Anonymous>$"
    idx <- grepl(pattern, calls)
    if (sum(idx) == length(calls)) {
        calls <- sub(" evaluate_call <Anonymous> in_dir block_exec call_block process_group.block process_group withCallingHandlers process_file <Anonymous>$", "", calls)
        calls <- sub(" eval eval withVisible withCallingHandlers doTryCatch tryCatchOne tryCatchList tryCatch try handle$", "", calls)
    }
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
