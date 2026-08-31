test_that("ypma.diss returns a named symmetric matrix", {
  d <- data.frame(
    case = c("c1", "c2", "c3"),
    day = c(1, 2, 5),
    ward = c("A", "A", "B"),
    marker = c(0, 1, 4)
  )
  e <- matrix(c(0, 1, 1, 0), 2,
              dimnames = list(c("A", "B"), c("A", "B")))

  set.seed(1)
  out <- ypma.diss(d, e, tc = "day", uc = "ward", ic = "case",
                   dfun = "dist", dfun.args = list(method = "manhattan"))

  expect_equal(dim(out), c(3L, 3L))
  expect_identical(rownames(out), d$case)
  expect_equal(out, t(out))
  expect_equal(diag(out), rep(0, 3))
})

test_that("ypma.diss validates column selectors and ids", {
  d <- data.frame(case = c("x", "x"), day = 1:2, ward = c("A", "B"), marker = 1:2)
  e <- matrix(c(0, 1, 1, 0), 2,
              dimnames = list(c("A", "B"), c("A", "B")))

  expect_error(ypma.diss(d, e, tc = "missing", uc = "ward", ic = "case"), "tc")
  expect_error(ypma.diss(d, e, tc = "day", uc = "ward", ic = "case"), "unique")
})
