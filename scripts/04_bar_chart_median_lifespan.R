# ==============================================================================
# Dog Breed Lifespan Analysis - Bar Chart Visualization
# ==============================================================================
# 
# Purpose: Create bar chart showing median lifespan by breed group
# Author: Nicole Mark
# Date: 2025-10-23
# 
# Description:
# This script creates a clean bar chart that emphasizes the differences in
# median lifespan across breed groups, complementing the ridgeline plots.
#
# ==============================================================================

# Load required libraries
suppressPackageStartupMessages({
  library(ggplot2)
  library(dplyr)
  library(scales)
  library(here)
})

# Source data preparation script
source(here("scripts", "01_data_preparation.R"))

# Function to create bar chart of median lifespans
create_median_lifespan_bar_chart <- function(data, 
                                             save_plot = TRUE,
                                             output_dir = "outputs/plots",
                                             filename = "median_lifespan_by_group.png",
                                             width = 12,
                                             height = 8,
                                             dpi = 300) {
  
  cat("Creating bar chart of median lifespans by breed group...\n")
  
  # Calculate median lifespan and count for each breed group
  breed_summary <- data %>%
    group_by(breed_group) %>%
    summarise(
      median_lifespan = median(lifespan_years, na.rm = TRUE),
      n_breeds = n(),
      .groups = "drop"
    ) %>%
    # Reorder by median lifespan for better visualization
    arrange(desc(median_lifespan)) %>%
    mutate(breed_group = factor(breed_group, levels = breed_group))
  
  # Create the bar chart
  p <- ggplot(breed_summary, aes(x = breed_group, y = median_lifespan)) +
    geom_col(fill = "#7BA5A3",  # Medium teal matching quantiles plot
             width = 0.7,
             alpha = 0.9) +
    geom_text(aes(label = paste0(median_lifespan, " yrs\n(n=", n_breeds, ")")),
              vjust = -0.5,
              size = 3.5,
              color = "grey20") +
    scale_y_continuous(
      name = "Median Lifespan (years)",
      breaks = seq(0, 14, 2),
      limits = c(0, 15),
      expand = c(0, 0)
    ) +
    scale_x_discrete(name = "UKC Breed Group") +
    labs(
      title = "Median Lifespan Varies Significantly Across Dog Breed Groups",
      subtitle = "Companion dogs and terriers live longest, while guardian breeds have shorter lifespans",
      caption = "Data: UKC breed classifications | Visualization: Nicole Mark"
    ) +
    theme_minimal() +
    theme(
      plot.title = element_text(size = 16, face = "bold", margin = margin(b = 8)),
      plot.subtitle = element_text(size = 12, color = "grey30", margin = margin(b = 16)),
      plot.caption = element_text(size = 9, color = "grey50", hjust = 0),
      axis.title.x = element_text(size = 12, margin = margin(t = 12)),
      axis.title.y = element_text(size = 12, margin = margin(r = 12)),
      axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
      axis.text.y = element_text(size = 10),
      legend.position = "right",
      legend.title = element_text(size = 10),
      legend.text = element_text(size = 9),
      panel.grid.major.x = element_blank(),
      panel.grid.minor.y = element_blank(),
      plot.margin = margin(20, 20, 20, 20),
      strip.text = element_text(size = 11, face = "bold")
    )
  
  # Print summary statistics
  cat("\n=== MEDIAN LIFESPAN BY BREED GROUP ===\n")
  print(breed_summary, n = Inf)
  
  # Calculate and display range
  lifespan_range <- max(breed_summary$median_lifespan) - min(breed_summary$median_lifespan)
  cat(sprintf("\nLifespan range across groups: %.1f years\n", lifespan_range))
  cat(sprintf("Longest-lived group: %s (%.1f years)\n", 
              breed_summary$breed_group[1], breed_summary$median_lifespan[1]))
  cat(sprintf("Shortest-lived group: %s (%.1f years)\n", 
              breed_summary$breed_group[nrow(breed_summary)], 
              breed_summary$median_lifespan[nrow(breed_summary)]))
  
  # Save plot if requested
  if (save_plot) {
    # Ensure output directory exists
    if (!dir.exists(output_dir)) {
      dir.create(output_dir, recursive = TRUE)
    }
    
    # Save the plot
    output_path <- file.path(output_dir, filename)
    ggsave(output_path, plot = p, width = width, height = height, dpi = dpi)
    cat(sprintf("Plot saved to: %s\n", normalizePath(output_path)))
  }
  
  return(p)
}

# Generate the plot if script is run directly
if (!exists("dog_data_clean")) {
  # Check if running from project root or scripts directory
  if (file.exists("data/dog_breeds_lifespan.csv")) {
    dog_data_clean <- load_dog_data("data/dog_breeds_lifespan.csv")
  } else if (file.exists("../data/dog_breeds_lifespan.csv")) {
    dog_data_clean <- load_dog_data("../data/dog_breeds_lifespan.csv")
  } else {
    stop("Could not find dog_breeds_lifespan.csv. Please ensure the file exists in the correct location.")
  }
}

# Create and save the bar chart
median_bar_chart <- create_median_lifespan_bar_chart(dog_data_clean)