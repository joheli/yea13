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
#' @param p.value Numeric, p value passed to [y.clust()], see there.
#' @param ... Arguments passed to [ypma.diss()].
#' @return A list of data.frames, one for each significant putative cluster.
#' @export
cluster.search <- function(d, e, tc, ic, uc, p.n, hs, p.value=0.05,...) {
  message("Cluster search initiated - processing data ...")

  # store the observed, actual ypma dissimilarities (see function ypma.diss)
  # in `d.obs` (it is a matrix containing ypma dissimilarities)
  d.obs <- ypma.diss(d = d, e = e, tc = tc, ic = ic, uc = uc,
                     p = FALSE, ...)
  # store a list of permuted ypma dissimilarities in `d.prm`
  d.prm <- ypma.diss(d = d, e = e, tc = tc, ic = ic, uc = uc,
                     p = TRUE, p.n = p.n, ...)

  # `cl.obs` contains a list of all observed clusters with columns
  # cluster.no, size, ids of the data points, and the max dissimilarity measured
  cl.obs <- y.clust(yd = d.obs, hs = hs, result = "clusters")
  # if no observed clusters found, return an empty list
  if (!nrow(cl.obs)) return(list())
  # result="sizes" means that a data frame is returned containing the 
  # minimal max.diss grouped by cluster size  
  # the question here is: given a cluster size of x what is the minimal expansion (max.diss)
  # that has been achieved through random permuation alone!
  # the returned data frame only contains two columns: `size` and `minimal max.diss`
  cl.prm <- y.clust(yd = d.prm, hs = hs, result = "sizes", p.value = p.value)
  # if cl.prm is empty return an empty list
  if (!nrow(cl.prm)) return(list())

  # to get a subset of "significant" clusters merge the observed cluster 
  # with the randomly generated clusters (random dissimilarities)
  cl.sig <- merge(cl.obs, cl.prm, by = "size", all.x = TRUE, sort = FALSE)
  # let's go step by step 
  # create a selector for those clusters where max.diss is below `minimal max.diss`
  cl_sig0 <- cl.sig$max.diss < cl.sig$`minimal max.diss`
  # add to cl.sig as a field (to filter later)
  cl.sig$sig0 <- cl_sig0
  # create selector for those clusters where max.diss is below `sig. max.diss`
  cl_sig1 <- cl.sig$max.diss < cl.sig$`sig. max.diss`
  # add to cl.sig as field (to be filtered by later)
  cl.sig$sig1 <- cl_sig1
  # remove lines where `minimal max.diss` is na:
  cl.sig <- cl.sig[!is.na(cl.sig$`minimal max.diss`), , drop = FALSE]

  # if no rows left return empty list
  if (!nrow(cl.sig)) return(list())

  # return the original data frame only with those ids that occur in a cluster:
  # id_col <- if (is.character(ic)) ic else names(d)[as.integer(ic)]
  # lapply(cl.sig$ids, function(ids) {
  #  d[d[[id_col]] %in% ids, , drop = FALSE]
  #})

  # return cl.sig
  cl.sig
}
