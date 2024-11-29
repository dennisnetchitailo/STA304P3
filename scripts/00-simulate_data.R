#### Preamble ####
# Purpose: Simulates the distribution of casualties in the casualties data
# Author: Dennis Netchitailo
# Date: 28 November 2024
# Contact: dennis.netchitailo@mail.utoronto.ca
# License: --
# Pre-requisites: The `tidyverse` and `here` packages must be installed

#### Workspace setup ####
library(tidyverse)
library(here)
set.seed(1939) # For reproducibility keep it as "1939"

#### Simulate data ####

total_incidents = 32514
num_casualties = 66000 + 220000 # ~ Dead + ~ Injured
mean_casualties = num_casualties / total_incidents

# Generate Dataset

simulated_bombing_data <- tibble(
  # Unique ID for each incident
  incident_id = 1:total_incidents,
  
  # Randomly assign dates within a specific range
  date = sample(seq.Date(from = as.Date("1939-09-01"), 
                         to = as.Date("1940-05-10"), by = "day"), 
                size = total_incidents, replace = TRUE),
  
  # Randomly assign locations (example locations)
  location = sample(c("London", "Manchester", "Liverpool", "Birmingham", "Coventry"), 
                    size = total_incidents, replace = TRUE),
  
  # Simulate casualties using a Poisson distribution
  casualties = rpois(n = total_incidents, lambda = mean_casualties)
)

#### Save dataset ####
output_path <- here("data/00-simulated_data/simulated_data.csv")
write_csv(simulated_bombing_data, output_path)

#### Verify dataset ####
# Check structure
print(simulated_bombing_data)
cat("File saved at:", output_path, "\n")

# Summary of casualties
summary(simulated_bombing_data$casualties)

#_______________________________________________________________________________

# Verify Results
#total_simulated_casualties <- sum(simulated_casualties)
#mean_simulated_casualties <- mean(simulated_casualties)
#sd_simulated_casualties <- sd(simulated_casualties)


