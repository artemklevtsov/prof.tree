parse_log <- function(filename) {
    prof_log <- scan(filename, what = "character", quote = "\"", sep = "\n",
                     strip.white = TRUE, multi.line = FALSE, quiet = TRUE)
    if (length(prof_log) < 2L)
        stop(sprintf("'%s' file is empty.", filename))
    interval <- as.numeric(strsplit(prof_log[1L],split = "=", fixed = TRUE)[[1L]][2L]) / 1e06
    prof_log <- prof_log[-1L]
    calls <- unique(prof_log, fromLast = TRUE)
    calls <- calls[!grep("^#File", calls)]
    calls <- gsub("<GC>|\\d+#\\d+", "", calls)
    calls <- gsub("(?<=[\\s])\\s*|^\\s+|\\s+$", "", calls, perl = TRUE)
    real.time <- tabulate(match(prof_log, calls)) * interval
    total.time <- sum(real.time)
    pct.time <- real.time / total.time
    calls <- lapply(strsplit(calls, split = " ", fixed = TRUE), rev)
    calls <- vapply(calls, function(x) paste(c("calls", x), collapse = "/"), character(1L))
    data.frame(pathString = calls, real = real.time, percent = pct.time, stringsAsFactors = FALSE)
}
