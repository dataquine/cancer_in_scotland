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

# Download the file from the remote source ----
# Should only need to do this once
# Warning be mindful of not runing script too frequently
download.file(nrs_death_cause_url,
  destfile = here::here(
    "data_raw", nrs_death_cause_raw_filepath
  )
)

# Read raw death data ----
death_cause_raw <- read_excel(
  here::here(
    "data_raw",
    nrs_death_cause_raw_filepath
  ),
  sheet = nrs_death_cause_sheet,
  range = nrs_death_cause_range,
  .name_repair = "unique_quiet"
)

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
  # Weird lines of just a fullstop - not available e.g. covid in 1994
  mutate(rate = na_if(rate, ".")) %>%
  drop_na() %>%
  # We want to create simplified labels
  mutate(
    rate = as.numeric(rate),
    year = as.numeric(year),
    cause_simple = case_when(
      cause == "Cancer (malignant neoplasms: 140-208 /C00-97)" ~ "Cancer",
      cause == "Cerebrovascular disease (stroke:430-438 / I60-69)" ~ "Cerebrovascular disease",
      cause == "Chronic Obstructive Pulmonary Disease NEW DEF(490-492,496 / J40-44)" ~ "Pulmonary (COPD)",
      cause == "Covid-19" ~ "COVID-19",
      cause == "Diseases of the circulatory system(390-459 / I00-I99)" ~ "Circulatory",
      cause == "Diseases of the respiratory system(460-519 / J00-99)" ~ "Respiratory",
      cause == "drug related" ~ "Drug related",
      cause == "Ischaemic (coronary) heart disease(410-414 / I20-25)" ~ "Heart",
      .default = cause
    ), .after = cause
  )

# names(death_cause)
# Write our clean version of death cause data ----
write_csv(
  death_cause,
  here::here(
    "data_clean",
    nrs_death_cause_filepath
  )
)

rm(list = ls(pattern = "nrs_death"))
rm(list = ls(pattern = "cause"))
rm(rate_column, source_nrs)
