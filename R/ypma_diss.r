#' Calculate Ypma dissimilarities for type, time, and unit
#' 
#' This function takes a \code{data.frame} of one species (or other sensible taxonomic unit) containing
#' information on time, unit, and type to calculate Ypma dissimilarities between entries.
#' 
#' @param d A \code{data.frame} containing columns for id, time, unit (e.g. ward) and type (represented by remaining columns).
#' @param e A quadratic matrix with identical row and column names representing effective distances of units contained in \code{d}.
#' @param tc A character or numeric identifying name or number, respectively, of time column in \code{d}.
#' @param uc A character or numeric identifying name or number, respectively, of unit column in \code{d}.
#' @param tc A character or numeric identifying name or number, respectively, of id column in \code{d}.
#' @param dfun A character specifying name of function for distance (dissimilarity) calculation of type columns.
#' @param dfun.args A list specifying arguments passed to \code{dfun}.
#' @param p A logical specifying if permutation is to be performed. Defaults to \code{FALSE}.
#' @param p.n An integer specifying number of permutations performed if \code{p} is \code{TRUE}.
#' @return If \code{p} is \code{FALSE} (default) a square matrix containing Ypma dissimilarities between rows in \code{d} (represented by id), and a list with Ypma dissimilarity matrices of random permutations of \code{d} otherwise.
#' @export ypma.diss

ypma.diss <- function(d, # species data.frame with only one species and only one id column
                   e = NULL, # matrix with effective distances of wards (units)
                   tc, # column representing time
                   uc, # column representing unit/ward
                   ic, # column representing id
                   dfun = c("dist", "daisy"), # dissimilarity function
                   dfun.args = list(method = "manhattan"), # arguments passed to dissimilarity function regarding type
                   p = F, # permute or not
                   p.n = 3) {
  dfun <- match.arg(dfun)
  
  # convert tc, uc, ic to numeric, if necessary
  if (class(tc) == "character") tc <- which(colnames(d) == tc)
  if (class(uc) == "character") uc <- which(colnames(d) == uc)
  if (class(ic) == "character") ic <- which(colnames(d) == ic)
  
  tmp <- d[, tc]
  unit <- d[, uc]
  id <- d[, ic]
  
  # Type
  type0 <- d[, -c(tc, uc, ic)]
  
  # Append row ids
  rownames(type0) <- id
  
  # run dissimilarity function specified in 'dfun'
  type.d <- do.call(dfun, c(list(get("type0")), dfun.args))
  # extract ypma dissimilarity (number of nodes distance) from graph using function 'diss'
  type.diss <- diss(type.d)
  
  # define function prmx with default behaviour (= does nothing)
  prmx <- function(x) x
  # define default number of permutations
  prmx.n <- 1
  
  # if permutation is selected, prmx is set to the function 'sample', while prmx.n is set to p.n (see above)
  if (p) {
    prmx <- sample
    prmx.n <- p.n
  }
  
  # function to calculate ypma dissimilarity
  y <- function(.n = NULL) {
    # Time
    # create data.frame containing temporal data (time)
    tmp0 <- data.frame(as.numeric(prmx(tmp)))
    # Append row ids
    rownames(tmp0) <- id
    # run dist
    tmp1 <- dist(tmp0)
    # run dissimilarity function 'diss'
    time.diss <- diss(tmp1)
    
    # Units
    # create data.frame containing unit data
    unit0 <- data.frame(id, prmx(unit))
    # rebind effective distances contained in 'e' to ids in 'unit0'
    unit1 <- mx.expand(unit0, e)
    # run 'dist'
    unit2 <- dist(unit1)
    # run dissimilarity function 'diss'
    unit.diss <- diss(unit2)
    
    # calculate Ypma Product for current permutation
    type.diss * time.diss * unit.diss
  }
  
  # Prepare return
  if (p) {
    lapply(1:prmx.n, y)
  } else {
    y()
  }
}