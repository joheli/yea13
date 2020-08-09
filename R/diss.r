#' Transform distance or dissimilarity object to Ypma dissimilarity
#'
#' This function transforms objects of type \code{dist} (output from \code{stats::dist})
#' or \code{dissimilarity} (output from \code{cluster::daisy} into an Ypma dissimilarity matrix.
#'
#' @param d An object of type type \code{dist} or type \code{dissimilarity}.
#' @param allsteps A logical specifying if intermediate steps (minimum spanning tree, graph) are to be returned. Defaults to \code{FALSE}.
#' @return A square matrix containing Ypma dissimilarities.
#' @export diss

diss <- function(d, allsteps = FALSE) {
  # check input; accept only "dissimilarity" (from cluster::daisy) and "dist" (from stats::dist)
  if (any(class(d) == "dist")) {
    if (any(class(d) == "dissimilarity")) d <- as.dist(as.matrix(d))
  } else {
    stop("Please supply an argument of type 'dist' or 'dissimilarity', generated with functions stats::dist or cluster::daisy, respectively!")
  }

  # convert d to minimum spanning tree
  m <- mstC(d)
  # convert mst to undirected graph
  g <- igraph::graph_from_adjacency_matrix(m, mode = "undirected")
  # number of nodes (i.e. ypma dissimilarity) between nodes
  y <- igraph::distances(g)

  # determine level of output
  if (allsteps) {
    result <- list(`minimum spanning tree` = m,
                   `graph` = g,
                   `Ypma dissimilarity` = y)
  } else {
    result <- y
  }

  # return output
  return(result)
}
