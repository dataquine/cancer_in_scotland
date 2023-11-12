#
# File: nrs_data_info.R
# Date: 2023-10-09
# Author: Lesley Duff
# Description:
#   URLs and file paths for data downloads from National Records of Scotland
#

# Age-standardised Death Rates Calculated Using the European Standard Population
# Table 1: All ages age-standardised death rates for all causes and certain 
# selected causes, Scotland, 1994 to 2022
# https://www.nrscotland.gov.uk/statistics-and-data/statistics/statistics-by-theme/vital-events/deaths/age-standardised-death-rates-calculated-using-the-esp
nrs_death_cause_url <- "https://www.nrscotland.gov.uk/files//statistics/age-standardised-death-rates-esp/2022/age-standard-death-rates-22-tab1.xlsx"
nrs_death_cause_raw_filepath <- "nrs/death/age-standard-death-rates-22-tab1.xlsx"
nrs_death_cause_filename <- "nrs_death_cause.csv"
nrs_death_cause_filepath <- paste0("nrs/death/", nrs_death_cause_filename)
# CSV text data for humans

# Spreadsheet info
nrs_death_cause_sheet <- "data for chart"
nrs_death_cause_range <- "A4:N34" # AGE-STANDARDISED rate table and range

# If NRS is used in charts/tables how should we refer to them?
source_nrs <- "Data Source: National Records of Scotland"