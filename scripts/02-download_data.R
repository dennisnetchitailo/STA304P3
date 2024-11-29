#### Preamble ####
# Purpose: Downloads and saves the data from tacookson's GitHub repository.
# Author: Dennis Netchitailo
# Date: 27 November 2024
# Contact: dennis.netchitailo@mail.utoronto.ca
# License: --
# Pre-requisites: Download the `usethis`, `tidyverse`, and `readr` libraries


#### Workspace setup ####

library(usethis)
library(tidyverse)
library(readr)

#### Download data ####

## ___ Method #1 : Automatic* ## ___

# Choose a directory on your computer to be the location of the .zip file
# Insert the path of the directory where you want to save the .zip file
source_folder = "" #Insert path here
combined_path <- file.path(source_folder, "data-master/britain-bombing-ww2")


# Download the .zip file

usethis::use_course(
  url = 'https://github.com/tacookson/data/archive/refs/heads/master.zip',
  destdir = source_folder)

source_csv_bombings <- file.path(combined_path, "bombings.csv")
target_csv_bombings <- read.csv(source_csv_bombings) # Read the CSV file into R

source_csv_casualties <- file.path(combined_path, "casualties.csv")
target_csv_casualties <- read.csv(source_csv_casualties) # Read the CSV file into R


#### Save data ####
write_csv(target_csv_bombings, "data/01-raw_data/bombings_data.csv") 
write_csv(target_csv_casualties, "data/01-raw_data/casualties_data.csv")

## ___ *Method #2 : Manual* ## ___

# Go to the GitHub repository and manually download the .zip file 
# Use the following link: https://github.com/tacookson/data
# Locate and open the .zip file

# (1) Locate and move the "bombings.csv" file to the raw_data folder in the 
# project following the path: data/01-raw_data
# Delete the "bombings_data.csv" file, and rename the "bombings.csv" file to
# "bombings_data.csv"

# (2) Locate and move the "casualties.csv" file to the raw_data folder in the 
# project following the path: data/01-raw_data
# Delete the "casualties_data.csv" file, and rename the "casualties.csv" file to
# "casualties_data.csv"
