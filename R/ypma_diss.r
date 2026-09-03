#' Calculate Ypma dissimilarities for type, time, and unit
#'
#' @param d A data.frame containing id, time, unit and type columns.
#' @param e A square matrix with identical row and column names representing
#'   effective distances between units.
#' @param tc,uc,ic Character names or numeric positions of the time, unit and id
#'   columns in `d`.
#' @param dfun Distance function for type columns: `"dist"` or `"daisy"`.
#' @param dfun.args A list of arguments passed to `dfun`.
#' @param p Logical; perform permutations?
#' @param p.n Number of permutations when `p = TRUE`.
#' @param n.cores Number of worker processes used for permutations. Defaults to
#'   one for portability; set a larger value explicitly for local runs.
#' @return A Ypma dissimilarity matrix, or a list of matrices for permutations.
#' @export
ypma.diss <- function(d, e = NULL, tc, uc, ic,
                      dfun = c("dist", "daisy"),
                      dfun.args = list(method = "manhattan"),
                      p = FALSE, p.n = 3L,
                      n.cores = 1L) {
  dfun <- match.arg(dfun)
  if (!is.data.frame(d) || nrow(d) < 2L) {
    stop("'d' must be a data.frame with at least two rows.", call. = FALSE)
  }
  if (is.null(e)) stop("'e' must be supplied.", call. = FALSE)

  resolve_col <- function(x, label) {
    if (is.character(x)) {
      if (length(x) != 1L || !x %in% names(d)) {
        stop(sprintf("'%s' must name exactly one column in 'd'.", label), call. = FALSE)
      }
      match(x, names(d))
    } else {
      x <- as.integer(x)
      if (length(x) != 1L || is.na(x) || x < 1L || x > ncol(d)) {
        stop(sprintf("'%s' is not a valid column position.", label), call. = FALSE)
      }
      x
    }
  }
  tc <- resolve_col(tc, "tc")
  uc <- resolve_col(uc, "uc")
  ic <- resolve_col(ic, "ic")
  if (length(unique(c(tc, uc, ic))) != 3L) {
    stop("'tc', 'uc', and 'ic' must refer to different columns.", call. = FALSE)
  }
  if (!is.numeric(p.n) || length(p.n) != 1L || is.na(p.n) || p.n < 1) {
    stop("'p.n' must be a positive integer.", call. = FALSE)
  }
  p.n <- as.integer(p.n)
  if (!is.numeric(n.cores) || length(n.cores) != 1L || is.na(n.cores) || n.cores < 1L) {
    stop("'n.cores' must be a positive integer.", call. = FALSE)
  }
  n.cores <- as.integer(n.cores)

  # tmp holds temporal information
  tmp <- d[[tc]]
  # unit holds information regarding the place (e.g. ward) - it is just a name
  unit <- d[[uc]]
  # id is the identifier, e.g. the lab request no.
  id <- as.character(d[[ic]])
  if (anyNA(id) || anyDuplicated(id)) {
    stop("The id column must contain unique, non-missing values.", call. = FALSE)
  }

  # type is more difficult
  # it could have been stored in a single column e.g. as a json object or similar
  # here, all remaining columns represent type - dirty, right?
  # type0 is a data.frame containing all columns except tc, uc, ic
  type0 <- d[, -c(tc, uc, ic), drop = FALSE]
  if (!ncol(type0)) stop("'d' must contain at least one type column.", call. = FALSE)
  rownames(type0) <- id

  # to calculate ypma dissimilarities you first have to calculate the distances
  distance_fun <- switch(dfun, dist = stats::dist, daisy = cluster::daisy)
  # both stats::dist and cluster::daisy accept data frames with numeric values:
  type.d <- do.call(distance_fun, c(list(type0), dfun.args))
  # the function `diss` accepts a `dist` object such as returned by `dist` and `daisy`
  type.diss <- diss(type.d)

  # the function `calculate` combines all the dissimilarities to one resulting
  # dissimilarity - in essence it multiplies the dissimilarities
  # optionally, it performs permutations - this is important to assess
  # statistical significance further down the line
  calculate <- function(permute = FALSE) {
    perm <- function(x) if (permute) sample(x) else x

    tmp0 <- data.frame(time = as.numeric(perm(tmp)), row.names = id)
    time.diss <- diss(stats::dist(tmp0))

    unit0 <- data.frame(id = id, unit = perm(unit), stringsAsFactors = FALSE)
    # mx.expand replaces the unit names by the ids and adds random noise 
    # where the resulting distances are zero by default - check function zero.noise
    unit1 <- mx.expand(unit0, e)
    unit.diss <- diss(stats::dist(unit1))

    # after calculating ypma dissimilarities for type, time, and unit
    # multiply them element-wise (i.e. calculate the "Hadamard-product").
    # This is a critical result that combines information regarding type, time, and place!
    type.diss * time.diss * unit.diss
  }

  # if no permuation is requested, return the combined ypma dissimilarity:
  if (!p) return(calculate(FALSE))

  # if permutation is requested a list of ypma dissimilarities are returned
  # computation on multiple cores is possible.
  # `worker` is `calculate` with permutation set to TRUE
  worker <- function(i) calculate(TRUE)
  # for windows permutations on multiple cores differ from linux
  if (.Platform$OS.type == "windows" && n.cores > 1L) {
    cl <- parallel::makeCluster(n.cores)
    on.exit(parallel::stopCluster(cl), add = TRUE)
    pbapply::pblapply(seq_len(p.n), worker, cl = cl)
  } else {
    pbapply::pblapply(seq_len(p.n), worker, cl = n.cores)
  }
}
