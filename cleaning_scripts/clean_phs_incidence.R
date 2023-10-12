#
# File: clean_phs_incidence.R
# Date: 2023-10-12
# Author: Lesley Duff
# Description:
#   Clean Public Health Scotland dataset for cancer types over time.
# It contains a breakdown aby age in 5 year intervals
# We have both counts and rates.
# Terminology: The place where a cancer starts in the body
#
# Source:
# 	Incidence at Scotland Level
# https://www.opendata.nhs.scot/dataset/c2c59eb1-3aff-48d2-9e9c-60ca8605431d/resource/72c852b8-ee28-4fd8-84a9-5f415f4bc325/download/opendata_inc9721_scotland.csv

# Background:
# https://www.opendata.nhs.scot/dataset/annual-cancer-incidence
#

library(dplyr)
library(here)
library(janitor)
library(readr)
library(skimr)
library(stringr)
library(tidyr)

source(here::here("R/phs_data_info.R"))
# Locations of Public Health Scotland opendata

# phs_incidence_url
# TODO change local filepath to remote
incidence_raw <- read_csv(
  #  here::here(
  #    "data_raw",
  #    phs_incidence_raw_filepath # local
  #  )
  phs_incidence_url
  # warning this is a remote file URL
) %>%
  janitor::clean_names()


incidence_raw %>% skim()

# Number of rows             3400
# Number of columns          60
# Column type frequency:
#  character                10
#  numeric                  50

glimpse(incidence_raw)

head(incidence_raw)

# Lets turn it into tidy data and move incidences_age and incidence_rate
# columns into long data
# View(incidence_raw)
names(incidence_raw)

column_incidences_age_range <- "incidences_age_range"
column_incidences_age <- "incidences_age"

column_incidence_rate_age_range <- "incidence_rate_age_range"
column_incidence_rate_age <- "incidence_rate_age"

incidences_ages_all_ages_from <- "incidences_all_ages"
incidences_ages_all_ages_to <- "All ages"

incidences_ages_under5_from <- "_under5"
incidences_ages_under5_to <- "Under 5"

incidences_ages_ninety_andover_from <- "90and_over"
incidences_ages_ninety_andover_to <- "90 and over"

incidence_rate_age_under5_from <- "_under5"
incidence_rate_age_under5_to <- "Under 5"

incidence_rate_age_ninety_andover_from <- "90and_over"
incidence_rate_age_ninety_andover_to <- "90 and over"


incidence_columns_to_keep <- c(
  "cancer_site", "sex", "year",
  "incidences_age_range", "incidences_age",
  "incidence_rate_age_range", "incidence_rate_age"
)

incidence_clean <- incidence_raw %>%
  # incidences_age columns
  pivot_longer(
    cols =
      incidences_age_under5:incidences_all_ages,
    names_to = column_incidences_age_range,
    names_prefix = "incidences_age",
    values_to = column_incidences_age
  ) %>%
  mutate(incidences_age_range = case_when(
    incidences_age_range == incidences_ages_all_ages_from ~
      incidences_ages_all_ages_to,
    incidences_age_range == incidences_ages_under5_from ~
      incidences_ages_under5_to,
    incidences_age_range == incidences_ages_ninety_andover_from ~
      incidences_ages_ninety_andover_to,
    str_detect(incidences_age_range, "to") ~
      str_replace(incidences_age_range, "to", " to "), # ?str_detect
    .default = incidences_age_range
  )) %>%
  pivot_longer(
    cols =
      incidence_rate_age_under5:incidence_rate_age90and_over,
    names_to = column_incidence_rate_age_range,
    names_prefix = "incidence_rate_age",
    values_to = column_incidence_rate_age
  ) %>%
  mutate(incidence_rate_age_range = case_when(
    incidence_rate_age_range == incidence_rate_age_under5_from ~
      incidence_rate_age_under5_to,
    incidence_rate_age_range == incidence_rate_age_ninety_andover_from ~
      incidence_rate_age_ninety_andover_to,
    str_detect(incidence_rate_age_range, "to") ~
      str_replace(incidence_rate_age_range, "to", " to "), # ?str_detect
    .default = incidence_rate_age_range
  )) %>%
  # Choose columns to keep
  select(all_of(incidence_columns_to_keep))

# names(incidence_clean)
# View(incidence_clean)

# Write our clean version of death cause data ----
write_csv(
  incidence_clean,
  here::here(
    "data_clean",
    phs_incidence_filepath
  )
)

# Write death data for shiny app ----
saveRDS(incidence_clean, file = here::here(
  phs_incidence_shiny_filepath
))

rm(list = ls(pattern = "column_"))
rm(list = ls(pattern = "incidence_"))
rm(list = ls(pattern = "incidences_"))
rm(list = ls(pattern = "phs_"))
