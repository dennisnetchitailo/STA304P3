#### Preamble ####
# Purpose: Simulates 
# Author: Dennis Netchitailo
# Date: 28 November 2024
# Contact: dennis.netchitailo@mail.utoronto.ca
# License: MIT
# Pre-requisites: The `tidyverse` package must be installed
# Any other information needed? Make sure you are in the `starter_folder` rproj


#### Workspace setup ####
library(tidyverse)
set.seed(1939)

#### Simulate data ####
total_incidents = 32514
num_casualties = 66000 + 220000 # ~ Dead + ~ Injured
mean_casualties = num_casualties / total_incidents

#Poisson Distribution Simulation
simulated_casualties <- rpois(n = total_incidents, lambda = mean_casualties)

# Verify Results
total_simulated_casualties <- sum(simulated_casualties)
mean_simulated_casualties <- mean(simulated_casualties)
sd_simulated_casualties <- sd(simulated_casualties)

# Output results
cat("Total Simulated Casualties:", total_simulated_casualties, "\n")
cat("Mean Simulated Casualties per Incident:", mean_simulated_casualties, "\n")
cat("Standard Deviation of Simulated Casualties:", sd_simulated_casualties, "\n")














# Political parties
parties <- c("Labor", "Liberal", "Greens", "National", "Other")

# Create a dataset by randomly assigning states and parties to divisions
analysis_data <- tibble(
  division = paste("Division", 1:151),  # Add "Division" to make it a character
  state = sample(
    states,
    size = 151,
    replace = TRUE,
    prob = c(0.25, 0.25, 0.15, 0.1, 0.1, 0.1, 0.025, 0.025) # Rough state population distribution
  ),
  party = sample(
    parties,
    size = 151,
    replace = TRUE,
    prob = c(0.40, 0.40, 0.05, 0.1, 0.05) # Rough party distribution
  )
)


#### Save data ####
write_csv(analysis_data, "data/00-simulated_data/simulated_data.csv")
