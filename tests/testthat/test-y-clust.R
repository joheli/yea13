test_that("y.clust reports simple clusters", {
  yd <- matrix(c(
    0, 1, 5,
    1, 0, 5,
    5, 5, 0
  ), 3, byrow = TRUE, dimnames = list(c("a", "b", "c"), c("a", "b", "c")))

  clusters <- y.clust(yd, hs = 2, result = "clusters")
  expect_equal(nrow(clusters), 1L)
  expect_equal(clusters$size, 2L)
  expect_setequal(clusters$ids[[1]], c("a", "b"))
})

test_that("y.clust handles no clusters without 1:0 indexing", {
  yd <- diag(3)
  dimnames(yd) <- list(letters[1:3], letters[1:3])
  yd[upper.tri(yd) | lower.tri(yd)] <- 10

  clusters <- y.clust(yd, hs = 0.5, result = "clusters")
  sizes <- y.clust(yd, hs = 0.5, result = "sizes")

  expect_equal(nrow(clusters), 0L)
  expect_equal(nrow(sizes), 0L)
})
