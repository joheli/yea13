#' Identify putative clusters
#'
#' @param yd A square Ypma dissimilarity matrix or a list of such matrices.
#' @param hs Numeric heights at which hierarchical trees should be cut.
#' @param result Return cluster-size thresholds (`"sizes"`) or cluster details
#'   (`"clusters"`).
#' @return A data.frame describing clusters or permutation thresholds.
#' @export
y.clust <- function(yd, hs = c(2, 4, 6), result = c("sizes", "clusters")) {
  result <- match.arg(result)
  if (!length(hs) || any(!is.finite(hs))) {
    stop("'hs' must contain one or more finite cut heights.", call. = FALSE)
  }

  cl <- function(d0, h) {
    if (!is.matrix(d0) || nrow(d0) != ncol(d0)) {
      stop("Each element of 'yd' must be a square matrix.", call. = FALSE)
    }
    if (nrow(d0) < 2L) return(data.frame())
    y.h <- stats::hclust(stats::as.dist(d0))
    memberships <- stats::cutree(y.h, h = h)
    groups <- split(names(memberships), memberships)
    groups <- groups[lengths(groups) > 1L]
    if (!length(groups)) return(data.frame())

    data.frame(
      cluster.no = seq_along(groups),
      size = lengths(groups),
      ids = I(unname(groups)),
      max.diss = vapply(groups, function(ids) max(d0[ids, ids, drop = FALSE]), numeric(1)),
      stringsAsFactors = FALSE
    )
  }

  ycf <- function(y) {
    pieces <- lapply(hs, function(h) cl(y, h))
    pieces <- pieces[vapply(pieces, nrow, integer(1)) > 0L]
    if (!length(pieces)) return(data.frame())
    do.call(rbind, pieces)
  }

  matrices <- if (is.list(yd)) yd else list(yd)
  pieces <- lapply(matrices, ycf)
  pieces <- pieces[vapply(pieces, nrow, integer(1)) > 0L]
  if (!length(pieces)) {
    if (result == "sizes") {
      return(data.frame(size = integer(), `minimal max.diss` = numeric(), check.names = FALSE))
    }
    return(data.frame(cluster.no = integer(), size = integer(), ids = I(list()), max.diss = numeric()))
  }

  yc <- do.call(rbind, pieces)
  rownames(yc) <- NULL
  yc$cluster.no <- seq_len(nrow(yc))

  if (result == "sizes") {
    mins <- tapply(yc$max.diss, yc$size, min)
    data.frame(size = as.integer(names(mins)), `minimal max.diss` = as.numeric(mins), check.names = FALSE)
  } else {
    yc
  }
}
