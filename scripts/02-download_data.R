#### Preamble ####
# Purpose: Downloads and saves the data from tacookson's GitHub repository.
# Author: Dennis Netchitailo
# Date: 27 November 2024
# Contact: dennis.netchitailo@mail.utoronto.ca
# License: --
# Pre-requisites: Download the "usethis" and "readr" libraries
# Any other information needed? [...UPDATE THIS...]


#### Workspace setup ####

library(usethis)
library(tidyverse)
library(readr)

#### Download data ####

## ___ *Method #1 : Manual* ## ___

# Go to the GitHub repository and manually download the .zip file 
# Use the following link: https://github.com/tacookson/data
# Location and open the .zip file

# (1) Locate and move the "bombings.csv" file to the raw_data folder in the 
# project following the path: data/01-raw_data

# (2) Locate and move the "casualties.csv" file to the raw_data folder in the 
# project following the path: data/01-raw_data

## ___ Method #2 : Automatic* ## ___

# Choose a directory on your computer to be the location of the .zip file
# Insert the path of the directory where you want to save the .zip file
#source_folder = ""
source_folder = "C:/Users/Dennis Netchitailo/Downloads/data-master/britain-bombing-ww2"


# Download the .zip file

usethis::use_course(
  url = 'https://github.com/tacookson/data/archive/refs/heads/master.zip',
  destdir = source_folder)

source_csv_bombings <- file.path(source_folder, "bombings.csv")
target_csv_bombings <- read.csv(source_csv_bombings) # Read the CSV file into R

source_csv_casualties <- file.path(source_folder, "casualties.csv")
target_csv_casualties <- read.csv(source_csv_casualties) # Read the CSV file into R


#### Save data ####
write_csv(target_csv_bombings, "data/01-raw_data/bombings_data.csv") 
write_csv(target_csv_casualties, "data/01-raw_data/casualties_data.csv")
         
