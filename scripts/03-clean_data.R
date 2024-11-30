#### Preamble ####
# Purpose: Cleans the raw plane data recorded by two observers..... [...UPDATE THIS...]
# Author: Dennis Netchitailo
# Date: November 29 2024
# Contact: dennis.netchitailo@mail.utoronto.ca 
# License: --
# Pre-requisites: 
  # - 02-download_data.R must have been run
  # - The `tidyverse` package must be installed and loaded
  # - The `arrow` package must be installed and loaded
# Any other information needed? [...UPDATE THIS...]

#### Workspace setup ####
library(tidyverse)
#library(arrow)
#### Clean data ####

# Copy and insert the path to the folder
#source_folder = "" #Insert path here
source_folder = "C:/Users/Dennis Netchitailo/Documents/STA304P3"
#combined_path <- file.path(source_folder, "data/01-raw_data/bombings.csv")

load_csv <- function(file_name, base_folder = source_folder) {
  file_path <- file.path(base_folder, file_name)
  data <- read.csv(file_path)
  return(data)
}

#### Load Datasets ####

# Load bombings_data.csv
cleaned_bombings_data <- load_csv("data/01-raw_data/bombings_data.csv")

# Load casualties_data.csv
cleaned_casualties_data <- load_csv("data/01-raw_data/casualties_data.csv")

#### 
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

# Remove whitespace before/after 
cleaned_bombings_data$location <- trimws(cleaned_bombings_data$location)

# Duration of bombing in days 
cleaned_bombings_data$duration_days <- 
  as.Date(cleaned_bombings_data$end_date) - as.Date(cleaned_bombings_data$start_date)

# Year of occurrence
cleaned_bombings_data$start_year <- format(as.Date(cleaned_bombings_data$start_date), "%Y")

# Month of occurrence
cleaned_bombings_data$start_month <- format(as.Date(cleaned_bombings_data$start_date), "%m")

# Dummy for missing coordinates
cleaned_bombings_data$has_missing_coords <- 
  ifelse(is.na(cleaned_bombings_data$lon) | is.na(cleaned_bombings_data$lat), 1, 0)



#### Save data ####
write_csv(cleaned_casualties_data, "data/02-analysis_data/analysis_data_casualties.csv")

## Save as parquet ##


