FROM rocker/r-ver:4.3.0

RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY DESCRIPTION /app/
RUN Rscript -e 'install.packages("remotes"); remotes::install_deps(dependencies = TRUE)'

COPY . /app

EXPOSE 8000

CMD ["Rscript", "scripts/04_serve_api.R"]
