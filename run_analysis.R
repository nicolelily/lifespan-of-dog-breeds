# ==============================================================================
# Dog Breed Lifespan Analysis - Master Script
# ==============================================================================
# 
# Purpose: Run complete analysis pipeline
# Author: Nicole Mark
# Date: 2025-10-23
# 
# Description:
# This master script runs the complete analysis pipeline in the correct order.
# It sources all individual scripts and generates both visualizations with
# comprehensive output and documentation.
#
# ==============================================================================

# Clear workspace
rm(list = ls())

# Set CRAN mirror
options(repos = c(CRAN = "https://cloud.r-project.org"))

# Load required libraries
cat("Loading required packages...\n")
required_packages <- c("ggplot2", "ggridges", "viridis", "dplyr", "readr", "janitor", "scales", "here", "forcats")
optional_packages <- c("hrbrthemes")

# Install missing required packages
missing_packages <- required_packages[!required_packages %in% installed.packages()[,"Package"]]
if(length(missing_packages) > 0) {
  cat("Installing missing packages:", paste(missing_packages, collapse = ", "), "\n")
  install.packages(missing_packages)
}

# Try to install optional packages (don't fail if they can't be installed)
missing_optional <- optional_packages[!optional_packages %in% installed.packages()[,"Package"]]
if(length(missing_optional) > 0) {
  cat("Attempting to install optional packages:", paste(missing_optional, collapse = ", "), "\n")
  tryCatch({
    install.packages(missing_optional)
  }, error = function(e) {
    cat("Warning: Could not install optional packages:", paste(missing_optional, collapse = ", "), "\n")
  })
}

# Load required packages
suppressPackageStartupMessages({
  invisible(lapply(required_packages, library, character.only = TRUE))
})

# Load optional packages (don't fail if not available)
for(pkg in optional_packages) {
  tryCatch({
    suppressPackageStartupMessages(library(pkg, character.only = TRUE))
    cat("Loaded optional package:", pkg, "\n")
  }, error = function(e) {
    cat("Optional package not available:", pkg, "\n")
  })
}

cat("All packages loaded successfully!\n\n")

# Set up project
cat("=== DOG BREED LIFESPAN ANALYSIS ===\n")
cat("Starting complete analysis pipeline...\n\n")

# Create output directories
if (!dir.exists("outputs")) dir.create("outputs", recursive = TRUE)
if (!dir.exists("outputs/plots")) dir.create("outputs/plots", recursive = TRUE)

# Run analysis pipeline
cat("Step 1: Data Preparation\n")
cat("------------------------\n")
source(here("scripts", "01_data_preparation.R"))

cat("\n\nStep 2: ECDF Ridgeline Visualization\n")
cat("------------------------------------\n")
source(here("scripts", "02_ridgeline_plot_ecdf.R"))

cat("\n\nStep 3: Quantile Ridgeline Visualization\n")
cat("----------------------------------------\n")
source(here("scripts", "03_ridgeline_plot_quantiles.R"))

cat("\n\nStep 4: Median Lifespan Bar Chart\n")
cat("----------------------------------\n")
source(here("scripts", "04_bar_chart_median_lifespan.R"))

cat("\n\n=== ANALYSIS COMPLETE ===\n")
cat("All visualizations have been generated and saved to outputs/plots/\n")
cat("Check the following files:\n")
cat("- outputs/plots/ridgeline_lifespan_ecdf.png\n")
cat("- outputs/plots/ridgeline_lifespan_quantiles.png\n")
cat("- outputs/plots/median_lifespan_by_group.png\n")