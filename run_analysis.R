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

# Load required libraries
cat("Loading required packages...\n")
required_packages <- c("ggplot2", "ggridges", "viridis", "hrbrthemes", 
                      "dplyr", "readr", "janitor", "scales", "here")

# Install missing packages
missing_packages <- required_packages[!required_packages %in% installed.packages()[,"Package"]]
if(length(missing_packages) > 0) {
  cat("Installing missing packages:", paste(missing_packages, collapse = ", "), "\n")
  install.packages(missing_packages)
}

# Load packages
suppressPackageStartupMessages({
  invisible(lapply(required_packages, library, character.only = TRUE))
})

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

cat("\n\n=== ANALYSIS COMPLETE ===\n")
cat("All visualizations have been generated and saved to outputs/plots/\n")
cat("Check the following files:\n")
cat("- outputs/plots/ridgeline_lifespan_ecdf.png\n")
cat("- outputs/plots/ridgeline_lifespan_quantiles.png\n")