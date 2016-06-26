context("Print tree")

tree <- prof.tree("Rprof.out")

test_that("Print prof.tree returns a data.frame", {
    expect_is(print(tree), "data.frame")
})

test_that("Print contains", {
    expect_output(print(tree), "levelName")
    expect_output(print(tree), "real")
    expect_output(print(tree), "percent")
    expect_output(print(tree), "env")
    expect_output(print(tree), " \u00B0")
    expect_output(print(tree), "100.0 %")
})

test_that("Print contains", {
    tree <- prof.tree("Rprof-line.out")
    expect_output(print(tree), "file")
    expect_output(print(tree), "line")
})
