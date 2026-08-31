#' Transform a distance object to Ypma dissimilarity
#'
#' Converts a `dist` object (including `cluster::daisy()` dissimilarities) into
#' minimum-spanning-tree hop distances.
#'
#' @param d An object inheriting from `dist`.
#' @param allsteps Logical; return the minimum spanning tree and graph as well?
#' @return A square matrix of Ypma hop dissimilarities, or a list of intermediate
#'   objects when `allsteps = TRUE`.
#' @export
diss <- function(d, allsteps = FALSE) {
  if (!inherits(d, "dist")) {
    stop("Please supply an object inheriting from 'dist', such as stats::dist() or cluster::daisy().",
         call. = FALSE)
  }
  if (inherits(d, "dissimilarity")) d <- stats::as.dist(as.matrix(d))
  if (any(!is.finite(d))) stop("Distances must all be finite.", call. = FALSE)

  m <- mst(d)
  g <- igraph::graph_from_adjacency_matrix(m, mode = "undirected", diag = FALSE)
  y <- igraph::distances(g, weights = NA)

  if (allsteps) {
    list(`minimum spanning tree` = m,
         graph = g,
         `Ypma dissimilarity` = y)
  } else {
    y
  }
}
