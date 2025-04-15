# Base image with R and Shiny Server (specify platform for ARM Macs)
# Consider using a specific tag like rocker/shiny:4.3.1 for reproducibility
FROM --platform=linux/amd64 rocker/shiny:latest

# Step 1: Install system dependencies needed for packages and git
# Combined into one layer, cleans up apt cache
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    && rm -rf /var/lib/apt/lists/*

# Step 2: Install CRAN packages using precompiled binaries (including remotes)
# Combined into one layer. Consider pinning the repo date for reproducibility.
RUN R -e "install.packages(c('remotes', 'bs4Dash', 'DT', 'shinyWidgets', 'tidyverse', 'yaml', 'plotly', 'bslib', 'readr'), dependencies=TRUE, repos='https://packagemanager.posit.co/cran/latest')"

# Verify critical packages are installed
RUN R -e "pkgs <- c('remotes', 'bs4Dash', 'DT', 'shinyWidgets', 'tidyverse', 'yaml', 'plotly', 'bslib', 'readr'); missing <- pkgs[!(pkgs %in% installed.packages()[,'Package'])]; if (length(missing)) stop('Failed to install packages: ', paste(missing, collapse=', '))"

# Step 3: Install nemogb-r package from GitHub
# This step might still be slow if compilation is needed.
RUN R -e "remotes::install_github('nemogb-dev/nemogb-r@main')"

# Step 4: Copy the application code
# Copying code *after* dependencies leverages Docker cache
COPY R/ /srv/shiny-server/

# Step 5: Expose the default Shiny Server port
EXPOSE 3838

# Optional: Add a CMD to run the Shiny Server if not inherited
# CMD ["/usr/bin/shiny-server"]