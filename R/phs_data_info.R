#
# File: phs_data_info.R
# Date: 2023-10-09
# Author: Lesley Duff
# Description:
#   URLs and file paths for data downloads from Public Health Scotland
#

# Screening programmes
#   Bowel cancer
phs_screening_bowel_url <- "https://publichealthscotland.scot/media/17689/2023-02-21-bowel-screening-kpi-report.xlsx"
phs_screening_bowel_raw_filepath <- "phs/screening/bowel/2023-02-21-bowel-screening-kpi-report.xlsx"
phs_screening_bowel_uptake_filename <- "phs_screening_bowel_uptake.csv"
phs_screening_bowel_uptake_filepath <- paste0("phs/screening/bowel/", phs_screening_bowel_uptake_filename)
# CSV text data for humans

phs_screening_bowel_uptake_shiny_filepath <- "shiny_app/data/phs_screening_bowel_uptake.RDS"
# Binary data for use by the shiny app

# Incidence
phs_incidence_url <- "https://www.opendata.nhs.scot/dataset/c2c59eb1-3aff-48d2-9e9c-60ca8605431d/resource/72c852b8-ee28-4fd8-84a9-5f415f4bc325/download/opendata_inc9721_scotland.csv"
phs_incidence_raw_filepath <- "phs/incidence/opendata_inc9721_scotland.csv"
phs_incidence_filename <- "phs_incidence.csv"
phs_incidence_filepath <- paste0("phs/incidence/", phs_incidence_filename)
# CSV text data for humans

phs_incidence_shiny_filepath <- "shiny_app/data/phs_incidence.RDS"
# Binary data for use by the shiny app
