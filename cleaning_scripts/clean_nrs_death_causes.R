#
# File: clean_nrs_death_causes.R
# Date: 2023-10-09
# Author: Lesley Duff
# Description:
#   Clean National Records Scotland datasets for causes of death
#
# Source:
# 	Table 1: All ages age-standardised death rates for all causes and certain selected causes, Scotland, 1994 to 2022
# https://www.nrscotland.gov.uk/files//statistics/age-standardised-death-rates-esp/2022/age-standard-death-rates-22-tab1.zip
# Table file: age-standard-death-rates-22-data-for-chart.csv

# Background:
# https://www.nrscotland.gov.uk/statistics-and-data/statistics/statistics-by-theme/vital-events/deaths/age-standardised-death-rates-calculated-using-the-esp

library(dplyr)
#library(ggplot2)
library(here)
library(janitor)
library(lubridate)
library(readxl) # For processing Excel spreadsheets
library(readr)
library(tidyr)
library(tidyverse)

source(here::here("R/nrs_data_info.R"))

cause_column <- "cause"
cause_simple_column <- "cause_simple"
rate_column <- "rate"

death_cause_raw <- read_excel(
  here::here(
    "data_raw",
    nrs_death_cause_raw_filepath
  ),
  sheet = nrs_death_cause_sheet,
  range = nrs_death_cause_range,
  .name_repair = "unique_quiet"
)

#cause_labels <- death_cause_raw[1]
#rate_labels <- death_cause_raw[2]

death_cause <- death_cause_raw %>%
  pivot_longer(
    cols = 2:last_col(),
    names_to = cause_column,
    values_to = rate_column
  ) %>%
  janitor::clean_names() %>%
  # remove first row
  .[-1, ] %>%
  filter(rate != rate_column) %>%
  rename(year = x1) %>%
  mutate(rate = as.numeric(rate),
         year = as.numeric(year)) 

#names(death_cause)

#print(n = 5, death_cause)
#all_causes <- get_death_all_causes(death_cause)
#selected_causes <- get_death_selected_causes(death_cause)
#plot_causes(all_causes)
#plot_causes(selected_causes)
#rm(selected_causes)

write_csv(
  death_cause,
  here::here(
    "data_clean",
    nrs_death_cause_filepath
  )
)

# Write death data for shiny app ----
saveRDS(death_cause, file = here::here(
  nrs_death_cause_shiny_filepath
))

rm(death_cause)


