#
# File: incidence.R
# Date: 2023-10-13
# Author: Lesley Duff
# Description:
#   Helper functions to manipulate cancer incidence information
#

library(assertr)
library(gt)

# library(ggrepel)

# Plot
cancer_incidence_plot_filepath <- "images/plot/plot_cancer_incidence.png"
cancer_incidences_by_year <- "Number of cancer incidences by year in Scotland"

# These are variables in the dataframe
incidence_cancer_site_all_value <- "All cancer types"
incidence_cancer_site_value <- "All"
incidence_cancer_site_all_ages_value <- "All ages"

incidence_cancer_site_icd10code_all <- "C00-C97, excluding C44"


# In case the raw data changes in the future lets build in some assertive
# programming checks to make sure the correct filtering is in place
check_valid_icd10 <- function(df) {
  df %>%
    # For filtering we are looking at things not already categorised as
    # 'All cancer types' i.e. different cancer types
    filter(cancer_site != incidence_cancer_site_all_value) %>%
    # Check that we are not including non-malignant melanoma (C44)
    verify(!str_detect(cancer_site_icd10code, "C44")) %>%
    # check our ICD codes contain a 'C' code
    verify(str_detect(cancer_site_icd10code, "C")) %>% 
    # We assume after these checks that it is safe to use
    return(TRUE)
  return(FALSE)
}


# Show trend of incidences over time
plot_incidences_by_year <- function(df,
                                    show_covid = TRUE,
                                    plot_title = cancer_incidences_by_year,
                                    plot_x = "",
                                    plot_y = "Incidences\n") {
  plot <- df %>%
    mutate(label = if_else(year == max(year) |
      year == min(year),
    as.character(incidences_age), NA_character_
    )) %>%
    ggplot(aes(x = year, y = incidences_age)) +
    geom_line() +
    #    geom_label_repel(aes(label = label), # ?geom_label_repel
    # nudge_x = 0,
    #     nudge_y = Inf,
    #   na.rm = TRUE
    #    ) +
    geom_hline(
      yintercept = 0,
      #   colour = "red",
      alpha = 0.5,
      linetype = 1
    ) +
    geom_point() +
    scale_y_continuous(label = scales::label_comma()) +
    scale_x_continuous(breaks = seq(
      from = min(df$year),
      to = max(df$year),
      by = 2
    )) +
    theme(
      panel.grid.major.y = element_blank()
      #   panel.grid.major.x = ggplot2::element_line()
    ) +
    labs(
      title = plot_title,
      subtitle = paste(min(df$year), max(df$year), sep = "-"),
      x = plot_x,
      y = plot_y,
      caption = source_phs
    )
  if (show_covid) {
    plot <- plot + geom_vline(
      xintercept = 2020,
      colour = "red",
      alpha = 0.7,
      linetype = 3
    )
    plot <- plot + annotate( # ??annotate
      "label",
      label = "COVID-19",
      colour = "red",
      # annotate("text", x = -Inf, y = Inf,
      x = 2020,
      y = 0
      # hjust = 0.5, vjust = 0,parse = TRUE
    )
  }

  return(plot)
}

# Table showing highest and lowest incidencdes and which years
table_incidences_min_max <- function(df, lowest_year, highest_year) {
  df %>%
    gt() %>%
    tab_header(
      title = "Years with highest/lowest cancer incidences",
      subtitle = glue::glue("Data between: {lowest_year} and {highest_year}")
    ) %>%
    fmt_number(columns = incidences, decimals = 0)
}

# Retrieve the year of highest incidences
get_highest_incidences_by_year <- function(df) {
  df %>%
    arrange(desc(incidences_age)) %>%
    select(year) %>%
    slice(1L) %>%
    pull()
}

# Retrieve the year of lowest incidences
get_lowest_incidences_by_year <- function(df) {
  lowest_incidences_by_year <- incidences_by_year %>%
    arrange(incidences_age) %>%
    select(year) %>%
    slice(1L) %>%
    pull()
}

# Top level for total all cancers per year = count
get_incidences_by_year <- function(df) {
  df <- incidence %>%
    # mutate(cancer_site = str_trunc(cancer_site, 30)) %>%
    # Only interested in top level numbers
    filter(cancer_site == "All cancer types") %>%
    # Only interested in all sexes
    filter(sex == "All") %>%
    # Only interested in all age ranges
    filter(incidences_age_range == "All ages") %>%
    # select(year, cancer_site,sex,incidences_age_range) %>%
    group_by(year, cancer_site, sex, incidences_age_range, incidences_age) %>%
    summarise() %>%
    ungroup() %>%
    select(year, incidences_age)
}

# For every year break down each cancer type by number of instances
get_incidences_by_cancer_site <- function(df) {
  # For each year, a count of how many of each type of cancer
  incidences_by_cancer_site <- df %>%
    # Remove All cancer types
    filter(cancer_site != incidence_cancer_site_all_value) %>%
    # Only interested in all sexes
    filter(sex == incidence_cancer_site_value) %>%
    # Only interested in all age ranges
    filter(incidences_age_range == incidence_cancer_site_all_ages_value) %>%
    group_by(year, cancer_site, sex, incidences_age_range, incidences_age) %>%
    summarise() %>%
    # filter(year==1997) %>%
    ungroup() %>%
    select(year, cancer_site, incidences_age)
  return(incidences_by_cancer_site)
}
