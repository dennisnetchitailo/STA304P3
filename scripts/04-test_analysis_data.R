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
cleaned_data_bombings <- arrow::read_parquet(here::here("data/02-analysis_data/analysis_data_bombings.parquet"))
cleaned_data_casualties <- arrow::read_parquet(here::here("data/02-analysis_data/analysis_data_casualties.parquet"))

#### Test data ####

#### BOMBING DATASET TESTS ####

test_that("bombing_id is of class double", {
  expect_type(cleaned_data_bombings$bombing_id, "double")
})

test_that("civil_defense_region is of class character", {
  expect_type(cleaned_data_bombings$civil_defence_region, "character")
})

test_that("country is of class character", {
  expect_type(cleaned_data_bombings$country, "character")
})

test_that("location is of class character", {
  expect_type(cleaned_data_bombings$location, "character")
})

test_that("lon is of class double", {
  expect_type(cleaned_data_bombings$lon, "double")
})

test_that("lat is of class double", {
  expect_type(cleaned_data_bombings$lat, "double")
})

test_that("start_date is of class Date", {
  expect_s3_class(cleaned_data_bombings$start_date, "Date")
})

test_that("end_date is of class Date", {
  expect_s3_class(cleaned_data_bombings$end_date, "Date")
})

test_that("time is of class character", {
  expect_type(cleaned_data_bombings$time, "character")
})

test_that("casualty_group is of class double", {
  expect_type(cleaned_data_bombings$casualty_group, "double")
})

test_that("duration_days is of class double", {
  expect_type(cleaned_data_bombings$duration_days, "double")
})

test_that("start_year is of class double", {
  expect_type(cleaned_data_bombings$start_year, "double")
})

test_that("start_year values are within the range 1939-1945, ignoring NAs", {
  expect_true(all(cleaned_data_bombings$start_year >= 1939 & cleaned_data_bombings$start_year <= 1945, na.rm = TRUE))
})


test_that("start_month is of class double", {
  expect_type(cleaned_data_bombings$start_month, "double")
})

test_that("start_month values are within the range 1-12, ignoring NAs", {
  expect_true(all(cleaned_data_bombings$start_month >= 1 & cleaned_data_bombings$start_month <= 12, na.rm = TRUE))
})

test_that("has_missing_coords is of class double", {
  expect_type(cleaned_data_bombings$has_missing_coords, "double")
})

test_that("time_unknown is of class double", {
  expect_type(cleaned_data_bombings$time_unknown, "double")
})

#### BOMBING DATASET TESTS ####

# Values >0 for killed
test_that("All values in 'killed' are greater than 0", {
  expect_true(all(cleaned_data_casualties$killed >= 0, na.rm = TRUE))
})

# Values >0 for injured
test_that("All values in 'injured' are greater than 0", {
  expect_true(all(cleaned_data_casualties$injured >= 0, na.rm = TRUE))
})

# Values >0 for casualties
test_that("All values in 'total_casualties' are greater than 0", {
  expect_true(all(cleaned_data_casualties$total_casualties >= 0, na.rm = TRUE))
})
