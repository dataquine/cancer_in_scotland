#
# File: clean_nrs_death_causes.R
# Date: 2023-10-09
# Author: Lesley Duff
# Description:
#   Clean National Records Scotland datasets for causes of death
#
# Source:
# https://www.nrscotland.gov.uk/files//statistics/vital-events-ref-tables/2022/vital-events-22-ref-tabs-6.xlsx
# Table 6.01 Deaths, by sex and cause, Scotland, 2009 to 2022

# Background:
# https://www.nrscotland.gov.uk/statistics-and-data/statistics/statistics-by-theme/vital-events/general-publications/vital-events-reference-tables/2022/list-of-data-tables#section6

library(dplyr)
library(here)
library(janitor)
library(readxl) # For processing Excel spreadsheets
library(readr)
library(tidyr)
library(tidyverse)

source(here::here("R/nrs_data_info.R"))


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


death_csv <- read_csv(
  here::here(
    "data_raw",
    "nrs/death/vital-events-22-ref-tabs-6_6.01.csv"
  ),
  skip = 2
)

# names(death_csv)

# View(death_csv)

# names(death_csv)


icd10label <- names(death_csv)[1]
icd10label
# death_csv[1, 1]  <- icd10label


# Delete Rows matching the label
death_csv2 <- death_csv %>%
  janitor::clean_names() %>%
  rename("sex" = "x3") %>%
  .[-1, ] %>% # Remove the empty row at the start
  #  .[1,1] %>%  #= icd10label %>%
  # .[, 1] <- icd10label %>%

  filter(!is.na(sex)) %>%
  # There are some empty columns at the end, remove them
  discard(~ all(is.na(.) | . == "")) %>%
  mutate(
    icd10_summary_list = as.factor(icd10_summary_list),
    cause_of_death = as.factor(cause_of_death),
    sex = as.factor(sex)
  ) # %>%

#death_csv2[1, 1]  <- c(icd10label)

# Year columns are Character columns - cahnge to numeric
# mutate_if(is.character, as.numeric)

# Move all the year
# pivot_longer(cols = starts_with("x"), names_to = "exam_question", values_to = "score")

# Manually set something in the first row and column

head(death_csv2)
#
# filter(`ICD10 Summary list` != "ICD10 Summary list")


View(death_csv2)

death_csv2
