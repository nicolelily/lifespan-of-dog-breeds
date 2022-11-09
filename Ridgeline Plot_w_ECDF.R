library(ggplot2)
library(ggridges)
library(viridis)
library(hrbrthemes)


p <- ggplot(dog_data_r, aes(x = dog_data_r$Lifespan, y=dog_data_r$`Breed Group UKC`,
  fill = 0.5 - abs(0.5 - stat(ecdf)))) +
  stat_density_ridges(geom = "density_ridges_gradient", calc_ecdf = TRUE) +
  scale_fill_viridis_c(name = "Tail probability", direction = -1) +
  labs(title="Lifespan of Dogs by Breed Group", x="Lifespan (years)",y="Breed Group, UKC")


  