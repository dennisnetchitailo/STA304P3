#### Preamble ####
# Purpose: Cleans the raw bombings and casualties data recorded by the Ministry of Home Security
# Author: Dennis Netchitailo
# Date: November 29 2024
# Contact: dennis.netchitailo@mail.utoronto.ca 
# License: --
# Pre-requisites: 
  # - 02-download_data.R must have been run
  # - The `tidyverse` package must be installed and loaded
  # - The `dplyr` package must be installed and loaded
  # - The `arrow` package must be installed and loaded
# Any other information needed? No.

#### Workspace setup ####
library(tidyverse)
library(dplyr)
library(arrow)

#### Clean data ####

# Copy and insert the path to the folder
#source_folder = "" #Insert path here

load_csv <- function(file_name, base_folder = source_folder) {
  file_path <- file.path(base_folder, file_name)
  data <- read.csv(file_path)
  return(data)
}

#### Load Datasets ####

# Load casualties_data.csv
cleaned_casualties_data <- load_csv("data/01-raw_data/casualties_data.csv")

# Load bombings_data.csv
cleaned_bombings_data <- load_csv("data/01-raw_data/bombings_data.csv")


### CASUALTIES Dataset ###

## Add new columns ## 

# Add a new column for the proportion of killed relative to total casualties
cleaned_casualties_data$proportion_killed <- 
  cleaned_casualties_data$killed / cleaned_casualties_data$total_casualties
# Handle cases where total_casualties is zero to avoid division by zero
cleaned_casualties_data$proportion_killed[cleaned_casualties_data$total_casualties == 0] <- NA


### BOMBINGS Dataset ###

# Make bombing_id integer
cleaned_bombings_data$bombing_id <- as.integer(cleaned_bombings_data$bombing_id)

# Remove whitespace before/after 
cleaned_bombings_data$location <- trimws(cleaned_bombings_data$location)

# Year of occurrence
cleaned_bombings_data$start_year <- format(as.Date(cleaned_bombings_data$start_date), "%Y")

# Month of occurrence
cleaned_bombings_data$start_month <- format(as.Date(cleaned_bombings_data$start_date), "%m")

# Drop additional notes column
cleaned_bombings_data <- cleaned_bombings_data %>% select(-additional_notes)

# Drop start_date
cleaned_bombings_data <- cleaned_bombings_data %>% select(-start_date)

#### Save data ####
write_csv(cleaned_casualties_data, "data/02-analysis_data/analysis_data_casualties.csv")
write_csv(cleaned_bombings_data, "data/02-analysis_data/analysis_data_bombings.csv")

##### COMBINED DATASET #####

#### Load Dataset ####

# Load casualties_data.csv
casualties_data <- load_csv("data/02-analysis_data/analysis_data_casualties.csv")

# Load bombings_data.csv
bombings_data <- load_csv("data/02-analysis_data/analysis_data_bombings.csv")

## Combine ## 

aggregated_bombings <- bombings_data %>%
  group_by(casualty_group) %>%
  summarize(
    total_incidents = n(),
    civil_defense_region = first(civil_defence_region),
    country = first(country),
    time = first(time),
    start_year = first(start_year),
    start_month = first(start_month),
        .groups = "drop"
  )

combined_data <- aggregated_bombings %>%
  left_join(casualties_data, by = "casualty_group")

# Convert casualty_group to integer type
combined_data <- combined_data %>%
  mutate(casualty_group = as.integer(casualty_group))


combined_data <- combined_data %>%
  mutate(
    proportion_killed = ifelse(total_casualties > 0, killed / total_casualties, NA)
  )

# Remove rows with invalid proportions
cleaned_data <- combined_data %>%
  filter(is.na(proportion_killed) | (proportion_killed >= 0 & proportion_killed <= 1))
combined_data <- cleaned_data

# Dummy variable for Time
cleaned_data <- combined_data %>%
  mutate(
    # Standardize the time column
    time = case_when(
      str_to_lower(time) == "day" ~ "Day",
      str_to_lower(time) == "night" ~ "Night",
      TRUE ~ "Unspecified"  # Handle unspecified or other unexpected values
    ),
    # Create time_binary: 0 = Day, 1 = Night, NA for Unspecified
    time_binary = ifelse(time == "Night", 1,
                         ifelse(time == "Day", 0, NA))
  )

combined_data <- cleaned_data

# Remove rows with NA except for 'proportion_killed'
cleaned_data <- combined_data %>%
  filter(if_all(-proportion_killed, ~ !is.na(.)))


combined_data <- cleaned_data

# Define thresholds for lethality categories
combined_data <- combined_data %>%
  mutate(lethality_category = case_when(
    proportion_killed < 0.33 ~ "low",
    proportion_killed >= 0.33 & proportion_killed < 0.66 ~ "medium",
    proportion_killed >= 0.66 ~ "high",
    TRUE ~ "None"  # Handle NAs
  ))

# Convert to factor for modeling
combined_data$lethality_category <- factor(combined_data$lethality_category, 
                                           levels = c("low", "medium", "high"))

# Remove unneeded column proportion_killed
combined_data <- combined_data %>%
  select(-proportion_killed)

# Remove unneeded column time
combined_data <- combined_data %>%
  select(-time)

# Rename columns start_year and start_month
combined_data <- combined_data %>%
  rename(
    year = start_year,
    month = start_month
  )


## Save Data ##
write_csv(combined_data, "data/02-analysis_data/combined_data.csv")
message("File successfully written!")

## Save as parquet ##
# Load data
cleaned_casualties_data <- read_csv("data/02-analysis_data/analysis_data_casualties.csv")
cleaned_bombings_data <- read_csv("data/02-analysis_data/analysis_data_bombings.csv")
combined_data <- read_csv("data/02-analysis_data/combined_data.csv")


# Save as Parquet
write_parquet(cleaned_casualties_data, "data/02-analysis_data/analysis_data_casualties.parquet")
write_parquet(cleaned_bombings_data, "data/02-analysis_data/analysis_data_bombings.parquet")
write_parquet(combined_data, "data/02-analysis_data/combined_data.parquet")



