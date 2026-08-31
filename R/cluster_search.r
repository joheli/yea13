#' Search for putative clusters
#'
#' Searches surveillance observations for clusters with unusually small
#' combined spatial, type/genetic, and temporal Ypma dissimilarity.
#'
#' @param d A data.frame containing id, time, unit and type columns.
#' @param e A square effective-distance matrix for units in `d`.
#' @param tc,uc,ic Character names or numeric positions of time, unit and id.
#' @param p.n Number of permutations.
#' @param hs Heights at which hierarchical trees are cut.
#' @param ... Arguments passed to [ypma.diss()].
#' @return A list of data.frames, one for each significant putative cluster.
#' @export
cluster.search <- function(d, e, tc, ic, uc, p.n, hs, ...) {
  message("Cluster search initiated - processing data ...")

  d.obs <- ypma.diss(d = d, e = e, tc = tc, ic = ic, uc = uc,
                     p = FALSE, ...)
  d.prm <- ypma.diss(d = d, e = e, tc = tc, ic = ic, uc = uc,
                     p = TRUE, p.n = p.n, ...)

  cl.obs <- y.clust(yd = d.obs, hs = hs, result = "clusters")
  if (!nrow(cl.obs)) return(list())
  cl.prm <- y.clust(yd = d.prm, hs = hs, result = "sizes")
  if (!nrow(cl.prm)) return(list())

  cl.sig <- merge(cl.obs, cl.prm, by = "size", all.x = TRUE, sort = FALSE)
  cl.sig <- cl.sig[!is.na(cl.sig$`minimal max.diss`) &
                     cl.sig$max.diss < cl.sig$`minimal max.diss`, , drop = FALSE]
  if (!nrow(cl.sig)) return(list())

  id_col <- if (is.character(ic)) ic else names(d)[as.integer(ic)]
  lapply(cl.sig$ids, function(ids) {
    d[d[[id_col]] %in% ids, , drop = FALSE]
  })
}
