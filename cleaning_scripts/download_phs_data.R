#
# File: phs_data_info.R
# Date: 2023-10-09
# Author: Lesley Duff
# Description:
#  Download data from Public Health Scotland
#

library(here)

source(here::here("cleaning_scripts/phs_data_info.R"))

# Fetch the Latest Bowel Screening data
download.file(
  phs_screening_bowel_url,
  here::here("data_raw", phs_screening_bowel_raw_filename)
)
