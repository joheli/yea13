% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ypma_diss.r
\name{ypma.diss}
\alias{ypma.diss}
\title{Calculate Ypma dissimilarities for type, time, and unit}
\usage{
ypma.diss(
  d,
  e = NULL,
  tc,
  uc,
  ic,
  dfun = c("dist", "daisy"),
  dfun.args = list(method = "manhattan"),
  p = F,
  p.n = 3,
  n.cores = parallel::detectCores()
)
}
\arguments{
\item{d}{A \code{data.frame} containing columns for id, time, unit (e.g. ward) and type (represented by remaining columns).}

\item{e}{A quadratic matrix with identical row and column names representing effective distances of units contained in \code{d}.}

\item{tc}{A character or numeric identifying name or number, respectively, of id column in \code{d}.}

\item{uc}{A character or numeric identifying name or number, respectively, of unit column in \code{d}.}

\item{dfun}{A character specifying name of function for distance (dissimilarity) calculation of type columns.}

\item{dfun.args}{A list specifying arguments passed to \code{dfun}.}

\item{p}{A logical specifying if permutation is to be performed. Defaults to \code{FALSE}.}

\item{p.n}{An integer specifying number of permutations performed if \code{p} is \code{TRUE}.}

\item{n.cores}{An integer specifying the number of cores used for permutations. Defaults to maximum number of cores (as per \code{parallel::detectCores()}).}
}
\value{
If \code{p} is \code{FALSE} (default) a square matrix containing Ypma dissimilarities between rows in \code{d} (represented by id), and a list with Ypma dissimilarity matrices of random permutations of \code{d} otherwise.
}
\description{
This function takes a \code{data.frame} of one species (or other sensible taxonomic unit) containing
information on time, unit, and type to calculate Ypma dissimilarities between entries.
}
