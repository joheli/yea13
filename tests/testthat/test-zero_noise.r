context("zero.noise")

test_that("accepts only square matrix", {
  expect_error(zero.noise(x = "a")) # character not accepted
  expect_error(zero.noise(x = matrix(1:20, nrow = 4))) # only equal number of rows and columns permitted
})

test_that("diag of output are zeroes by default", {
  expect_true(all(diag(zero.noise(x = matrix(1:9, nrow = 3))) == 0))
})

test_that("no zeroes remain in output despite having provided zeroes as input", {
  expect_true(all(!zero.noise(x = matrix(rep(0, 9), nrow = 3), exclude.diag = FALSE) == 0))
})
