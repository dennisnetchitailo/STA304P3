#### Preamble ####
# Purpose: Tests the variables to ensure the proper type and valid values
# Author: Dennis Netchitailo
# Date: 29 November 2024
# Contact: dennis.netchitailo@mail.utoronto.ca 
# License: --
# Pre-requisites: [...UPDATE THIS...]
  # - 03-clean_data.R must have been run
  # - The `tidyverse` package must be installed and loaded
  # - The `testthat` package must be installed and loaded
  # - The `arrow` package must be installed and loaded
  # - The `here` package must be installed and loaded
# Any other information needed? [...UPDATE THIS...]


#### Workspace setup ####
library(tidyverse)
library(testthat)
library(arrow)
library(here)

# Load data
combined_data <- arrow::read_parquet(here::here("data/02-analysis_data/combined_data.parquet"))

#### Test data ####

#### COMBINED DATASET TESTS ####

# Test casualty-related columns
test_that("All values in 'killed' are greater than or equal to 0", {
  expect_true(all(combined_data$killed >= 0, na.rm = TRUE))
})

test_that("All values in 'injured' are greater than or equal to 0", {
  expect_true(all(combined_data$injured >= 0, na.rm = TRUE))
})

test_that("All values in 'total_casualties' are greater than or equal to 0", {
  expect_true(all(combined_data$total_casualties >= 0, na.rm = TRUE))
})

# Test bombing-related columns
test_that("casualty_group is of class double", {
  expect_type(combined_data$casualty_group, "double")
})

test_that("total_incidents is of class double", {
  expect_type(combined_data$total_incidents, "double")
})

test_that("civil_defense_region is of class character", {
  expect_type(combined_data$civil_defense_region, "character")
})

test_that("country is of class character", {
  expect_type(combined_data$country, "character")
})


test_that("year is of class double", {
  expect_type(combined_data$year, "double")
})

test_that("year values are within the range 1939-1945, ignoring NAs", {
  expect_true(all(combined_data$year >= 1939 & combined_data$year <= 1945, na.rm = TRUE))
})

test_that("month is of class double", {
  expect_type(combined_data$month, "double")
})

test_that("month values are within the range 1-12, ignoring NAs", {
  expect_true(all(combined_data$month >= 1 & combined_data$month <= 12, na.rm = TRUE))
})

test_that("lethality_category contains valid values", {
  # Define the allowed categories
  allowed_categories <- c(NA, "low", "medium", "high")
  
  # Check that all values in lethality_category are in the allowed categories
  expect_true(all(combined_data$lethality_category %in% allowed_categories))
})