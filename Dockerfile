FROM rocker/r-ver:4.5.1

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libcurl4-openssl-dev \
    libglpk-dev \
    libgmp-dev \
    libssl-dev \
    libxml2-dev \
    && rm -rf /var/lib/apt/lists/*

RUN Rscript -e "install.packages(c('remotes', 'testthat'), repos='https://cloud.r-project.org')"

WORKDIR /pkg
COPY . /pkg

RUN Rscript -e "remotes::install_deps('/pkg', dependencies = TRUE, repos='https://cloud.r-project.org')" \
    && R CMD INSTALL /pkg

CMD ["R"]
