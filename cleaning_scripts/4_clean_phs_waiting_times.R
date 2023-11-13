#
# File: clean_phs_waiting_times.R
# Date: 2023-10-18
# Author: Lesley Duff
# Description:
#   Clean Public Health Scotland dataset for cancer waiting times

# Terminology: The place where a cancer starts in the body
#
# Source:
# https://www.opendata.nhs.scot/dataset/11c61a02-205b-43f6-9297-243679103617/resource/58527343-a930-4058-bf9e-3c6e5cb04010/download/cwt_31_day_standard.csv
# https://www.opendata.nhs.scot/dataset/11c61a02-205b-43f6-9297-243679103617/resource/23b3bbf7-7a37-4f86-974b-6360d6748e08/download/cwt_62_day_standard.csv
#
# Background:
# Cancer Wait Time - 31 Day Standard
# https://www.opendata.nhs.scot/dataset/cancer-waiting-times/resource/58527343-a930-4058-bf9e-3c6e5cb04010
# 31 day waiting standard split by health board of treatment and health board of
# residence as well as cancer type.
# https://www.opendata.nhs.scot/dataset/cancer-waiting-times/resource/23b3bbf7-7a37-4f86-974b-6360d6748e08
# The 31 day standard is measured against the health board of first treatment (HBT)
# 62 day waiting standard split by health board of treatment and health board of residence as well as cancer type
# The 62 day standard is measured against the health board of receipt of referral (HB)

# Load required libraries ----
library(here)
library(janitor)
library(skimr)
library(stringr)
library(tidyverse)

# Bring in helper information about Public Health Scotland data
source(here::here("R/phs_data_info.R"))
# Locations of Public Health Scotland opendata

# Read in raw data ----
# Waiting Times for 31 Days Standard
waiting_times_31_days_raw <- read_csv(
  #    here::here(
  #      "data_raw",
  #      phs_waiting_times_31_days_raw_filepath # local
  #    )
  phs_waiting_times_31_days_url
  # warning this is a remote file URL
)

# Save a copy of the raw waiting_times_31_days data ----
# We don't use this but good to have a backup copy in case of remote failures
write_csv(
  waiting_times_31_days_raw,
  here::here(
    "data_raw",
    phs_waiting_times_31_days_raw_filepath
  )
)

# names(waiting_times_31_days_raw)

waiting_times_62_days_raw <- read_csv(
  #    here::here(
  #      "data_raw",
  #      phs_waiting_times_62_days_raw_filepath # local
  #    )
  phs_waiting_times_62_days_url
  # warning this is a remote file URL
)

# Save a copy of the raw waiting_times_62_days data ----
# We don't use this but good to have a backup copy in case of remote failures
write_csv(
  waiting_times_62_days_raw,
  here::here(
    "data_raw",
    phs_waiting_times_62_days_raw_filepath
  )
)

# Examine raw data ----
# 31 day waiting standard split by health board of treatment and health board
# of residence as well as cancer type.
#
# The 31 day standard is measured against the health board of first treatment (HBT)

# Examine 31 day dataset
# dim(waiting_times_31_days_raw)
# # 19287    10
#
# # Examine data
# glimpse(waiting_times_31_days_raw)
# skimr::skim(waiting_times_31_days_raw)

# Lots of NAs but only in description QF fields not values

# Dates are in format "2012Q1", "2012Q1"
# HB = Health Board by code : "S08000015" etc.
# HBT = Health Board of treatment
# CancerType: "Breast", "Cervical"
# NumberOfEligibleReferrals31DayStandard = <dbl> 78, 4, 53
# NumberOfEligibleReferralsTreatedWithin31Days = <dbl> 78, 4, 53

# tidy column names
waiting_times_31_days_raw <- waiting_times_31_days_raw %>%
  janitor::clean_names() %>%
  filter(is.na(hbtqf)) # Quality filter
#  filter(!str_detect(hbtqf, "d"))

# View(waiting_times_31_days_raw)
# waiting_times_31_days_raw %>%
#  distinct(hbtqf)
# stop()
# names(waiting_times_31_days_raw)
# View(waiting_times_31_days_raw)

# [1] "quarter"
#  [2] "hb"
#  [3] "hbt"
#  [4] "hbtqf"
#  [5] "cancer_type"
#  [6] "cancer_type_qf"
#  [7] "number_of_eligible_referrals31day_standard"
#  [8] "number_of_eligible_referrals31day_standard_qf"
#  [9] "number_of_eligible_referrals_treated_within31days"
# [10] "number_of_eligible_referrals_treated_within31days_qf"

# Examine 62 day datsset
# 62 day waiting standard split by health board of treatment and health
# board of residence as well as cancer type
# dim(waiting_times_62_days_raw)
# 17362    10

# Examine data
# glimpse(waiting_times_62_days_raw)
# skimr::skim(waiting_times_62_days_raw)

# Lots of NAs but only in description QF fields not values

# Dates are in format "2012Q1", "2012Q1"
# HB = Health Board by code : "S08000015" etc.
# The 62 day standard is measured against the health board of receipt of referral (HB)

# HBT = Health Board of treatment
# CancerType: "Breast", "Cervical"
# NumberOfEligibleReferrals62DayStandard = <dbl> 52, 2, 31
# NumberOfEligibleReferralsTreatedWithin62Days = dbl> 52, 2, 29

# tidy column names
waiting_times_62_days_raw <- waiting_times_62_days_raw %>%
  janitor::clean_names()
# names(waiting_times_62_days_raw)
# View(waiting_times_62_days_raw)
#  [1] "quarter"
#  [2] "hb"
#  [3] "hbqf"
#  [4] "hbt"
#  [5] "cancer_type"
#  [6] "cancer_type_qf"
#  [7] "number_of_eligible_referrals62day_standard"
#  [8] "number_of_eligible_referrals62day_standard_qf"
#  [9] "number_of_eligible_referrals_treated_within62days"
# [10] "number_of_eligible_referrals_treated_within62days_qf"

# Lets join these two datasets and rename some columns
# We want to keep everything in the 31day data and any matches on 62 days by
# quarter
# This seems like a 'left' join

# `left_join(table1, table2, by = "matching_column_name")`
# 19287 + 17362
#  left_join(movies, by = c("movie_id" = "id")) %>%
waiting_times_raw <- waiting_times_31_days_raw %>%
  left_join(waiting_times_62_days_raw)
# View(waiting_times_raw)
# Examine joined table
# dim (waiting_times_raw)
# names(waiting_times_raw)
#  [1] "quarter"
#  [2] "hb"
#  [3] "hbt"
#  [4] "hbtqf"
#  [5] "cancer_type"
#  [6] "cancer_type_qf"
#  [7] "number_of_eligible_referrals31day_standard"
#  [8] "number_of_eligible_referrals31day_standard_qf"
#  [9] "number_of_eligible_referrals_treated_within31days"
# [10] "number_of_eligible_referrals_treated_within31days_qf"
# [11] "hbqf"
# [12] "number_of_eligible_referrals62day_standard"
# [13] "number_of_eligible_referrals62day_standard_qf"
# [14] "number_of_eligible_referrals_treated_within62days"
# [15] "number_of_eligible_referrals_treated_within62days_qf"
# names(waiting_times_raw)

# Tidy the columns and shorten column names
waiting_times_clean <- waiting_times_raw %>%
  # Add a new column for calculations as time S3: yearqtr>
  mutate(quarter_time = zoo::as.yearqtr(quarter), .after = quarter) %>%
  pivot_longer(
    cols = c(
      "number_of_eligible_referrals31day_standard",
      "number_of_eligible_referrals62day_standard"
    ),
    names_to = "referrals_standard",
    names_prefix = "number_of_eligible_referrals",
    values_to = "referrals"
  ) %>%
  pivot_longer(
    cols = c(
      "number_of_eligible_referrals31day_standard_qf",
      "number_of_eligible_referrals62day_standard_qf"
    ),
    names_to = "referrals_standard_qf",
    names_prefix = "number_of_eligible_referrals",
    values_to = "referrals_standard_qf_values"
  ) %>%
  pivot_longer(
    cols = c(
      "number_of_eligible_referrals_treated_within31days",
      "number_of_eligible_referrals_treated_within62days"
    ),
    names_to = "referrals_treated_standard",
    names_prefix = "number_of_eligible_referrals_treated_",
    values_to = "referrals_treated"
  ) %>%
  pivot_longer(
    cols = c(
      "number_of_eligible_referrals_treated_within31days_qf",
      "number_of_eligible_referrals_treated_within62days_qf"
    ),
    names_to = "referrals_treated_qf",
    names_prefix = "number_of_eligible_referrals_treated_",
    values_to = "referrals_treated_qf_values"
  ) %>%
  # Remove rows where no data for a particular cancer/health_board
  filter(!is.na(referrals)) %>%
  filter(!is.na(referrals_treated)) %>%
  # Make sure ww have minimum rows needed
  # Take only full 31 day or 62 day observations
  # referrals_standard = 31day_standard
  # referrals_standard_qf = 31day_standard_qf
  # referrals_treated_standard = within31days
  # referrals_treated_qf = within31days_qf
  #
  # referrals_standard = 62day_standard
  # referrals_standard_qf = 62day_standard_qf
  # referrals_treated_standard = within62days
  # referrals_treated_qf = within62days_qf
  filter((referrals_standard == "31day_standard" &
    referrals_standard_qf == "31day_standard_qf" &
    referrals_treated_standard == "within31days" &
    referrals_treated_qf == "within31days_qf") |
    (referrals_standard == "62day_standard" &
      referrals_standard_qf == "62day_standard_qf" &
      referrals_treated_standard == "within62days" &
      referrals_treated_qf == "within62days_qf"))

# names(waiting_times_clean)

# Write out clean dataset. ----
# NB the two original files have now been combined

# Write our clean version of waiting time data ----
write_csv(
  waiting_times_clean,
  here::here(
    "data_clean",
    phs_waiting_times_days_filepath
  )
)

# Clean up environment ----
rm(list = ls(pattern = "waiting_times_"))
rm(list = ls(pattern = "phs_"))
rm(source_phs)

