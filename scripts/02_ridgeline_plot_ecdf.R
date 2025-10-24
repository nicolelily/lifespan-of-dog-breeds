# ==============================================================================
# Dog Breed Lifespan Analysis - Ridgeline Plot with ECDF
# ==============================================================================
# 
# Purpose: Create ridgeline plot showing lifespan distributions with ECDF coloring
# Author: Nicole Mark
# Date: 2025-10-23
# 
# Description:
# This script creates a ridgeline plot visualization of dog breed lifespans
# by UKC breed group, using empirical cumulative distribution function (ECDF)
# coloring to highlight tail probabilities.
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

# Function to create ridgeline plot with ECDF coloring
create_ridgeline_ecdf <- function(data, 
                                  save_plot = TRUE, 
                                  width = 12, 
                                  height = 8,
                                  dpi = 300) {
  
  cat("Creating ridgeline plot with ECDF coloring...\n")
  
  # Create the plot
  p <- ggplot(data, aes(x = lifespan_years, 
                        y = breed_group,
                        fill = 0.5 - abs(0.5 - stat(ecdf)))) +
    stat_density_ridges(geom = "density_ridges_gradient", 
                        calc_ecdf = TRUE,
                        alpha = 0.8,
                        scale = 0.9,
                        rel_min_height = 0.01) +
    scale_fill_viridis_c(name = "Tail\nProbability", 
                         direction = -1,
                         option = "plasma",
                         labels = scales::percent_format(accuracy = 1)) +
    scale_x_continuous(name = "Lifespan (years)",
                       breaks = seq(8, 18, 2),
                       limits = c(7, 19)) +
    scale_y_discrete(name = "UKC Breed Group") +
    labs(
      title = "Distribution of Dog Lifespans by Breed Group",
      subtitle = "Ridgeline plot with tail probability coloring based on empirical cumulative distribution",
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
    
    filename <- here("outputs", "plots", "ridgeline_lifespan_ecdf.png")
    
    ggsave(filename, plot = p, 
           width = width, height = height, dpi = dpi, 
           bg = "white", device = "png")
    
    cat(sprintf("Plot saved to: %s\n", filename))
  }
  
  return(p)
}

# Function to add statistical annotations
add_statistics_summary <- function(data) {
  cat("\n=== STATISTICAL INSIGHTS ===\n")
  
  stats_summary <- data %>%
    group_by(breed_group) %>%
    summarise(
      n_breeds = n(),
      mean_lifespan = round(mean(lifespan_years, na.rm = TRUE), 1),
      median_lifespan = round(median(lifespan_years, na.rm = TRUE), 1),
      sd_lifespan = round(sd(lifespan_years, na.rm = TRUE), 1),
      min_lifespan = min(lifespan_years, na.rm = TRUE),
      max_lifespan = max(lifespan_years, na.rm = TRUE),
      .groups = "drop"
    ) %>%
    arrange(desc(median_lifespan))
  
  print(stats_summary, n = Inf)
  
  # Overall statistics
  cat(sprintf("\nOverall median lifespan: %.1f years\n", 
              median(data$lifespan_years, na.rm = TRUE)))
  cat(sprintf("Overall mean lifespan: %.1f years\n", 
              mean(data$lifespan_years, na.rm = TRUE)))
}

# Create the visualization
if (!exists("ridgeline_ecdf_plot")) {
  ridgeline_ecdf_plot <- create_ridgeline_ecdf(dog_data_clean)
  add_statistics_summary(dog_data_clean)
}