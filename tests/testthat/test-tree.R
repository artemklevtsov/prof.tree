context("Tree structure")

tree <- prof.tree("logs/Rprof.out")

test_that("empty input", {
    file.create(tmp <- tempfile())
    expect_error(prof.tree(tmp))
    expect_error(prof.tree(""))
    expect_error(prof.tree(tempfile()))
})

test_that("prof.tree class", {
    expect_is(tree, "ProfTree")
    expect_is(tree, "Node")
    expect_is(tree, "R6")
})

test_that("Root has more than 0 children", {
    expect_gt(tree$count, 0)
})

test_that("Root name is circle", {
    expect_equal(tree$name, " \u00B0")
})

test_that("Tree fields", {
    expect_equal(tree$fieldsAll, c("percent", "real", "env"))
})

test_that("'env' field", {
    expect_is(tree$Get("env"), "character")
    expect_null(tree$env)
})

test_that("'real' field", {
    expect_is(tree$Get("real"), "numeric")
    expect_gt(tree$real, 0)
})

test_that("'percent' field", {
    expect_is(tree$Get("percent"), "character")
    expect_equal(tree$Get("percent")[1], c(" °" = "100.0 %"))
    expect_equal(tree$percent, 1)
})
