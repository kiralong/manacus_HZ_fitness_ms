# Do a  binomial Regression on the nesting data with success/failure of egg in nest

# Set working directory
setwd("~/Nesting_analyses")

# Install Needed Packages
#install.packages('nlme')
#install.packages("ciTools")
#install.packages('dplyr')

# Load needed libraries
library(nlme)
library(dplyr)
library(ciTools)
library(ggplot2)

# example/pseudo-code
# example <- glm(cbind(success, failure) ~ covars, data = dat, family = binomial)
# summary(example)

# Read in data, a csv of each nest with the number of eggs that hatched, did not hatch, and which species/hybrid status
hatch_data <- read.csv("binomial_regression_nest_data.csv", header = TRUE, sep = ",")

# Check data
# str(hatch_data)

# Run the binomial regression
hatch_glm <- glm(cbind(hatch, nohatch) ~ spp, data = hatch_data, family = binomial)
# summary(hatch_glm)

## Prep data for plotting proportions
# Add number of eggs per nest
hatch_data$num_eggs <- (hatch_data$hatch+hatch_data$nohatch)
# Calculate proportion of eggs that either hatched or did not hatch (choose one) of the below
#hatch_data$prop_nohatch <- (hatch_data$nohatch/hatch_data$num_eggs)
hatch_data$prop_hatched <- as.character(hatch_data$hatch/hatch_data$num_eggs)
# Add an overall nest label for coloring the proportions in the bar graph
hatch_data$nest_label <- factor(ifelse(hatch_data$prop_hatched<1,"Failed","Hatched"))

# Make a dataframe of just the information you want plotted
plot_data <- hatch_data %>% group_by(spp,nest_label) %>% summarize(n=n()) %>% mutate(freq=n/sum(n))
plot_data

## Make a paired bargraph of proprotions of nests that had eggs hatch or failed to hatch using the 'plot_data' you just made

fig <- ggplot(plot_data, aes(x=factor(spp, level=c("M. candei", "Hybrid", "M. vitellinus")), y=freq, fill=nest_label)) + 
  geom_bar(position="dodge",
           stat = "identity",
           color = "gray35") +
  
  # Add titles to axes
  labs(x='Hybrid Status',
       y='Proportion of Nests') +
  
  # Set Themes
  theme_light(base_size=16) +
  theme(legend.background = element_rect(size=0.5, linetype="solid",
                                         colour ="gray85")) +
  scale_fill_manual(name = "Proportion of\nnests where:",
                      labels=c('One or more eggs failed to hatch','All eggs hatched'),
                      values = c("#FC4E07","#00AFBB")) +
  
  # Titles and legends
  theme(plot.title=element_blank()) +
  theme(legend.position = "bottom") +
  guides(fill = guide_legend(nrow = 2, byrow = TRUE)) +
  theme(axis.text.x = element_text(face = "italic"))

fig

# Save a pdf of the plot
ggsave('./hatching_success_paired_barplot.pdf', plot=fig, width=6, height=6)
