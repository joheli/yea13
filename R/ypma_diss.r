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
#' @param n.cores Number of cores used for permutations.
#' @return A Ypma dissimilarity matrix, or a list of matrices for permutations.
#' @export
ypma.diss <- function(d, e = NULL, tc, uc, ic,
                      dfun = c("dist", "daisy"),
                      dfun.args = list(method = "manhattan"),
                      p = FALSE, p.n = 3L,
                      n.cores = parallel::detectCores()) {
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
  if (is.na(n.cores) || n.cores < 1L) n.cores <- 1L
  n.cores <- as.integer(n.cores)

  tmp <- d[[tc]]
  unit <- d[[uc]]
  id <- as.character(d[[ic]])
  if (anyNA(id) || anyDuplicated(id)) {
    stop("The id column must contain unique, non-missing values.", call. = FALSE)
  }

  type0 <- d[, -c(tc, uc, ic), drop = FALSE]
  if (!ncol(type0)) stop("'d' must contain at least one type column.", call. = FALSE)
  rownames(type0) <- id

  distance_fun <- switch(dfun, dist = stats::dist, daisy = cluster::daisy)
  type.d <- do.call(distance_fun, c(list(type0), dfun.args))
  type.diss <- diss(type.d)

  calculate <- function(permute = FALSE) {
    perm <- function(x) if (permute) sample(x) else x

    tmp0 <- data.frame(time = as.numeric(perm(tmp)), row.names = id)
    time.diss <- diss(stats::dist(tmp0))

    unit0 <- data.frame(id = id, unit = perm(unit), stringsAsFactors = FALSE)
    unit1 <- mx.expand(unit0, e)
    unit.diss <- diss(stats::dist(unit1))

    type.diss * time.diss * unit.diss
  }

  if (!p) return(calculate(FALSE))

  worker <- function(i) calculate(TRUE)
  if (.Platform$OS.type == "windows" && n.cores > 1L) {
    cl <- parallel::makeCluster(n.cores)
    on.exit(parallel::stopCluster(cl), add = TRUE)
    pbapply::pblapply(seq_len(p.n), worker, cl = cl)
  } else {
    pbapply::pblapply(seq_len(p.n), worker, cl = n.cores)
  }
}
