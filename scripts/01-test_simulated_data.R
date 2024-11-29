#### Preamble ####
# Purpose: Tests the structure and validity of the datasets about the German 
# bombing of England during the Second World War. 
# Author: Dennis Netchitailo
# Date: 27 November 2024
# Contact: dennis.netchitailo@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
  # - The `tidyverse` package must be installed and loaded
  # - 00-simulate_data.R must have been run
# Any other information needed? Make sure you are in the `starter_folder` rproj


#### Workspace setup ####
library(tidyverse)

analysis_data <- read_csv("data/00-simulated_data/simulated_data.csv")

# Test if the data was successfully loaded
if (exists("analysis_data")) {
  message("Test Passed: The dataset was successfully loaded.")
} else {
  stop("Test Failed: The dataset could not be loaded.")
}


#### Test data ####



# Check if the dataset has 32514 rows
if (nrow(analysis_data) == 32514) {
  message("Test Passed: The dataset has 32514 rows.")
} else {
  stop("Test Failed: The dataset does not have 32514 rows.")
}

# Check if the dataset has 4 columns
if (ncol(analysis_data) == 4) {
  message("Test Passed: The dataset has 4 columns.")
} else {
  stop("Test Failed: The dataset does not have 4 columns.")
}

# Check if the 'location' column contains only valid locations of England's cities
valid_cities <- c("London", "Manchester", "Liverpool", "Birmingham", "Coventry")

if (all(analysis_data$location %in% valid_cities)) {
  message("Test Passed: The 'location' column contains only valid English city names.")
} else {
  stop("Test Failed: The 'location' column contains invalid city names.")
}

# Check no negative casualties figures
all(analysis_data$casualties >= 0) == TRUE

# Check date range
all(simulated_bombing_data$date >= as.Date("1939-09-01") & 
      simulated_bombing_data$date <= as.Date("1940-05-10")) == TRUE

# Check if there are any missing values in the dataset
if (all(!is.na(analysis_data))) {
  message("Test Passed: The dataset contains no missing values.")
} else {
  stop("Test Failed: The dataset contains missing values.")
}

# Check if there are no empty strings in 'incident_id', 'location', 
# and 'casualties' columns
if (all(analysis_data$incident_id != "" & analysis_data$location != "" &
        analysis_data$casualties != "")) {
  message("Test Passed: There are no empty strings in 'incident_id', 
          'location' or 'casualties' .")
} else {
  stop("Test Failed: There are empty strings in one or more columns.")
}
#analysis_data$incident_id != "" & analysis_data$date != "" &

# Define expected date range
start_date <- as.Date("1939-09-01")
end_date <- as.Date("1940-05-10")
# Check if all dates are within range
if (all(analysis_data$date >= start_date & analysis_data$date <= end_date)) {
  message("Test Passed: All dates are within the expected range.")
} else {
  stop("Test Failed: Some dates fall outside the expected range.")
}

# Check if the 'party' column has at least two unique values
if (n_distinct(analysis_data$location) >= 2) {
  message("Test Passed: The 'location' column contains at least two unique values.")
} else {
  stop("Test Failed: The 'location' column contains less than two unique values.")
}

# Check for IQR outliers
outliers <- analysis_data %>%
  filter(casualties > 17) 
if (nrow(outliers) == 0) {
  message("Test Passed: No extreme outliers in 'casualties'.")
} else {
  warning("Outliers detected in 'casualties':", nrow(outliers))
}

# Check all incident IDs are unique
if (n_distinct(analysis_data$incident_id) == nrow(analysis_data)) {
  message("Test Passed: All 'incident_id' values are unique.")
} else {
  stop("Test Failed: Duplicate 'incident_id' values found.")
}

# Check no missing date values
if (all(!is.na(analysis_data$date))) {
  message("Test Passed: No missing dates in the dataset.")
} else {
  stop("Test Failed: Missing dates detected in the dataset.")
}

