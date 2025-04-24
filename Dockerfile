# ---------- Builder Stage ----------
# Explicitly specify platform for ARM Mac compatibility
FROM --platform=linux/amd64 rocker/shiny:latest AS builder

# Install system dependencies needed for building packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    && rm -rf /var/lib/apt/lists/*

# Set CRAN repository to use precompiled binaries
ENV CRAN_REPO="https://packagemanager.posit.co/cran/2025-04-22"

# Set nemogb-r package reference
ENV NEMOGB_PKG="nemogb-dev/nemogb-r@main"

# Create a directory to store installed R packages that we will copy later
RUN mkdir -p /tmp/R_libs

# Set library path to our temporary directory
ENV R_LIBS_USER="/tmp/R_libs"

# Install pak for efficient package management
RUN R -e "install.packages('pak', repos='$CRAN_REPO')"

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
            "$NEMOGB_PKG" \
          ), lib = '/tmp/R_libs')"

# Copy the application code into the builder (for later copy to final image)
COPY R/ /tmp/app/

# ---------- Final Runtime Stage ----------
# Ensure consistent platform between stages
FROM --platform=linux/amd64 rocker/shiny:latest

# Copy installed R packages from builder stage
COPY --from=builder /tmp/R_libs /usr/local/lib/R/site-library

# Copy application code
COPY --from=builder /tmp/app/ /srv/shiny-server/

# Expose the default Shiny Server port
EXPOSE 3838

# The base image already contains an entrypoint for launching Shiny Server
