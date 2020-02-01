#' Expand a square dissimilarity matrix
#' 
#' This function accepts a conversion table and a square matrix as input to return a new square matrix with changed row and column names referring to id labels in conversion table.
#' 
#' @param conversion.table A data.frame containting two columns; the first with id labels, the second with the names of rows (= names of columns) in square matrix \code{mx} (see below), to which it refers.
#' @param mx A square numerical matrix with equal row and column names that the second column of \code{conversion.table} refers to.
#' @param noise0 A logical determining whether to add noise to zero values using function \code{zero.noise}. Defaults to TRUE.
#' @param noise.lo A numerical passed to \code{zero.noise}, specifying the lower boundary of the random value to be inserted. Only used if \code{noise0} is TRUE.
#' @param noise.hi A numerical passed to \code{zero.noise}, specifying the upper boundary of the random value to be inserted. Only used if \code{noise0} is TRUE.
#' @param ... Further arguments passed to \code{zero.noise}.
#' @return A matrix with id in \code{conversion.table} used as row/column names.
#' @export mx.expand

mx.expand <- function(conversion.table,
                      mx,
                      noise0 = T,
                      noise.lo = 0,
                      noise.hi = 0.01,
                      ...) {
  id <- as.character(conversion.table[,1]) # as.character used to convert factors to character
  ix <- as.character(conversion.table[,2]) # as.character used to convert factors to character
  if (length(!(ix %in% rownames(mx))) > 0) { # if ix occurs without reference in mx
    # add an entry for 'unknown' in a new matrix
    mx2 <- matrix(nrow = nrow(mx) + 1, ncol = ncol(mx) + 1)
    mx2[1:nrow(mx), 1:ncol(mx)] <- mx
    colnames(mx2) <- c(colnames(mx), "unknown")
    rownames(mx2) <- c(rownames(mx), "unknown")
    # set distance for unknown high level
    mx2[nrow(mx2), ] <- max(mx) * 10
    mx2[, ncol(mx2)] <- max(mx) * 10
    ix[!(ix %in% rownames(mx))] <- "unknown"
    mx <- mx2
  }
  me <- mx[ix, ix]
  rownames(me) <- id
  colnames(me) <- id
  if (noise0) me <- zero.noise(me, noise.lo, noise.hi, ...)
  return(me)
}