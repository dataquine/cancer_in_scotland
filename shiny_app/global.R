#
# File: global.R
# Date: 2023-10-09
# Author: Lesley Duff
# Description:
#   App-wide information
#

source(here::here("R/screening.R"))

app_title <- "Cancer in Scotland"

# General
download_title <- "Download"

tab_home_title <- "Overview"
tab_screening_title <- "Screening"
tab_about_title <- "About"

screening_title <- "Screening"
bowel_cancer_title <- "Bowel cancer"
phs_screening_bowel_uptake_filename <- "phs_screening_bowel_uptake.csv"
tab_home_title <- "Overview"

# Bowel Cancer ----
# plots
#plot_bowel_cancer_health_board_title <- "By Health Board"
plot_bowel_cancer_health_board_title <- "Health Board"
plot_bowel_cancer_percent_title <- "Percent"
plot_bowel_cancer_sex_title <- "Sex"
plot_bowel_cancer_uptake_percent_title <- "uptake (%)"

plot_bowel_cancer_uptake_title <- paste0("Uptake by ", 
                                         plot_bowel_cancer_health_board_title, 
                                         " and ", plot_bowel_cancer_sex_title)


library(dplyr)

# Screening Bowl Cancer takeup KP1
#test_kpi1 <- tibble(
#  customer_ID = c(001, 002, 004, 005, 008, 010), 
#  name = c("John Smith", "Jane Adams", "Robert Landry", "Jane Tow", "Raul Tann", "Hilary Joyal"),
#  email_address = c("johnsmith@gmail.com", "janea@gmail.com", "rlabdry@hotmail.com", "janet89@aol.com", "paul.tann1@gmail.com", NA),
#  shipping_address = c("32 Station Road, Edinburgh", "42 Park Drive, Edinburgh", NA, "10 Gardiner Rd, Edinburgh", "12 Main St, Edinburgh", " 234 Queensferry Rd, Edinburgh,")
#)

#test_kpi1 <- read_csv(here::here(
#  "data_clean", phs_screening_bowel_uptake_filepath
#))

screening_bowel_cancer_takeup_all <- readRDS(file = "data/phs_screening_bowel_uptake.RDS")

#screening_bowel_cancer_takeup_healthboards <-  
#  get_screening_bowel_cancer_takeup(screening_bowel_cancer_takeup_full,
#                                    filter_sex = c(screening_filter_sex_scotland),
#                                    filter_area = c("Fife")
#                                    )

screening_bowel_cancer_takeup_health_boards <- get_screening_bowel_cancer_takeup(
  screening_bowel_cancer_takeup_all, 
   filter_sex = c("Females","Males"), 
  #filter_sex = c("All persons"), 
  # filter_area = c("Grampian", "Fife"),
  remove_scotland = TRUE
)
#View(screening_bowel_cancer_takeup_health_boards)

#get_screening_bowel_cancer_takeup <- function(df,
 #                                             filter_sex = c(screening_filter_sex_scotland),
  #                                            filter_area = c(screening_filter_area_scotland))

screening_bowel_cancer_takeup_kpi <- get_screening_bowel_cancer_takeup_kpi1(screening_bowel_cancer_takeup_health_boards)
