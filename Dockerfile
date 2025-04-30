# ---------- Builder Stage ----------
FROM --platform=linux/amd64 rocker/shiny:latest AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    && rm -rf /var/lib/apt/lists/*

ENV CRAN_REPO="https://packagemanager.posit.co/cran/2025-04-22"

ENV NEMOGB_PKG="nemogb-dev/nemogb-r@main"

RUN mkdir -p /tmp/R_libs

ENV R_LIBS_USER="/tmp/R_libs"

# Install pak for efficient package management
RUN R -e "install.packages('pak', repos='https://r-lib.github.io/p/pak/stable')"

# Install all required packages with pak (handles dependencies and system requirements automatically)
RUN R -e "options(repos=c(CRAN='$CRAN_REPO')); \
          pak::pkg_install(c( \
            # Core packages
            'remotes', 'yaml', 'readr', \
            # Tidyverse packages
            'tidyverse', \
            # Shiny-related packages
            'bs4Dash', 'DT', 'shinyWidgets', 'plotly', 'bslib', \
            # Additional packages needed for the nemogb-app
            'shinydashboard', 'markdown', 'rmarkdown', 'knitr', \
            # Additional utility packages
            'htmltools', 'shiny', \
            # GitHub packages
            '$NEMOGB_PKG' \
          ), lib = '/tmp/R_libs')"

COPY R/ /tmp/app/

# ---------- Final Runtime Stage ----------
FROM --platform=linux/amd64 rocker/shiny:latest

COPY --from=builder /tmp/R_libs /usr/local/lib/R/site-library

COPY --from=builder /tmp/app/ /srv/shiny-server/

# Configure Shiny to listen on all interfaces (needed for GitHub Codespaces)
RUN echo "run_as shiny;\nserver {\n  listen 3838 0.0.0.0;\n  location / {\n    app_dir /srv/shiny-server;\n    log_dir /var/log/shiny-server;\n  }\n}" > /etc/shiny-server/shiny-server.conf

EXPOSE 3838
