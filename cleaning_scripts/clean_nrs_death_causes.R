#
# File: clean_nrs_death_causes.R
# Date: 2023-10-09
# Author: Lesley Duff
# Description:
#   Clean National Records Scotland datasets for causes of death
#
# Source:
# 	Table 1: All ages age-standardised death rates for all causes and certain selected causes, Scotland, 1994 to 2022
# https://www.nrscotland.gov.uk/files//statistics/age-standardised-death-rates-esp/2022/age-standard-death-rates-22-tab1.zip
# Table file: age-standard-death-rates-22-data-for-chart.csv

# Background:
# https://www.nrscotland.gov.uk/statistics-and-data/statistics/statistics-by-theme/vital-events/deaths/age-standardised-death-rates-calculated-using-the-esp

library(dplyr)
library(here)
library(janitor)
library(readxl) # For processing Excel spreadsheets
library(readr)
library(tidyr)
#library(tidyverse)

source(here::here("R/nrs_data_info.R"))


#death_cause <- read_csv(
#  here::here("data_raw", nrs_death_cause_raw_filepath),
 #            skip = 3
#)
#?read_excel
nrs_death_cause_range
death_cause_raw <- read_excel(
  here::here("data_raw", nrs_death_cause_raw_filepath),
 sheet = nrs_death_cause_sheet,
  range = nrs_death_cause_range,
 # skip = 3
)

cause_labels <- death_cause_raw[1]
rate_labels <- death_cause_raw[2]
cause_labels
rate_labels


death_cause <- death_cause_raw %>% 
  pivot_longer(3:last_col() , names_to = "cause", values_to = "rate") %>% 
  janitor::clean_names() %>% 
  filter(rate != "rate") %>% 
  mutate(rate = as.numeric(rate)) %>% 
#  rename(
 #   "year" <- "x1"
#     = cancer_malignant_neoplasms_140_208_c00_97#
  #) %>% 
  # remove first row
  .[-1, ] #%>% 
 
#death_cause[1, 1] <- "yassa"

#rename(death_cause, "qwerty"="x1")

head(death_cause)
View(death_cause)
#problems(death_cause) 
names(death_cause)
summary(death_cause)

# Names are like "Cancer (malignant neoplasms: 140-208 /C00-97)"  
# Would like to
# strip out  ' ()' at end of string and extract into separate column

# Uptake (KPI 1)
# screening_bowel_uptake_sheet <- "KPI_1"
# screening_bowel_uptake_sheet_skip <- 14
# Table 1, rows 16-20, columns Persons and a column for each Health Board and
# a total for Scotland (column q)
# screening_bowel_uptake_range <- "B16:Q20"

# death_cause_raw1 <- read_excel(
#  here::here("data_raw", nrs_death_cause_raw_filepath),
# sheet = nrs_death_cause_sheet,
#  range = nrs_death_cause_range1
# )

# death_cause_raw2 <- read_excel(
#  here::here("data_raw", nrs_death_cause_raw_filepath),
#  sheet = nrs_death_cause_sheet,
#  range = nrs_death_cause_range2
# )

# Combine tables vertically and delete first row all nas
# death_cause_raw <- rbind(death_cause_raw1, death_cause_raw2) [-1,]

# death_cause_raw2 <- death_cause_raw %>%

# fill(`year`)
# View(death_cause_raw)
# View(death_cause_raw2)

# Consider extracting first 3 rows into separate table?

# View(death_cause_raw)


# death_csv <- read_csv(
#   here::here(
#     "data_raw",
#     "nrs/death/vital-events-22-ref-tabs-6_6.01.csv"
#   ),
#   skip = 2
# )
# 
# # names(death_csv)
# 
# # View(death_csv)
# 
# # names(death_csv)
# 
# 
# icd10label <- names(death_csv)[1]
# icd10label
# # death_csv[1, 1]  <- icd10label
# 
# 
# # Delete Rows matching the label
# death_csv2 <- death_csv %>%
#   janitor::clean_names() %>%
#   rename("sex" = "x3") %>%
#   .[-1, ] %>% # Remove the empty row at the start
#   #  .[1,1] %>%  #= icd10label %>%
#   # .[, 1] <- icd10label %>%
# 
#   filter(!is.na(sex)) %>%
#   # There are some empty columns at the end, remove them
#   discard(~ all(is.na(.) | . == "")) %>%
#   mutate(
#     icd10_summary_list = as.factor(icd10_summary_list),
#     cause_of_death = as.factor(cause_of_death),
#     sex = as.factor(sex)
#   ) # %>%
# 
# #death_csv2[1, 1]  <- c(icd10label)
# 
# # Year columns are Character columns - cahnge to numeric
# # mutate_if(is.character, as.numeric)
# 
# # Move all the year
# # pivot_longer(cols = starts_with("x"), names_to = "exam_question", values_to = "score")
# 
# # Manually set something in the first row and column
# 
# head(death_csv2)
# #
# # filter(`ICD10 Summary list` != "ICD10 Summary list")
# 
# 
# View(death_csv2)
# 
# death_csv2
