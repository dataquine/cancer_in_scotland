#
# File: nrs_data_info.R
# Date: 2023-10-09
# Author: Lesley Duff
# Description:
#   URLs and file paths for data downloads from National Records of Scotland
#

# Table 6.01 Deaths, by sex and cause, Scotland, 2009 to 2022

#phs_screening_bowel_url <- "https://publichealthscotland.scot/media/17689/2023-02-21-bowel-screening-kpi-report.xlsx"
nrs_death_cause_raw_filepath <- "nrs/death/vital-events-22-ref-tabs-6_6.01.csv"
nrs_death_cause_filename <- "nrs_death_cause.csv"
nrs_death_cause_filepath <- paste0("nrs/death/", nrs_death_cause_filename)
# CSV text data for humans

death_cause_shiny_filepath <- "shiny_app/data/nrs_death_cause.RDS"
# Binary data for use by the shiny app