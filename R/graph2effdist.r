#' Calculate effective distances between nodes of a graph
#'
#' @param g An `igraph` object.
#' @param edge.attribute Optional edge attribute used as adjacency weights.
#' @return A square matrix with effective distances between nodes.
#' @examples
#' graph2effdist(units_igraph, edge.attribute = "weight")
#' @export
graph2effdist <- function(g, edge.attribute = NULL) {
  if (!inherits(g, "igraph")) stop("'g' must be an igraph object.", call. = FALSE)
  A <- igraph::as_adjacency_matrix(g, attr = edge.attribute, sparse = FALSE)
  storage.mode(A) <- "double"
  totals <- rowSums(A)
  if (any(!is.finite(totals)) || any(totals <= 0)) {
    stop("Every graph node must have a positive finite outgoing weight.", call. = FALSE)
  }
  p <- A / totals
  NetOrigin::eff_dist(p)
}
