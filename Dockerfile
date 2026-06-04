FROM rocker/r-ver:4.0.2

# System dependencies for Rcpp, igraph, curl-based remotes
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libssl-dev \
    libcurl4-openssl-dev \
    libxml2-dev \
    libgit2-dev \
    libglpk-dev \
    libgmp-dev \
    && rm -rf /var/lib/apt/lists/*

RUN Rscript -e "\
  install.packages('remotes', repos='https://cloud.r-project.org'); \
  install.packages(c('dplyr','pbapply','cluster','igraph','Rcpp','ape','tidyr','testthat'), \
    repos='https://cloud.r-project.org'); \
  install.packages('NetOrigin', repos='https://cloud.r-project.org'); \
  remotes::install_github('joheli/yea13') \
"

CMD ["R"]
