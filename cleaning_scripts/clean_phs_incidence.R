#
# File: clean_phs_incidence.R
# Date: 2023-10-12
# Author: Lesley Duff
# Description:
#   Clean Public Health Scotland dataset for cancer types over time.
# It contains a breakdown by age in 5 year intervals
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
#incidences_ages_under5_to <- "Under 5"
incidences_ages_under5_to <- "0-4"


incidences_ages_ninety_andover_from <- "90and_over"
#incidences_ages_ninety_andover_to <- "90 and over"
incidences_ages_ninety_andover_to <- "90+"

incidence_rate_age_under5_from <- "_under5"
#incidence_rate_age_under5_to <- "Under 5"
incidence_rate_age_under5_to <- "0-4"

incidence_rate_age_ninety_andover_from <- "90and_over"
#incidence_rate_age_ninety_andover_to <- "90 and over"
incidence_rate_age_ninety_andover_to <- "90+"

incidence_age_range_separator <- "-"


incidence_columns_to_keep <- c(
  "cancer_site", "sex", "year",
  "incidences_age_range", "incidences_age",
  "incidence_rate_age_range", "incidence_rate_age",
  "cancer_site_icd10code"
)

incidence_unfiltered <- incidence_raw %>%
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
      str_replace(incidences_age_range, "to", incidence_age_range_separator), # ?str_detect
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
      str_replace(incidence_rate_age_range, "to", incidence_age_range_separator), # ?str_detect
    .default = incidence_rate_age_range
  )) %>%
  # Choose columns to keep
  select(all_of(incidence_columns_to_keep)) %>% 
  relocate(cancer_site_icd10code, .after = cancer_site)

# We need to our analysis in line with the official statistics
# In particular in the original spreadsheet has the following definition
# 'All cancer types' = 'C00-C97, excluding C44'
# We need to exclude some ICD-10 codes
# What ICD-10 codes are present?
icd10_cancers <- incidence_unfiltered %>%
  select(cancer_site, cancer_site_icd10code) %>%
  group_by(cancer_site_icd10code, cancer_site) %>%
  arrange(cancer_site_icd10code) %>%
  summarise() %>%
  ungroup()

icd10_cancers

# From this list we find that there are records for C44 so we need to remove
# them there are also ones with a 'D' code rather than 'C'

icd10_cancers_filtered <- icd10_cancers %>%
  # For filtering we are looking at things not already categorised as
  # 'All cancer types' ie different cancer types
  # Warning! C44 appear inside the cancer_site_icd10code for
  # 'C00-C97, excluding C44'
  # incidence_cancer_site_icd10code_all
  # We need to keep All cancer types in the dataset!
  filter(
    cancer_site == "All cancer types" |
      (!str_detect(cancer_site_icd10code, "C44") &
         str_detect(cancer_site_icd10code, "C")
      )
  )

# To exclude include Non-melanoma in this dataset include 3 codes:
# Unsure about the ones that *also* contain 'M' codes?
# C44	Non-melanoma skin cancer
# C44, M-8050-8078, M-8083-8084	Squamous cell carcinoma of the skin
# C44, M-8090-8098	Basal cell carcinoma of the skin

# Similarly we have All brain and CNS tumours (malignant and non-malignant)
# C70-C72, C75.1-C75.3, D18.0, D32-D33, D35.2-D35.4, D42-D43, D44.3-D44.5
# As this also contains C code will keep until we uncover a problem doing so

# Our highest C code seem to be 'C92.1-C92.2' which is below C97

# We have rows with non-C codes
# D05 Carcinoma in situ of the breast
# D06	Carcinoma in situ of the cervix uteri
# D18.0, D32-D33, D35.2-D35.4, D42-D43, D44.3-D44.5 Non-malig brain ca (incl pit.gland,cranio.duct,pineal gland)

# Now we have a frame of what to keep remove the rest from our analysis set
incidence_clean <- incidence_unfiltered %>%
  # We want to keep everything in our existing dataset that has a match in
  # the filtered cancers but to lose things that dont match
  #  This seems like an inncer join would be appropriate
  # Keeps observations from incidence_all that have a matching key in
  # icd10_cancers_filtered.
  inner_join(icd10_cancers_filtered)
#rm(incidence_clean)

names(incidence_clean)
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
rm(list = ls(pattern = "icd10_cancers"))
rm(list = ls(pattern = "incidence_"))
rm(list = ls(pattern = "incidences_"))
rm(list = ls(pattern = "phs_"))
