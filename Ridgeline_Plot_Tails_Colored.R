library(ggplot2)
library(ggridges)
library(viridis)
library(hrbrthemes)

ggplot(dog_data_r, aes(x=dog_data_r$Lifespan, y=dog_data_r$`Breed Group UKC`, fill =factor(stat(quantile)))) +
  stat_density_ridges(
    geom="density_ridges_gradient",
    calc_ecdf = TRUE,
    quantiles = c(0.025, 0.875)
  ) +
  scale_fill_manual(
    name="Probability", values = c("#EB6440","#D6E4E5","#497174"),
    labels= c("(0, 0.025)","(0.025,0.975)","(0.975,1)")
    ) +
  labs(title="Lifespan of Dogs by Breed Group", x="Lifespan (years)",y="Breed Group, UKC")
