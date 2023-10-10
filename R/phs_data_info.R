#
# File: phs_data_info.R
# Date: 2023-10-09
# Author: Lesley Duff
# Description:
#   URLs and file paths for data downloads from Public Health Scotland
#

phs_screening_bowel_url <- "https://publichealthscotland.scot/media/17689/2023-02-21-bowel-screening-kpi-report.xlsx"
phs_screening_bowel_raw_filepath <- "phs/screening/bowel/2023-02-21-bowel-screening-kpi-report.xlsx"
phs_screening_bowel_uptake_filename <- "phs_screening_bowel_uptake.csv"
phs_screening_bowel_uptake_filepath <- paste0("phs/screening/bowel/", phs_screening_bowel_uptake_filename)
# CSV text data for humans

phs_screening_bowel_uptake_shiny_filepath <- "shiny_app/data/phs_screening_bowel_uptake.RDS"
# Binary data for use by the shiny app