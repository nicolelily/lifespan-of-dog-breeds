# ==============================================================================
# Dog Breed Lifespan Analysis - Data Preparation
# ==============================================================================
# 
# Purpose: Load and prepare dog breed data for visualization
# Author: Nicole Mark
# Date: 2025-10-23
# 
# Description:
# This script loads the dog breed dataset and performs basic data cleaning
# and preparation for ridgeline plot visualizations.
#
# ==============================================================================

# Load required libraries
suppressPackageStartupMessages({
  library(readr)
  library(dplyr)
  library(janitor)
  library(forcats)
})

# Function to load and clean dog breed data
load_dog_data <- function(file_path = "data/dog_breeds_lifespan.csv") {
  
  cat("Loading dog breed data...\n")
  
  # Load data
  dog_data <- read_csv(file_path, 
                       show_col_types = FALSE,
                       col_types = cols(
                         Breed = col_character(),
                         `Breed Group UKC` = col_character(),
                         Height = col_double(),
                         Weight = col_double(),
                         Lifespan = col_double()
                       ))
  
  # Clean column names and data
  dog_data_clean <- dog_data %>%
    clean_names() %>%
    rename(
      breed_group = breed_group_ukc,
      height_inches = height,
      weight_lbs = weight,
      lifespan_years = lifespan
    ) %>%
    # Remove any rows with missing lifespan data
    filter(!is.na(lifespan_years)) %>%
    # Ensure breed groups are factors for better plotting
    mutate(
      breed_group = factor(breed_group),
      # Reorder breed groups by median lifespan for better visualization
      breed_group = fct_reorder(breed_group, lifespan_years, .fun = median)
    )
  
  cat(sprintf("Data loaded successfully: %d breeds across %d breed groups\n", 
              nrow(dog_data_clean), 
              length(unique(dog_data_clean$breed_group))))
  
  return(dog_data_clean)
}

# Function to display data summary
summarize_data <- function(data) {
  cat("\n=== DATA SUMMARY ===\n")
  
  # Overall statistics
  cat(sprintf("Total breeds: %d\n", nrow(data)))
  cat(sprintf("Breed groups: %d\n", length(unique(data$breed_group))))
  cat(sprintf("Lifespan range: %.1f - %.1f years\n", 
              min(data$lifespan_years, na.rm = TRUE),
              max(data$lifespan_years, na.rm = TRUE)))
  
  # Breed group summary
  cat("\n=== BREED GROUP SUMMARY ===\n")
  breed_summary <- data %>%
    group_by(breed_group) %>%
    summarise(
      count = n(),
      median_lifespan = median(lifespan_years, na.rm = TRUE),
      mean_lifespan = mean(lifespan_years, na.rm = TRUE),
      .groups = "drop"
    ) %>%
    arrange(desc(median_lifespan))
  
  print(breed_summary, n = Inf)
}

# Load the data if script is run directly
if (!exists("dog_data_clean")) {
  # Check if running from project root or scripts directory
  if (file.exists("data/dog_breeds_lifespan.csv")) {
    dog_data_clean <- load_dog_data("data/dog_breeds_lifespan.csv")
  } else if (file.exists("../data/dog_breeds_lifespan.csv")) {
    dog_data_clean <- load_dog_data("../data/dog_breeds_lifespan.csv")
  } else {
    stop("Could not find dog_breeds_lifespan.csv. Please ensure the file exists in the correct location.")
  }
  
  # Display summary
  summarize_data(dog_data_clean)
}