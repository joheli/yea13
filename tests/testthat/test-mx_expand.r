context("mx.expand")

# test objects

## specify seed
set.seed(123)

## matrix column and row names
test.ix <- letters[1:4]

## test matrix
test.mx <- matrix(runif(16), nrow = 4)
colnames(test.mx) <- test.ix
rownames(test.mx) <- colnames(test.mx)
diag(test.mx) <- 0

## test conversion table
test.ct <- data.frame(id = paste0("x", 1:8), ix = sample(x = test.ix, size = 8, replace = TRUE))

## test outputs
test.output01 <- mx.expand(conversion.table = test.ct, mx = test.mx, noise0 = TRUE)
test.output02 <- mx.expand(conversion.table = test.ct, mx = test.mx, noise0 = FALSE)

# run tests using above objects
test_that("size and diag of output", {
  expect_equal(nrow(test.output01), nrow(test.ct))
  expect_equal(ncol(test.output01), nrow(test.ct))
})

test_that("distance between identical entries in conversion.table are zero", {
  expect_true(all(as.matrix(dist(test.output[test.ct[, 2] == test.ix[1], ])) == 0))
})

# clean up after yourself
rm(list = ls(pattern = "^test\\."))

