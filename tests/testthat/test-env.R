context("Find a function environment name")

test_that("Get environment name", {
    assign("f", function(x) x, envir = globalenv())
    expect_equal(fun_env("f"), "R_GlobalEnv")
    expect_equal(fun_env("prof.tree"), "prof.tree")
    expect_equal(fun_env("mean"), "base")
    expect_equal(fun_env(".try_quietly"), "tools")
})
