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
library(ggplot2)
library(here)
library(janitor)
library(lubridate)
library(readxl) # For processing Excel spreadsheets
library(readr)
library(tidyr)
library(tidyverse)

source(here::here("R/nrs_data_info.R"))

death_cause_raw <- read_excel(
  here::here(
    "data_raw",
    nrs_death_cause_raw_filepath
  ),
  sheet = nrs_death_cause_sheet,
  range = nrs_death_cause_range,
  .name_repair = "unique_quiet"
  # col_names = TRUE
  # skip = 3
)

cause_labels <- death_cause_raw[1]
rate_labels <- death_cause_raw[2]




death_cause <- death_cause_raw %>%
  pivot_longer(
    cols = 2:last_col(),
    names_to = "cause",
    values_to = "rate"
  ) %>%
  janitor::clean_names() %>%
  # remove first row
  .[-1, ] %>%
  filter(rate != "rate") %>%
  rename(year = x1) %>%
  mutate(rate = as.numeric(rate),
         year = as.numeric(year)) 


names(death_cause)

summary(death_cause$rate)

print(n = 5, death_cause)

## newd <- death_cause %>%
# mutate(year = as(year))

#print(newd)

all_causes <- death_cause %>%
  filter(cause == "All causes")

individual_causes <- death_cause %>%
  filter(cause != "All causes")




plot_causes <- function(df) {
  df %>%
    ggplot(aes(x = year, y = rate)) +
     geom_point(color = "darkorchid4") +
 #   geom_bar(aes(fill = cause), stat = "identity") +
    #geom_col(aes(fill = cause)) +
    # facet_wrap(~year) +
    geom_line(aes(x = year, y = rate, colour=cause), group =1)+
    # adjust the x axis breaks
    # ?scale_x_date
    #  scale_x_date(date_breaks = "5 years", date_labels = "%m-%Y") %>%
    labs(
      title = "Age-standardised death rates",
      subtitle = " All causes and certain selected causes, Scotland, 1994 to 2022",
      y = "Rate",
      x = "Year",
      caption = "National Records of Scotland"
    ) +
    theme_bw(base_size = 15)
}
all_causes

individual_causes

#names(all_causes)

plot_causes(all_causes)

plot_causes(individual_causes)



