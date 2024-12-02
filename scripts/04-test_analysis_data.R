#### Preamble ####
# Purpose: Tests... [...UPDATE THIS...]
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

test_that("start_date is of class double", {
  expect_type(combined_data$start_date, "double")
})

test_that("end_date is of class Date", {
  expect_s3_class(combined_data$end_date, "Date")
})

test_that("time is of class character", {
  expect_type(combined_data$time, "character")
})

test_that("duration_days is of class double", {
  expect_type(combined_data$duration_days, "double")
})

test_that("start_year is of class double", {
  expect_type(combined_data$start_year, "double")
})

test_that("start_year values are within the range 1939-1945, ignoring NAs", {
  expect_true(all(combined_data$start_year >= 1939 & combined_data$start_year <= 1945, na.rm = TRUE))
})

test_that("start_month is of class double", {
  expect_type(combined_data$start_month, "double")
})

test_that("start_month values are within the range 1-12, ignoring NAs", {
  expect_true(all(combined_data$start_month >= 1 & combined_data$start_month <= 12, na.rm = TRUE))
})

test_that("time_unknown is of class double", {
  expect_type(combined_data$time_unknown, "double")
})

#### Additional Tests ####

# # Test proportion_killed is between 0 and 1
# test_that("proportion_killed values are between 0 and 1, ignoring NAs", {
#   expect_true(all(combined_data$proportion_killed >= 0 & combined_data$proportion_killed <= 1, na.rm = TRUE))
# })

test_that("proportion_killed values are between 0 and 1, ignoring NAs", {
  # Ensure the proportion is within range for non-NA values
  expect_true(all(combined_data$proportion_killed >= 0 & combined_data$proportion_killed <= 1, na.rm = TRUE))
})


# Test presence of boolean flags
test_that("has_killed is of class double", {
  expect_type(combined_data$has_killed, "double")
})

test_that("has_injured is of class double", {
  expect_type(combined_data$has_injured, "double")
})

test_that("has_casualties is of class double", {
  expect_type(combined_data$has_casualties, "double")
})
