#
# File: nrs_data_info.R
# Date: 2023-10-09
# Author: Lesley Duff
# Description:
#   URLs and file paths for data downloads from National Records of Scotland
#

# Age-standardised Death Rates Calculated Using the European Standard Population
# Table 1: All ages age-standardised death rates for all causes and certain selected causes, Scotland, 1994 to 2022
# https://www.nrscotland.gov.uk/statistics-and-data/statistics/statistics-by-theme/vital-events/deaths/age-standardised-death-rates-calculated-using-the-esp
nrs_death_cause_url <- "https://www.nrscotland.gov.uk/files//statistics/age-standardised-death-rates-esp/2022/age-standard-death-rates-22-tab1.xlsx"
nrs_death_cause_raw_filepath <- "nrs/death/age-standard-death-rates-22-tab1.xlsx"
nrs_death_cause_filename <- "nrs_death_cause.csv"
nrs_death_cause_filepath <- paste0("nrs/death/", nrs_death_cause_filename)
# CSV text data for humans

nrs_death_cause_shiny_filepath <- "shiny_app/data/nrs_death_cause.RDS"
# Binary data for use by the shiny app

# Spreadsheet info
# N.B. This is awkwardly split in the sheet for no apparent reason
# Decided to manually determine ranges of two jables then combine them
nrs_death_cause_sheet <- "data for chart"
nrs_death_cause_range <- "A4:N34"

# There are confidence intervals not sure about how to use
# nrs_death_cause_range2 <- "A78:O150"
