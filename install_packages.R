# ==============================================================================
# Package Installation Script
# ==============================================================================
# 
# Purpose: Install all required packages for the Dog Breed Lifespan Analysis
# Author: Nicole Mark
# Date: 2025-10-23
# 
# Description:
# This script checks for and installs all required R packages for the analysis.
# Run this script once before running the analysis for the first time.
#
# ==============================================================================

cat("=== DOG BREED LIFESPAN ANALYSIS - PACKAGE SETUP ===\n\n")

# Define required packages
required_packages <- c(
  # Core visualization
  "ggplot2",      # Grammar of graphics
  "ggridges",     # Ridgeline plots
  "viridis",      # Color palettes
  "hrbrthemes",   # Clean themes
  
  # Data manipulation
  "dplyr",        # Data wrangling
  "readr",        # Data import
  "janitor",      # Data cleaning
  
  # Formatting and presentation
  "scales",       # Scale formatting
  "knitr",        # Report generation
  "kableExtra",   # Table formatting
  "rmarkdown",    # R Markdown
  
  # Statistical analysis
  "moments",      # Statistical moments
  
  # Utilities
  "here"          # Path management
)

cat("Checking for required packages...\n")

# Check which packages are missing
installed_packages <- installed.packages()[,"Package"]
missing_packages <- required_packages[!required_packages %in% installed_packages]

if (length(missing_packages) == 0) {
  cat("✓ All required packages are already installed!\n")
} else {
  cat("Installing missing packages:\n")
  for (pkg in missing_packages) {
    cat(sprintf("  - %s\n", pkg))
  }
  
  cat("\nInstalling packages...\n")
  install.packages(missing_packages, dependencies = TRUE)
  
  # Verify installation
  newly_installed <- installed.packages()[,"Package"]
  still_missing <- missing_packages[!missing_packages %in% newly_installed]
  
  if (length(still_missing) == 0) {
    cat("✓ All packages installed successfully!\n")
  } else {
    cat("⚠ The following packages could not be installed:\n")
    for (pkg in still_missing) {
      cat(sprintf("  - %s\n", pkg))
    }
    cat("\nPlease install these manually or check your internet connection.\n")
  }
}

# Test loading all packages
cat("\nTesting package loading...\n")
for (pkg in required_packages) {
  tryCatch({
    suppressPackageStartupMessages(library(pkg, character.only = TRUE))
    cat(sprintf("✓ %s loaded successfully\n", pkg))
  }, error = function(e) {
    cat(sprintf("✗ Failed to load %s: %s\n", pkg, e$message))
  })
}

cat("\n=== SETUP COMPLETE ===\n")
cat("You can now run the analysis scripts!\n")
cat("Start with: source('run_analysis.R')\n")