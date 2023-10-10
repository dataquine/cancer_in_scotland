#
# File: clean_phs_screening_bowel_cancer.R
# Date: 2023-10-09
# Author: Lesley Duff
# Description:
#   Clean Public Health Scotland datasets for Bowel Cancer Screening
#
# Source:
#   Report data:
#     https://publichealthscotland.scot/media/17689/2023-02-21-bowel-screening-kpi-report.xlsx
#   Background information:
#     https://publichealthscotland.scot/publications/scottish-bowel-screening-programme-statistics/scottish-bowel-screening-programme-statistics-for-the-period-of-invitations-from-may-2020-to-april-2022/

library(dplyr)
library(here)
library(janitor) # For cleaning column names
library(readxl) # For processing Excel spreadsheets
library(readr) # For writing clean CSV
library(tidyr)

source(here::here("R/phs_data_info.R"))

# Uptake (KPI 1)
screening_bowel_uptake_sheet <- "KPI_1"
# screening_bowel_uptake_sheet_skip <- 14
# Table 1, rows 16-20, columns Persons and a column for each Health Board and
# a total for Scotland (column q)
screening_bowel_uptake_range <- "B16:Q20"

# Table 1.1 Overall uptake of screening, by two-year reporting period and sex

# Uptake KP1 ----

# ?read_excel
# Extract Sheet for Uptake
screening_bowel_uptake_raw <- read_excel(
  here::here("data_raw", phs_screening_bowel_raw_filepath),
  sheet = screening_bowel_uptake_sheet,
  range = screening_bowel_uptake_range
) %>%
  # Turn health boards column names into values
  pivot_longer("Ayrshire and Arran":"Scotland",
    names_to = "area",
    values_to = "uptake_pct"
  )

screening_bowel_uptake <- screening_bowel_uptake_raw %>%
  janitor::clean_names() %>%
  drop_na() %>%
  rename(sex = x1)

# View(screening_bowel_uptake)
# screening_bowel_uptake

# Write KP1 data ----
write_csv(
  screening_bowel_uptake,
  here::here(
    "data_clean",
    phs_screening_bowel_uptake_filepath
  )
)

# Write KP1 data for shiny app ----
saveRDS(screening_bowel_uptake, file = here::here(
  phs_screening_bowel_uptake_shiny_filepath
))

rm(screening_bowel_uptake)
