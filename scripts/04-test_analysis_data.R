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
# Any other information needed? [...UPDATE THIS...]


#### Workspace setup ####
library(tidyverse)
library(testthat)

# Load data
cleaned_data_bombings <- arrow::read_parquet(here::here("data/02-analysis_data/analysis_data_bombings.parquet"))
cleaned_data_casualties <- arrow::read_parquet(here::here("data/02-analysis_data/analysis_data_casualties.parquet"))

#data_bombings <- read_csv("data/02-analysis_data/analysis_data_bombings.csv")
#data_casualties <- read_csv("data/02-analysis_data/analysis_data_casualties.csv")

#### Test data ####

# Ensure the data is loaded correctly
#data_bombings <- read_csv("data/02-analysis_data/analysis_data_bombings.csv")
#data_casualties <- read_csv("data/02-analysis_data/analysis_data_casualties.csv")

# Convert necessary columns to the expected types (if not already)
#data_bombings$start_date <- as.Date(data_bombings$start_date, format="%Y-%m-%d")
#data_bombings$end_date <- as.Date(data_bombings$end_date, format="%Y-%m-%d")

#### BOMBING DATASET TESTS ####

test_that("bombing_id is of class integer", {
  expect_type(data_bombings$bombing_id, "integer")
})

test_that("civil_defense_region is of class character", {
  expect_type(data_bombings$civil_defense_region, "character")
})

test_that("country is of class character", {
  expect_type(data_bombings$country, "character")
})

test_that("location is of class character", {
  expect_type(data_bombings$location, "character")
})

test_that("lon is of class numeric", {
  expect_type(data_bombings$lon, "numeric")
})

test_that("lat is of class numeric", {
  expect_type(data_bombings$lat, "numeric")
})

test_that("start_date is of class Date", {
  expect_s3_class(data_bombings$start_date, "Date")
})

test_that("end_date is of class Date", {
  expect_s3_class(data_bombings$end_date, "Date")
})

test_that("time is of class character", {
  expect_type(data_bombings$time, "character")
})

test_that("casualty_group is of class integer", {
  expect_type(data_bombings$casualty_group, "integer")
})

test_that("duration_days is of class integer", {
  expect_type(data_bombings$duration_days, "integer")
})

test_that("start_year is of class integer", {
  expect_type(data_bombings$start_year, "integer")
})

test_that("start_year values are within the range 1939-1944", {
  expect_true(all(data_bombings$start_year >= 1939 & data_bombings$start_year <= 1944))
})

test_that("start_month is of class integer", {
  expect_type(data_bombings$start_month, "integer")
})

test_that("start_month values are within the range 1-12", {
  expect_true(all(data_bombings$start_month >= 1 & data_bombings$start_month <= 12))
})

test_that("has_missing_coords is of class integer", {
  expect_type(data_bombings$has_missing_coords, "integer")
})

test_that("time_unknown is of class integer", {
  expect_type(data_bombings$time_unknown, "integer")
})
