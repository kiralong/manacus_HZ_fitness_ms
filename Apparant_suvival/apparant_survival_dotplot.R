## R script for plotting Manacus apparent survival and CI's as dotplots

## Load required libraries
library(ggplot2)
library(dplyr)

setwd("~/figuresandtables")

# Read in data

survival_data <- read.csv("survival_graphing_data_all_phiGpG.csv", header = TRUE)

# Make the species column into unique factors to keep the order for graphing
survival_data$Species <- as.character(survival_data$Species)
survival_data$Species <- factor(survival_data$Species, levels = unique(survival_data$Species))

# Make dot plot
fig <- ggplot(data=survival_data, aes(x=Species, y=Survival_Estimate)) +
  
  geom_point(size=4) +
  
  geom_errorbar(aes(ymin = lowerCI, ymax = upperCI), width =0.2) +
  
  # Add axis limits
  ylim(0,1) +
  # Add axis names
  labs(y="Apparent Survival Estimate",
       x="Hybrid Status") +
  
  # Set Themes
  theme_light(base_size=16) +
  
  # Centralize title
  theme(plot.title=element_text(hjust=0.5), 
        legend.title=element_blank(),
        legend.position = "none") +
  theme(axis.text.x = element_text(face = "italic"))

fig

# Save plot
ggsave('./apparant_survival_dotplot_phiGpG.pdf', plot=fig, width=4, height=4)
