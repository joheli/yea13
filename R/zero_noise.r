#' Add random noise to zero values in square matrix
#'
#' This is a helper function used by \code{\link{mx.expand}}.
#'
#' @param x A numerical square matrix.
#' @param lo A numeric specifying the lower boundary of to be inserted random values (random values are generated with \code{\link{runif}}).
#' @param hi A numeric specifying the upper boundary of to be inserted random values.
#' @param exclude.diag A logical stating whether the diagonal values should be left alone; defaults to TRUE.
#' @return A numerical square matrix with random noise added to zero values.
#' @export

zero.noise <- function(x, lo = 0, hi = 0.01, exclude.diag = T) {
  if (class(x) != "matrix") stop("Please supply an argument of class 'matrix'.")
  l <- length(x[x == 0])
  x[x == 0] <- runif(l, lo, hi)
  if (exclude.diag) diag(x) <- 0
  return(x)
}
