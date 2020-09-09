context("diss / calculate number of hops in minimum spanning tree")

# Test objects
set.seed(123)
test.n <- 6
test.mx <- matrix(round(runif(test.n^2, 1, 3)), ncol = test.n)
test.ix <- sample(1:test.n, size = test.n, replace = TRUE)
test.mx <- test.mx[test.ix, test.ix] # generate zero distances by recycling a few cases
test.d <- dist(test.mx, method = "manhattan")
test.diss <- diss(test.d)

# Tests
test_that("output is a square matrix", {
  expect_equal(nrow(test.diss), ncol(test.diss)) 
})

test_that("diss / hops correspond to expected", {
  expect_equal(test.diss[3, 4], 4) # i.e. 4 hops between 3 and 4
  expect_equal(test.diss[2, 5], 1) # i.e. 1 hop between 2 and 5 (these two entries are in fact equal, see test.mx); mst still separates them.
})

# clean up after yourself
rm(list = ls(pattern = "^test\\."))