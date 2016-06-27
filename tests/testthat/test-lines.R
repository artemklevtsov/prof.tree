context("Scripts")

tree <- prof.tree("logs/Rprof-source.out")

test_that("Tree fields", {
    expect_equal(tree$fieldsAll, c("file", "line", "percent", "real", "env"))
})

test_that("'file' field", {
    expect_null(tree$file)
    expect_is(tree$Get("file"), "character")
})

test_that("'file' field contains file names", {
    expect_true(any(grepl("script1.R", tree$Get("file"))))
    expect_true(any(grepl("script2.R", tree$Get("file"))))
})

test_that("'line' field", {
    expect_null(tree$line)
    expect_is(tree$Get("line"), "integer")
})

