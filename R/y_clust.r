#' Identify putative clusters 
#' 
#' This function accepts a Ypma dissimilarity matrix (or a list thereof) and returns information on putative clusters.
#' 
#' @param yd A square matrix (Ypma dissimilarity matrix) or a list thereof.
#' @param hs An integer containing the heights at wich trees from hierarchical clustering should be cut.
#' @param return An character specifying if sizes of putative clusters with according smallest maximal dissimilarities ('sizes') or clusters with information on ids etc. ('clusters') are to be returned.
#' @return A square matrix containing Ypma dissimilarities.
#' @export y.clust

y.clust <- function(yd, hs = c(2, 4, 6), result = c("sizes", "clusters")) {
  # extract result
  r <- match.arg(result)
  
  # function 'cl' takes a square matrix and converts it into a tree (using `hclust`), which is then cut at 
  # height 'h' - finally clusters are returned in a data.frame
  
  # TODO repair function, creates error: `summarise()` ungrouping output (override with `.groups` argument) ####
  cl <- function(d0, h) {  
    y.d <- as.dist(d0)
    y.h <- hclust(y.d)
    y.ct <- cutree(y.h, h)
    y.ct2 <- data.frame(id = names(y.ct), cluster.no = y.ct)
    y.ct2 %>% 
      group_by(cluster.no) %>% 
      summarize(size = n(), ids = list(as.character(id)), max.diss = max(d0[as.character(id), as.character(id)])) %>% 
      filter(size > 1)
  }
  
  # function 'ycf' calls 'cl' for each different cluster height specified in 'hs'
  ycf <- function(y) Reduce(rbind, lapply(hs, function(x) cl(y, h = x)))
  
  # if 'yd' is a list of matrices, combine result of 'ycf'
  if (class(yd) == "list") {
    yc <- Reduce(rbind, lapply(yd, ycf))
  } else {
    yc <- ycf(yd)
  }
  
  # assign new cluster no.
  yc$`cluster.no` <- 1:nrow(yc) 
  
  # decide whether sizes (for permuted matrices) or clusters (for actual, non-permuted matrices) are to be returned
  if (r == "sizes") {
    yc %>% dplyr::group_by(size) %>% dplyr::summarize(`minimal max.diss` = min(max.diss))
  } else {
    yc
  }
}