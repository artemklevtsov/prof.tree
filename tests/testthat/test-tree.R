context("Tree structure")

tree <- prof.tree("Rprof.out")

test_that("prof.tree class", {
    expect_is(tree, "ProfTree")
    expect_is(tree, "Node")
    expect_is(tree, "R6")
})

test_that("Root name is calls", {
    expect_equal(tree$name, "calls")
})

test_that("Root call environment is null", {
    expect_null(tree$env)

})

test_that("Root percent time is 1", {
    expect_equal(tree$percent, 1)
})
