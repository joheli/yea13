context("mst")

# Test objects
set.seed(123)
test.d1 <- dist(matrix(rnorm(400), nrow = 40))
test.mx <- matrix(round(runif(12^2, 1, 3)), ncol = 12)
test.ix <- sample(1:12, size = 12, replace = TRUE)
test.mx <- test.mx[test.ix, test.ix] # generate zero distances by recycling a few cases
test.d2 <- dist(test.mx, method = "manhattan")

## ape::mst vs mst
test.m1a <- ape::mst(test.d1)
test.m1y <- mst(test.d1)
test.m2a <- ape::mst(test.d2)
test.m2y <- mst(test.d2)

# Tests
test_that("mst only accepts 'dist' objects", {
  expect_error(mst(test.mx))
})

test_that("output by ape::mst equals mst", {
  expect_equal(test.m1a, test.m1y)
  expect_equal(test.m2a, test.m2y)
})

# clean up after yourself
rm(list = ls(pattern = "^test\\."))