#### Preamble ####
# Purpose: Models the combined_data dataset 
# Author: Dennis Netchitailo
# Date: 30 November 2024
# Contact: dennis.netchitailo@mail.utoronto.ca 
# License: --
# Pre-requisites: 
  # - 03-clean_data.R must have been run
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

source_folder = "" # Insert local path here

load_csv <- function(file_name, base_folder = source_folder) {
  file_path <- file.path(base_folder, file_name)
  data <- read.csv(file_path)
  return(data)
}

rtools_path <- "C:/RBuildTools/4.4"
path_to_usr_bin <- file.path(rtools_path, "usr/bin")
path_to_mingw_bin <- file.path(rtools_path, "mingw_64/bin")
Sys.setenv(PATH = paste(Sys.getenv("PATH"), path_to_usr_bin, path_to_mingw_bin, sep = .Platform$path.sep))
Sys.setenv(R_BUILD_TOOLS_PATH = "C:/RTools")
Sys.which("make")



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

# Create predicted values for the model
combined_data_first_model <- combined_data
combined_data_first_model$predicted <- posterior_predict(first_model, summary = TRUE)

# Plot data and regression line
ggplot(combined_data, aes(x = time_binary, y = total_casualties)) +
  geom_point(alpha = 0.5) +  # Actual data points
  geom_smooth(aes(y = predicted), method = "lm", color = "blue") +  # Regression line
  labs(title = "Regression Model: Total Casualties vs Time",
       x = "Time (0 = Day, 1 = Night)",
       y = "Total Casualties") +
  theme_minimal()




# Boxplot of Data
ggplot(combined_data, aes(x = as.factor(time_binary), y = total_casualties)) +
  geom_boxplot() +
  labs(x = "Time (0 = Day, 1 = Night)", y = "Total Casualties") +
  theme_minimal()

### Models ###

options(mc.cores = parallel::detectCores())
# Fit a Zero-Inflated Negative Binomial model
zero_inflated_model <- brm(
  formula = total_casualties ~ time_binary + (1 | casualty_group),  # Add random effects if needed
  data = combined_data,
  family = zero_inflated_negbinomial(link = "log"),  # Zero-inflated negative binomial
  prior = c(
    prior(normal(0, 5), class = "b"),  # Priors for fixed effects
    prior(cauchy(0, 2), class = "sd")  # Priors for random effects if present
  ),
  chains = 4,
  iter = 2000,
  cores = 4,
  seed = 123
)

# Summarize the zero-inflated model
summary(zero_inflated_model)

# Posterior predictive checks
pp_check(zero_inflated_model)

# Generate predicted values
combined_data$predicted <- predict(zero_inflated_model)[, "Estimate"]

# Plot actual vs. predicted
library(ggplot2)
ggplot(combined_data, aes(x = time_binary, y = total_casualties)) +
  geom_point(alpha = 0.4) +
  geom_line(aes(y = predicted), color = "red", size = 1) +
  labs(x = "Time (0 = Day, 1 = Night)", y = "Total Casualties",
       title = "Zero-Inflated Model: Total Casualties vs. Time") +
  theme_minimal()


refined_model <- brm(
  total_casualties ~ time_binary + severity + population_density + 
    (1 | casualty_group) + (1 | civil_defense_region),
  data = combined_data,
  family = zero_inflated_negbinomial(),
  prior = c(
    prior(normal(0, 1), class = "b"),
    prior(exponential(1), class = "sd")
  ),
  chains = 4,
  cores = parallel::detectCores(),
  iter = 2000
)
## New Model ___________________________________________________________________

## New Model ___________________________________________________________________
## New Model ___________________________________________________________________

## New Model ___________________________________________________________________

## New Model ___________________________________________________________________
library(brms)

# Refined model using additional variables
refined_model <- brm(
  total_casualties ~ 
    start_year + start_month + time_binary + country + civil_defense_region + 
    (1 | casualty_group) + (1 | civil_defense_region),
  data = combined_data,
  family = zero_inflated_negbinomial(),
  prior = c(
    prior(normal(0, 1), class = "b"),
    prior(exponential(1), class = "sd")
  ),
  chains = 4,
  cores = parallel::detectCores(),
  iter = 2000
)

saveRDS(
  refined_model,
  file = "models/refined_model.rds"
)

## New Model ___________________________________________________________________
## New Model ___________________________________________________________________
## New Model ___________________________________________________________________
## New Model ___________________________________________________________________
## New Model ___________________________________________________________________

#Partial Effects
plot(marginal_effects(refined_model), points = TRUE)
# Posterior Predictive Checks:
pp_check(refined_model, ndraws = 100)
#Predicted Casualties by Month and Time:
combined_data$predicted <- posterior_epred(refined_model)

ggplot(combined_data, aes(x = start_month, y = predicted, color = time_binary)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "loess") +
  facet_wrap(~ country) +
  labs(title = "Predicted Casualties by Month and Time",
       x = "Month",
       y = "Predicted Casualties") +
  theme_minimal()



#___________________________________________________________________



#### Save model ####
saveRDS(
  first_model,
  file = "models/first_model.rds"
)


