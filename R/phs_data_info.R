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

# Waiting Times
## 31 Day Standard
phs_waiting_times_31_days_url <- "https://www.opendata.nhs.scot/dataset/11c61a02-205b-43f6-9297-243679103617/resource/58527343-a930-4058-bf9e-3c6e5cb04010/download/cwt_31_day_standard.csv"
phs_waiting_times_31_days_raw_filepath <- "phs/waiting_times/cwt_31_day_standard.csv"
phs_waiting_times_31_days_filename <- "phs_waiting_time_31_day_standards.csv"
phs_waiting_times_31_days_filepath <- paste0("phs/waiting_times/", phs_waiting_times_31_days_filename)

## 62 Day Standard
phs_waiting_times_62_days_url <- "https://www.opendata.nhs.scot/dataset/11c61a02-205b-43f6-9297-243679103617/resource/23b3bbf7-7a37-4f86-974b-6360d6748e08/download/cwt_62_day_standard.csv"
phs_waiting_times_62_days_raw_filepath <- "phs/waiting_times/cwt_62_day_standard.csv"
phs_waiting_times_62_days_filename <- "phs_waiting_time_62_day_standards.csv"
phs_waiting_times_62_days_filepath <- paste0("phs/waiting_times/", phs_waiting_times_62_days_filename)

# Combined file
phs_waiting_times_days_filename <- "phs_waiting_time_day_standards.csv"
phs_waiting_times_days_filepath <- paste0("phs/waiting_times/", phs_waiting_times_days_filename)


phs_incidence_shiny_filepath <- "shiny_app/data/phs_incidence.RDS"
# Binary data for use by the shiny app

# If PHS is used in charts/tables how should we refer to them?
source_phs <- "Data Source: Public Health Scotland"