#### Preamble ####
# Purpose: Cleans the raw plane data recorded by two observers..... [...UPDATE THIS...]
# Author: Dennis Netchitailo
# Date: November 29, 2024
# Contact: dennis.netchitailo@mail.utoronto.ca 
# License: --
# Pre-requisites: 
  # - 02-download_data.R must have been run
  # - The `tidyverse` package must be installed and loaded
  # - The `arrow` package must be installed and loaded
# Any other information needed? [...UPDATE THIS...]

#### Workspace setup ####
library(tidyverse)
library(arrow)
#### Clean data ####
#source_folder = "" #Insert path here
source_folder = "C:/Users/Dennis Netchitailo/Documents/STA304P3"
combined_path <- file.path(source_folder, "data/01-raw_data/bombings_data.csv")



csv_data <- read.csv("/data/01-raw_data/bombings_data.csv")


raw_data <- read_csv("inputs/data/plane_data.csv")

#write_parquet(data, "path/to/save/cleaned_data.parquet")





cleaned_data <-
  raw_data |>
  janitor::clean_names() |>
  select(wing_width_mm, wing_length_mm, flying_time_sec_first_timer) |>
  filter(wing_width_mm != "caw") |>
  mutate(
    flying_time_sec_first_timer = if_else(flying_time_sec_first_timer == "1,35",
                                   "1.35",
                                   flying_time_sec_first_timer)
  ) |>
  mutate(wing_width_mm = if_else(wing_width_mm == "490",
                                 "49",
                                 wing_width_mm)) |>
  mutate(wing_width_mm = if_else(wing_width_mm == "6",
                                 "60",
                                 wing_width_mm)) |>
  mutate(
    wing_width_mm = as.numeric(wing_width_mm),
    wing_length_mm = as.numeric(wing_length_mm),
    flying_time_sec_first_timer = as.numeric(flying_time_sec_first_timer)
  ) |>
  rename(flying_time = flying_time_sec_first_timer,
         width = wing_width_mm,
         length = wing_length_mm
         ) |> 
  tidyr::drop_na()

#### Save data ####
write_csv(cleaned_data, "outputs/data/analysis_data.csv")
