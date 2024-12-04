#### Preamble ####
# Purpose: Models the effect of time of an air raid on casualties.
# Author: Dennis Netchitailo
# Date: 30 November 2024
# Contact: dennis.netchitailo@mail.utoronto.ca 
# License: --
# Pre-requisites: --
  # - The `tidyverse` package must be installed and loaded
  # - The `rstanarm` package must be installed and loaded
  # - The `ggplot2` package must be installed and loaded
  # - The `brms` package must be installed and loaded
  # - The `broom.mixed` package must be installed and loaded

# Any other information needed? No.


#### Workspace setup ####
library(tidyverse)
library(rstanarm)
library(dplyr)
library(ggplot2)
library(brms)
library(broom.mixed)

#### Read data ####
#model_data <- read_csv("data/analysis_data/combined_data")
model_data <- read_csv("C:/Users/Dennis Netchitailo/Documents/air-raids/data/02-analysis_data/combined_data.csv")

#"C:/Users/Dennis Netchitailo/Documents/air-raids/data/02-analysis_data/combined_data.csv"

### Model data ####
first_model <- brm(
  total_casualties ~ 
    year + month + time_binary + time_binary + lethality_category + country + civil_defense_region + 
    (1 | casualty_group) + (1 | civil_defense_region),
  data = combined_data,
  family = zero_inflated_negbinomial(),
  prior = c(
    prior(normal(0, 1), class = "b"),
    prior(exponential(1), class = "sd")
  ),
  chains = 4,
  cores = 14,  # Use 14 cores for faster computation
  iter = 2000
)


#### Save model ####
saveRDS(
  first_model,
  file = "models/first_model.rds"
)


