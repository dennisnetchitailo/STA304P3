#### Preamble ####
# Purpose: Simulates the distribution of casualties in the casualties data
# Author: Dennis Netchitailo
# Date: 28 November 2024
# Contact: dennis.netchitailo@mail.utoronto.ca
# License: --
# Pre-requisites: The `tidyverse` package must be installed


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


#### Save data ####
write_csv(analysis_data, "data/00-simulated_data/simulated_data.csv")
