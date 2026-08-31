#' Add random noise to zero values in a square matrix
#'
#' @param x A numeric square matrix.
#' @param lo,hi Numeric lower and upper bounds for uniform random values.
#' @param exclude.diag Logical; keep diagonal values at zero?
#' @return A numeric square matrix with noise replacing zero values.
#' @export
zero.noise <- function(x, lo = 0, hi = 0.01, exclude.diag = TRUE) {
  if (!is.matrix(x) || !is.numeric(x)) {
    stop("Please supply a numeric matrix.", call. = FALSE)
  }
  if (nrow(x) != ncol(x)) {
    stop("'x' has to be a square matrix.", call. = FALSE)
  }
  if (length(lo) != 1L || length(hi) != 1L || !is.finite(lo) || !is.finite(hi) || lo > hi) {
    stop("'lo' and 'hi' must be finite scalars with lo <= hi.", call. = FALSE)
  }
  zero <- x == 0
  if (exclude.diag) diag(zero) <- FALSE
  n <- sum(zero, na.rm = TRUE)
  if (n) x[zero & !is.na(zero)] <- stats::runif(n, lo, hi)
  if (exclude.diag) diag(x) <- 0
  x
}
