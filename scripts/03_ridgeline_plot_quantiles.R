# ==============================================================================
# Dog Breed Lifespan Analysis - Ridgeline Plot with Quantile Coloring
# ==============================================================================
# 
# Purpose: Create ridgeline plot showing lifespan distributions with quantile-based coloring
# Author: Nicole Mark
# Date: 2025-10-23
# 
# Description:
# This script creates a ridgeline plot visualization of dog breed lifespans
# by UKC breed group, using quantile-based coloring to highlight the tails
# of the distribution (extreme low and high lifespans).
#
# ==============================================================================

# Load required libraries
suppressPackageStartupMessages({
  library(ggplot2)
  library(ggridges)
  library(viridis)
  library(hrbrthemes)
  library(scales)
  library(here)
})

# Source data preparation script
source(here("scripts", "01_data_preparation.R"))

# Function to create ridgeline plot with quantile coloring
create_ridgeline_quantiles <- function(data, 
                                       lower_quantile = 0.025,
                                       upper_quantile = 0.975,
                                       save_plot = TRUE, 
                                       width = 12, 
                                       height = 8,
                                       dpi = 300) {
  
  cat("Creating ridgeline plot with quantile coloring...\n")
  cat(sprintf("Using quantiles: %.1f%% and %.1f%%\n", 
              lower_quantile * 100, upper_quantile * 100))
  
  # Create the plot
  p <- ggplot(data, aes(x = lifespan_years, 
                        y = breed_group, 
                        fill = factor(stat(quantile)))) +
    stat_density_ridges(
      geom = "density_ridges_gradient",
      calc_ecdf = TRUE,
      quantiles = c(lower_quantile, upper_quantile),
      alpha = 0.8,
      scale = 0.9,
      rel_min_height = 0.01
    ) +
    scale_fill_manual(
      name = "Lifespan Range",
      values = c("#E76F51", "#F4A261", "#2A9D8F"),  # Warm to cool color palette
      labels = c(
        sprintf("Shortest %.1f%%", lower_quantile * 100),
        sprintf("Middle %.1f%%", (upper_quantile - lower_quantile) * 100),
        sprintf("Longest %.1f%%", (1 - upper_quantile) * 100)
      )
    ) +
    scale_x_continuous(name = "Lifespan (years)",
                       breaks = seq(8, 18, 2),
                       limits = c(7, 19)) +
    scale_y_discrete(name = "UKC Breed Group") +
    labs(
      title = "Distribution of Dog Lifespans by Breed Group",
      subtitle = sprintf("Ridgeline plot highlighting shortest %.1f%% and longest %.1f%% lifespans", 
                        lower_quantile * 100, (1 - upper_quantile) * 100),
      caption = "Data: UKC breed classifications | Visualization: Nicole Mark"
    ) +
    theme_ipsum_rc(grid_col = "grey92",
                   axis_title_size = 12,
                   axis_text_size = 10) +
    theme(
      plot.title = element_text(size = 16, face = "bold", margin = margin(b = 8)),
      plot.subtitle = element_text(size = 11, color = "grey30", margin = margin(b = 16)),
      plot.caption = element_text(size = 9, color = "grey50", hjust = 0),
      legend.position = "right",
      legend.title = element_text(size = 10),
      legend.text = element_text(size = 9),
      panel.grid.major.y = element_blank(),
      panel.grid.minor.x = element_blank(),
      axis.text.y = element_text(size = 10),
      plot.margin = margin(20, 20, 20, 20)
    )
  
  # Display the plot
  print(p)
  
  # Save the plot if requested
  if (save_plot) {
    # Create outputs directory if it doesn't exist
    if (!dir.exists("outputs")) dir.create("outputs", recursive = TRUE)
    if (!dir.exists("outputs/plots")) dir.create("outputs/plots", recursive = TRUE)
    
    filename <- here("outputs", "plots", "ridgeline_lifespan_quantiles.png")
    
    ggsave(filename, plot = p, 
           width = width, height = height, dpi = dpi, 
           bg = "white", device = "png")
    
    cat(sprintf("Plot saved to: %s\n", filename))
  }
  
  return(p)
}

# Function to identify breeds in extreme quantiles
identify_extreme_breeds <- function(data, lower_quantile = 0.025, upper_quantile = 0.975) {
  
  # Calculate overall quantiles
  lower_cutoff <- quantile(data$lifespan_years, lower_quantile, na.rm = TRUE)
  upper_cutoff <- quantile(data$lifespan_years, upper_quantile, na.rm = TRUE)
  
  cat(sprintf("\n=== EXTREME LIFESPAN BREEDS ===\n"))
  cat(sprintf("Lower %.1f%% cutoff: %.1f years\n", lower_quantile * 100, lower_cutoff))
  cat(sprintf("Upper %.1f%% cutoff: %.1f years\n", upper_quantile * 100, upper_cutoff))
  
  # Shortest-lived breeds
  shortest_breeds <- data %>%
    filter(lifespan_years <= lower_cutoff) %>%
    arrange(lifespan_years) %>%
    select(breed, breed_group, lifespan_years)
  
  cat(sprintf("\nShortest-lived breeds (≤%.1f years):\n", lower_cutoff))
  print(shortest_breeds, n = Inf)
  
  # Longest-lived breeds
  longest_breeds <- data %>%
    filter(lifespan_years >= upper_cutoff) %>%
    arrange(desc(lifespan_years)) %>%
    select(breed, breed_group, lifespan_years)
  
  cat(sprintf("\nLongest-lived breeds (≥%.1f years):\n", upper_cutoff))
  print(longest_breeds, n = Inf)
  
  return(list(shortest = shortest_breeds, longest = longest_breeds))
}

# Create the visualization
if (!exists("ridgeline_quantiles_plot")) {
  ridgeline_quantiles_plot <- create_ridgeline_quantiles(dog_data_clean)
  extreme_breeds <- identify_extreme_breeds(dog_data_clean)
}