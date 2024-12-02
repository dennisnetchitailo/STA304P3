#### Preamble ####
# Purpose: Models... [...UPDATE THIS...]
# Author: Dennis Netchitailo
# Date: 30 November 2024
# Contact: dennis.netchitailo@mail.utoronto.ca 
# License: --
# Pre-requisites: 
  # - 03-clean_data.R must have been run
  # - The `tidyverse` package must be installed and loaded
  # - The `rstanarm` package must be installed and loaded
  # - The `ggplot2` package must be installed and loaded

# Any other information needed? [...UPDATE THIS...]


#### Workspace setup ####
library(tidyverse)
library(rstanarm)
library(dplyr)
library(ggplot2)


source_folder = "C:/Users/Dennis Netchitailo/Documents/STA304P3"

load_csv <- function(file_name, base_folder = source_folder) {
  file_path <- file.path(base_folder, file_name)
  data <- read.csv(file_path)
  return(data)
}

#### Load Datasets ####

# Load casualties_data.csv
casualties_analysis_data <- load_csv("data/02-analysis_data/analysis_data_casualties.csv")

# Load bombings_data.csv
bombings_analysis_data <- load_csv("data/02-analysis_data/analysis_data_bombings.csv")


#### Read data ####
#analysis_data <- read_csv("data/analysis_data/analysis_data.csv")

### Model data ####

## CASUALTIES DATASET ##

# Sum Killed
sum(casualties_analysis_data$killed, na.rm = TRUE)

# Sum Injured
sum(casualties_analysis_data$injured, na.rm = TRUE)

# Sum Casualties
sum(casualties_analysis_data$total_casualties, na.rm = TRUE)

# Sum of difference between Casualties and Killed & Injured
sum(casualties_analysis_data$total_casualties, na.rm = TRUE) - 
  (sum(casualties_analysis_data$killed, na.rm = TRUE)
 + sum(casualties_analysis_data$injured, na.rm = TRUE))

# Mean Killed
mean(casualties_analysis_data$killed, na.rm = TRUE)

# Mean Injured
mean(casualties_analysis_data$injured, na.rm = TRUE)

# Mean Casualties
mean(casualties_analysis_data$total_casualties, na.rm = TRUE)

# Distribution of casualties
summary(casualties_analysis_data$total_casualties)

# Distribution of killed across groups
casualties_analysis_data %>%
  summarize(
    min_killed = min(killed, na.rm = TRUE),
    max_killed = max(killed, na.rm = TRUE),
    mean_killed = mean(killed, na.rm = TRUE),
    median_killed = median(killed, na.rm = TRUE)
  )

# Distribution of injured across groups
casualties_analysis_data %>%
  summarize(
    min_injured = min(injured, na.rm = TRUE),
    max_injured = max(injured, na.rm = TRUE),
    mean_injured = mean(injured, na.rm = TRUE),
    median_injured = median(injured, na.rm = TRUE)
  )

## BOMBINGS DATASET ##

# Count Countries
bombings_analysis_data %>%
  count(country)

# Earliest and latest bombing dates
range(bombings_analysis_data$start_date, na.rm = TRUE)

# Bombings per year
bombings_analysis_data %>%
  count(start_year)

# Bombings per month (seasonal analysis)
bombings_analysis_data %>%
  count(start_month)

# Number of bombings by civil defense region
bombings_analysis_data %>%
  count(civil_defence_region)

# Count bombings with missing coordinates
sum(is.na(bombings_analysis_data$lon) | is.na(bombings_analysis_data$lat))

summary(bombings_analysis_data$duration_days)

## COMBINED Summary Statistics ##

# Count incidents per casualty group
incident_counts <- bombings_analysis_data %>%
  group_by(casualty_group) %>%
  summarize(total_incidents = n(), .groups = "drop")


combined_data %>% 
  summarize(avg_incidents_per_group = mean(total_incidents, na.rm = TRUE))



# __________________________________________________________________

first_model <- stan_glm(
  total_casualties ~ time_binary,
  data = combined_data,
  family = gaussian(),  # Change family if appropriate
  prior = normal(0, 2),  # Prior for the slope
  prior_intercept = normal(0, 5),  # Prior for the intercept
  chains = 4,  # Number of chains
  iter = 2000,  # Number of iterations
  seed = 12345  # For reproducibility
)

first_model

# Summarize the model
summary(first_model)

library(ggplot2)

ggplot(combined_data, aes(x = as.factor(time_binary), y = total_casualties)) +
  geom_boxplot() +
  labs(x = "Time (0 = Day, 1 = Night)", y = "Total Casualties") +
  theme_minimal()



# __________________________________________________________________
first_model <-
  stan_glm(
    formula = flying_time ~ length + width,
    data = analysis_data,
    family = gaussian(),
    prior = normal(location = 0, scale = 2.5, autoscale = TRUE),
    prior_intercept = normal(location = 0, scale = 2.5, autoscale = TRUE),
    prior_aux = exponential(rate = 1, autoscale = TRUE),
    seed = 853
  )


#### Save model ####
saveRDS(
  first_model,
  file = "models/first_model.rds"
)


