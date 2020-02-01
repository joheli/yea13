.onAttach <- function(...) {
  v <- packageVersion("yea13")
  packageStartupMessage(paste0("Package 'yea13' (version ", v, ") loaded."))
}
