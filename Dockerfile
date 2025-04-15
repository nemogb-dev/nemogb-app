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
ENV CRAN_REPO="https://packagemanager.posit.co/cran/latest"

# Create a directory to store installed R packages that we will copy later
RUN mkdir -p /tmp/R_libs

# Set library path to our temporary directory
ENV R_LIBS_USER="/tmp/R_libs"

# Install and verify core packages
RUN R -e "install.packages(c('remotes', 'yaml', 'readr'), dependencies=TRUE, repos='$CRAN_REPO')" && \
    R -e "pkgs <- c('remotes', 'yaml', 'readr'); \
          missing <- pkgs[!(pkgs %in% installed.packages(lib.loc = '$R_LIBS_USER')[,'Package'])]; \
          if (length(missing)) stop('Failed to install packages: ', paste(missing, collapse=', '))" 

# Install and verify tidyverse separately (most likely to fail)
RUN R -e "install.packages('tidyverse', dependencies=TRUE, repos='$CRAN_REPO', verbose=TRUE)" && \
    R -e "if (!('tidyverse' %in% installed.packages(lib.loc = '$R_LIBS_USER')[,'Package'])) \
          stop('Failed to install tidyverse')" 

# Install and verify Shiny-related packages
RUN R -e "install.packages(c('bs4Dash', 'DT', 'shinyWidgets', 'plotly', 'bslib'), dependencies=TRUE, repos='$CRAN_REPO')" && \
    R -e "pkgs <- c('bs4Dash', 'DT', 'shinyWidgets', 'plotly', 'bslib'); \
          missing <- pkgs[!(pkgs %in% installed.packages(lib.loc = '$R_LIBS_USER')[,'Package'])]; \
          if (length(missing)) stop('Failed to install packages: ', paste(missing, collapse=', '))"

# Install nemogb-r from GitHub
RUN R -e "remotes::install_github('nemogb-dev/nemogb-r@main', lib = '$R_LIBS_USER')"

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
