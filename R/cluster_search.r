#' Search for putative clusters
#'
#' This function takes a \code{data.frame} of one species (or other sensible taxonomic unit) containing
#' information on time, unit, and type and searches for putative clusters.
#'
#' @param d A \code{data.frame} containing columns for id, time, unit (e.g. ward) and type (represented by remaining columns).
#' @param e A quadratic matrix with identical row and column names representing effective distances of units contained in \code{d}.
#' @param tc A character or numeric identifying name or number, respectively, of time column in \code{d}.
#' @param uc A character or numeric identifying name or number, respectively, of unit column in \code{d}.
#' @param ic A character or numeric identifying name or number, respectively, of id column in \code{d}.
#' @param p.n An integer specifying number of permutations performed.
#' @param hs An integer containing the heights at which trees from hierarchical clustering should be cut.
#' @param ... Arguments passed to \code{\link{ypma.diss}}
#' @return A \code{data.frame} containing information on putative clusters.
#' @examples
#' # starts a cluster search with 100 ('p.n' = 100) permutations (careful: takes a long time!)
#' test <- cluster.search(s_aureus, e = units_effdist, tc = "time", uc = "unit", ic = "id", p.n = 100, hs = c(2,3,6), dfun = "dist", dfun.args = list(method = "manhattan"))
#' @export cluster.search

cluster.search <- function(d, # data.frame
                           e, # eff dist
                           tc,
                           ic,
                           uc,
                           p.n,
                           hs,
                           ...) {
  # observed ypma diss
  d.obs <- ypma.diss(d = d, e = e, tc = tc, ic = ic, uc = uc, p = FALSE, ...)

  # permuted ypma diss
  d.prm <- ypma.diss(d = d, e = e, tc = tc, ic = ic, uc = uc, p = TRUE, p.n = p.n, ...)

  # observed clusters
  cl.obs <- y.clust(yd = d.obs, hs = hs, result = "clusters")

  # permuted clusters
  cl.prm <- y.clust(yd = d.prm, hs = hs, result = "sizes")

  # filtering of non-significant clusters
  cl.sig <- cl.obs %>%
    left_join(cl.prm, by = "size") %>%
    mutate(significant = max.diss < `minimal max.diss`) %>%
    filter(significant) %>% select(-significant)

  lapply(cl.sig$ids, function(x) filter(d, id %in% x))
}
