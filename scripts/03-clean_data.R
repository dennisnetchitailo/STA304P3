#### Preamble ####
# Purpose: Cleans the raw plane data recorded by two observers..... [...UPDATE THIS...]
# Author: Dennis Netchitailo
# Date: November 29 2024
# Contact: dennis.netchitailo@mail.utoronto.ca 
# License: --
# Pre-requisites: 
  # - 02-download_data.R must have been run
  # - The `tidyverse` package must be installed and loaded
  # - The `dplyr` package must be installed and loaded
  # - The `arrow` package must be installed and loaded
# Any other information needed? [...UPDATE THIS...]

#### Workspace setup ####
library(tidyverse)
library(dplyr)
library(arrow)

#### Clean data ####

# Copy and insert the path to the folder
#source_folder = "" #Insert path here
source_folder = "C:/Users/Dennis Netchitailo/Documents/STA304P3"

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

# Create dummy variable for Killed
cleaned_casualties_data$has_killed <- ifelse(cleaned_casualties_data$killed > 0, 1, 0)

# Create dummy variable for Injured
cleaned_casualties_data$has_injured <- ifelse(cleaned_casualties_data$injured > 0, 1, 0)

# Create dummy variable for Casualties
cleaned_casualties_data$has_casualties <- ifelse(cleaned_casualties_data$total_casualties > 0, 1, 0)

### BOMBINGS Dataset ###

# Make bombing_id integer
cleaned_bombings_data$bombing_id <- as.integer(cleaned_bombings_data$bombing_id)

# Remove whitespace before/after 
cleaned_bombings_data$location <- trimws(cleaned_bombings_data$location)

# Duration of bombing in days 
cleaned_bombings_data$duration_days <- 
  as.Date(cleaned_bombings_data$end_date) - as.Date(cleaned_bombings_data$start_date) + 1

# Year of occurrence
cleaned_bombings_data$start_year <- format(as.Date(cleaned_bombings_data$start_date), "%Y")

# Month of occurrence
cleaned_bombings_data$start_month <- format(as.Date(cleaned_bombings_data$start_date), "%m")

# Dummy for missing coordinates
cleaned_bombings_data$has_missing_coords <- 
  ifelse(is.na(cleaned_bombings_data$lon) | is.na(cleaned_bombings_data$lat), 1, 0)

# Dummy for unknown time
cleaned_bombings_data$time_unknown <- ifelse(is.na(cleaned_bombings_data$time), 1, 0)

# Drop additional notes column
cleaned_bombings_data <- cleaned_bombings_data %>% select(-additional_notes)

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
    start_date = first(start_date),
    end_date = first(end_date),
    time = first(time),
    duration_days = first(duration_days),
    start_year = first(start_year),
    start_month = first(start_month),
    time_unknown = first(time_unknown),
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

# Remove rows with NA except for 'proportion_killed'
cleaned_data <- combined_data %>%
  filter(if_all(everything(), ~ !is.na(.) | cur_column() == "proportion_killed"))

# Verify the result
summary(cleaned_data)



# View the cleaned dataset
head(cleaned_data)

combined_data <- cleaned_data

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



