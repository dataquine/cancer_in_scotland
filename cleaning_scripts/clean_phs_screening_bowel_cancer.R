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

library(here)

phs_screening_bowel_filename <- "data_raw/phs/screening/bowel/2023-02-21-bowel-screening-kpi-report.xlsx"

# Uptake (KPI 1)
bowel_sheet_uptake <- "KPI_1"

# Uptake ----
# Read in raw spreadsheet

# Extract Sheet for Uptake ----


# Write Clean data ----