#' Expand a square dissimilarity matrix
#'
#' This function accepts a conversion table and a square matrix as input to
#' return a new square matrix with row and column names referring to the ids in
#' the conversion table.
#'
#' @param conversion.table A data.frame containing two columns; the first with
#'   id labels and the second with row/column names in `mx`.
#' @param mx A square numeric matrix with identical row and column names.
#' @param noise0 Logical; add noise to off-diagonal zero values using
#'   [zero.noise()]? Defaults to `TRUE`.
#' @param noise.lo,noise.hi Numeric bounds passed to [zero.noise()].
#' @param ... Further arguments passed to [zero.noise()].
#' @return A matrix with ids from `conversion.table` as row/column names.
#' @export
mx.expand <- function(conversion.table, mx, noise0 = TRUE,
                      noise.lo = 0, noise.hi = 0.01, ...) {
  if (!is.data.frame(conversion.table) || ncol(conversion.table) < 2L) {
    stop("'conversion.table' must be a data.frame with at least two columns.", call. = FALSE)
  }
  if (!is.matrix(mx) || !is.numeric(mx) || nrow(mx) != ncol(mx)) {
    stop("'mx' must be a square numeric matrix.", call. = FALSE)
  }
  if (is.null(rownames(mx)) || is.null(colnames(mx)) ||
      !identical(rownames(mx), colnames(mx))) {
    stop("'mx' must have identical row and column names.", call. = FALSE)
  }

  id <- as.character(conversion.table[[1L]])
  ix <- as.character(conversion.table[[2L]])

  # Previously this condition used length(!(...)) > 0, which is true for every
  # non-empty conversion table and therefore always added an 'unknown' node.
  if (any(!ix %in% rownames(mx))) {
    finite_values <- mx[is.finite(mx)]
    if (!length(finite_values)) {
      stop("'mx' must contain at least one finite value.", call. = FALSE)
    }
    unknown_distance <- max(finite_values) * 10
    if (unknown_distance == 0) unknown_distance <- 1

    mx2 <- matrix(unknown_distance, nrow = nrow(mx) + 1L, ncol = ncol(mx) + 1L,
                  dimnames = list(c(rownames(mx), "unknown"),
                                  c(colnames(mx), "unknown")))
    mx2[seq_len(nrow(mx)), seq_len(ncol(mx))] <- mx
    mx2[nrow(mx2), ncol(mx2)] <- 0
    ix[!ix %in% rownames(mx)] <- "unknown"
    mx <- mx2
  }

  out <- mx[ix, ix, drop = FALSE]
  dimnames(out) <- list(id, id)
  if (noise0) out <- zero.noise(out, noise.lo, noise.hi, ...)
  out
}
