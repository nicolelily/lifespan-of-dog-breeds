# Dog Breed Lifespan Analysis

A comprehensive data visualization project analyzing the distribution of lifespans across dog breeds, grouped by United Kennel Club (UKC) breed classifications. This project demonstrates advanced R visualization techniques using ridgeline plots to reveal patterns in breed longevity.

## 📊 Project Overview

This analysis explores how dog lifespans vary across different breed groups, using statistical visualization techniques to highlight:
- Distribution patterns of lifespans within each breed group
- Identification of breeds with extreme lifespans (shortest and longest)
- Tail probability analysis using empirical cumulative distribution functions

## 🎯 Key Visualizations

### 1. Ridgeline Plot with ECDF Coloring
- **Purpose**: Shows tail probabilities across the lifespan distribution
- **Technique**: Uses empirical cumulative distribution function (ECDF) to color-code regions
- **Insight**: Highlights which breed groups have more variability in lifespans

### 2. Ridgeline Plot with Quantile Highlighting
- **Purpose**: Identifies breeds in extreme quantiles (shortest 2.5% and longest 2.5%)
- **Technique**: Quantile-based coloring to emphasize distribution tails
- **Insight**: Clearly shows which breed groups contain the longest and shortest-lived breeds

## 📁 Project Structure

```
├── README.md                          # Project documentation
├── data/
│   └── dog_breeds_lifespan.csv       # Original dataset
├── scripts/
│   ├── 01_data_preparation.R         # Data loading and cleaning
│   ├── 02_ridgeline_plot_ecdf.R      # ECDF-based visualization
│   └── 03_ridgeline_plot_quantiles.R # Quantile-based visualization
├── outputs/
│   └── plots/                        # Generated visualizations
└── project.Rproj                     # RStudio project file
```

## 🛠️ Technical Implementation

### Dependencies
```r
# Core visualization
library(ggplot2)      # Grammar of graphics
library(ggridges)     # Ridgeline plots
library(viridis)      # Color palettes
library(hrbrthemes)   # Clean themes

# Data manipulation
library(dplyr)        # Data wrangling
library(readr)        # Data import
library(janitor)      # Data cleaning

# Utilities
library(scales)       # Scale formatting
library(here)         # Path management
```

### Key Features
- **Modular code structure** with separate scripts for data prep and visualization
- **Comprehensive documentation** with inline comments and function descriptions
- **Professional styling** using modern ggplot2 themes and color palettes
- **Reproducible workflow** with proper dependency management
- **Statistical insights** including summary statistics and extreme value identification

## 📈 Key Findings

### Breed Group Lifespan Patterns
- **Companion Dogs**: Show wide variability in lifespans (8-16+ years)
- **Working Dogs**: Generally shorter lifespans due to larger body sizes
- **Toy Breeds**: Tend toward longer lifespans with less variability
- **Sporting Dogs**: Moderate lifespans with relatively normal distributions

### Statistical Insights
- Overall median lifespan: ~13 years
- Breed groups with highest variability show bi-modal distributions
- Clear correlation between breed size/purpose and longevity patterns

## 🚀 Getting Started

### Prerequisites
- R (version 4.0+)
- RStudio (recommended)
- Required R packages (see Dependencies section)

### Installation
1. Clone this repository
2. Open `project.Rproj` in RStudio
3. Install required packages:
   ```r
   install.packages(c("ggplot2", "ggridges", "viridis", "hrbrthemes", 
                      "dplyr", "readr", "janitor", "scales", "here"))
   ```

### Usage
Run scripts in order:
```r
# 1. Prepare the data
source("scripts/01_data_preparation.R")

# 2. Create ECDF visualization
source("scripts/02_ridgeline_plot_ecdf.R")

# 3. Create quantile visualization  
source("scripts/03_ridgeline_plot_quantiles.R")
```

## 📊 Data Source

The dataset contains information on 191 dog breeds with the following variables:
- **Breed**: Dog breed name
- **Breed Group UKC**: United Kennel Club breed classification
- **Height**: Average height in inches
- **Weight**: Average weight in pounds  
- **Lifespan**: Average lifespan in years

## 🎨 Visualization Techniques

### Ridgeline Plots
- Excellent for comparing distributions across multiple categories
- Maintains individual distribution shapes while enabling comparison
- Space-efficient alternative to multiple histograms or density plots

### Color Coding Strategies
1. **ECDF-based**: Colors regions based on cumulative probability
2. **Quantile-based**: Highlights extreme values in the distribution tails

### Statistical Overlays
- Quantile calculations for identifying outliers
- Summary statistics for each breed group
- Proper handling of missing data and edge cases

## 💡 Portfolio Highlights

This project demonstrates:
- **Advanced R visualization** using ggplot2 and specialized packages
- **Statistical thinking** with proper handling of distributions and quantiles
- **Professional code organization** with modular, documented scripts
- **Data storytelling** through thoughtful use of color and annotation
- **Reproducible research** practices with clear documentation

## 📝 Technical Notes

### Code Quality Features
- Comprehensive error handling and data validation
- Consistent naming conventions and code style
- Extensive commenting and documentation
- Modular functions for reusability
- Professional plot theming and typography

### Statistical Considerations
- Proper handling of sample sizes across breed groups
- Appropriate use of median vs. mean for skewed distributions
- Clear quantile definitions and interpretations
- Acknowledgment of data limitations and assumptions

---

*This project showcases advanced R programming and statistical visualization techniques for data science portfolio purposes.*