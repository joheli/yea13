test_that("mx.expand returns the requested dimensions and names", {
  mx <- matrix(c(0, 1, 1, 0), 2, dimnames = list(c("a", "b"), c("a", "b")))
  conversion <- data.frame(id = c("x1", "x2", "x3"), unit = c("a", "b", "a"))

  out <- mx.expand(conversion, mx, noise0 = FALSE)

  expect_equal(dim(out), c(3L, 3L))
  expect_identical(rownames(out), conversion$id)
  expect_identical(colnames(out), conversion$id)
  expect_equal(out[1, 3], 0)
})

test_that("mx.expand only creates an unknown node when needed", {
  mx <- matrix(c(0, 2, 2, 0), 2, dimnames = list(c("a", "b"), c("a", "b")))
  known <- data.frame(id = c("x1", "x2"), unit = c("a", "b"))
  unknown <- data.frame(id = c("x1", "x2"), unit = c("a", "missing"))

  expect_equal(mx.expand(known, mx, noise0 = FALSE),
               mx, ignore_attr = TRUE)
  out <- mx.expand(unknown, mx, noise0 = FALSE)
  expect_equal(diag(out), c(0, 0))
  expect_gt(out[1, 2], max(mx))
})

test_that("mx.expand validates its matrix", {
  expect_error(mx.expand(data.frame(id = "x", unit = "a"), matrix(1:6, 2)),
               "square numeric matrix")
})
