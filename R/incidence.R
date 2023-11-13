#
# File: incidence.R
# Date: 2023-10-13
# Author: Lesley Duff
# Description:
#   Helper functions to manipulate cancer incidence information
#

library(assertr)
library(forcats) # reordering categories
library(ggfortify)
library(gt) # Styled tables
library(stringr) # Sorting strings

# Plot
# Plot 1 Linechart
cancer_incidence_plot_filepath <- "images/plot/plot_cancer_incidence.png"
cancer_incidences_by_year <- "Number of Cancer Incidences by Year and Sex"

# Plot 2 Box plot
cancer_incidence_plot_box_plot_filepath <- "images/plot/plot_cancer_incidence_boxplot.png"
# cancer_incidences_by_year <- "Number of Cancer Incidences by Year and Sex"

# Plot titles
cancer_incidence_by_year_cancer_sites_plot_filepath <-
  "images/plot/plot_cancer_incidence_by_year_cancer_sites.png"

cancer_incidence_by_age_range_plot_filepath <-
  "images/plot/plot_cancer_incidence_by_age_range_plot.png"

incidence_cancer_site_age_sex_range_title <- "Incidences by Age Range, Sex and Cancer Site"
incidence_cancer_site_age_sex_range_subtitle <- ""

# cancer_incidence_model_year_instances_filepath <- "images/plot/model_year_instances.png"

# table_incidences_cancer_sites
table_incidences_cancer_sites_title <- "Cancer Sites in Scotland"
table_incidences_years_high_low <- "Years with highest/lowest cancer incidences"
table_incidences_abbreviations <- "Abbreviations for Cancer Site names"

# These are variables in the dataframe
incidence_cancer_site_all_value <- "All cancer types"
incidence_cancer_site_all_sex_value <- "All"
incidence_cancer_site_all_ages_value <- "All ages"

incidence_cancer_site_icd10code_all <- "C00-C97, excluding C44"

incidence_all_sex_filter <- c("All", "Females", "Male")
incidence_sex_label <- "Sex"
incidence_incidences_label <- "Incidences" # Used for axis
incidence_year_label <- "Year" # Used for axis
incidence_result_label <- "Result" # Used for highest/lowest
incidence_highest_label <- "Highest"
incidence_lowest_label <- "Lowest"
incidence_age_ranges_label <- "Age Range"


# Helper functions ----
# ICD-10 ----
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

simplify_cancer_site <- function(df) {
  # These are for display purposes only to help long medical names fit on screen
  simplified <- df %>%
    mutate(cancer_site_short = case_match(cancer_site,
      "Acute lymphoblastic leukaemia" ~ "ALL...",
      "Acute myeloid leukaemia" ~ "AML",
      "Bone and articular cartilage" ~ "Bone & A...",
      "Bone and connective tissue" ~ "Bone & C...",
      "Malignant brain cancer" ~ "Brain",
      "All brain and CNS tumours (malignant and non-malignant)" ~
        "Brain & CNS...",
      "Malig brain ca (incl pit. gland, cranio. duct, pineal gland)" ~
        "Brain incl...",
      "Chronic lymphocytic leukaemia" ~ "CLL...",
      "Chronic myeloid leukaemia" ~ "CML...",
      "Colorectal cancer" ~ "Colorectal...",
      "Connective tissue" ~ "Connective...",
      "Head and neck" ~ "Head...",
      "Hodgkin lymphoma" ~ "Hodgkin...",
      "Lip, oral cavity and pharynx" ~ "Lip/Oral...",
      "Liver and intrahepatic bile ducts" ~ "Liver & bile...",
      "Trachea, bronchus and lung" ~ "Lung...",
      "Malignant melanoma of the skin" ~ "Skin...",
      "Multiple myeloma and malignant plasma cell neoplasms" ~ "Myeloma...",
      "Mouth (IARC definition)" ~ "Mouth...",
      "Non-Hodgkin lymphoma" ~ "Non-Hodgkin...",
      "Oropharyngeal cancers" ~ "Oropharyngeal...",
      "Rectum and rectosigmoid junction" ~ "Rectum...",
      "Salivary glands" ~ "Salivary...",
      .default = cancer_site
    ))
  return(simplified)
}

# Getters ----

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
    filter(cancer_site == incidence_cancer_site_all_value) %>%
    # Only interested in all age ranges
    filter(incidences_age_range == incidence_cancer_site_all_ages_value) %>%
    # select(year, cancer_site,sex,incidences_age_range) %>%
    group_by(year, cancer_site, sex, incidences_age_range, incidences_age) %>%
    summarise() %>%
    ungroup() %>%
    select(year, incidences_age, sex)
}

# For every year break down each cancer type by number of instances
get_incidences_by_cancer_site <- function(df) {
  # For each year, a count of how many of each type of cancer

  # Examples
  #  All cancer types,"C00-C97, excluding C44",Females,1997,Under 5,26,5 to 9,10.1350495350546
  #   Ovary,C56,Females,1997,Under 5,0,Under 5,0

  incidences_by_cancer_site <- df %>%
    # Remove All cancer types
    # cancer_site:"All cancer types"
    filter(cancer_site != incidence_cancer_site_all_value) %>% # "All cancer types"
    filter(incidences_age_range == incidence_cancer_site_all_ages_value) %>% # "All ages"
    filter(sex != incidence_cancer_site_all_sex_value) %>% # "All"

    group_by(
      year, cancer_site, cancer_site_short, sex,
      incidences_age_range, incidences_age
    ) %>%
    summarise(
      total_incidences = sum(incidences_age),
      avg_incidences = mean(incidences_age)
    ) %>%
    ungroup() %>%
    select(
      year, cancer_site, cancer_site_short, sex, incidences_age,
      avg_incidences, total_incidences
    )
  return(incidences_by_cancer_site)
}

# get table of abbreviations
get_shortened_cancer_site <- function(df) {
  shortened_cancer_site <- df %>%
    select(cancer_site, cancer_site_short) %>%
    group_by(cancer_site_short, cancer_site) %>%
    filter(cancer_site_short != cancer_site) %>%
    summarise() %>%
    ungroup()
  return(shortened_cancer_site)
}

# Which types of cancer/cancer sites are available?
get_cancer_site <- function(df) {
  cancer_site <- df %>%
    select(cancer_site, incidences_age) %>%
    group_by(cancer_site) %>%
    summarise(total = sum(incidences_age)) %>%
    arrange(desc(total)) %>%
    ungroup()
  return(cancer_site)
}

# Pull out a sorted age range so e.g 5 is before 10 numeric not 50 alphabetic
get_incidents_sorted_age_range <- function(df) {
  df %>%
    distinct(incidences_age_range) %>% # Unique only
    pull() %>% # Convert to vector
    str_sort(numeric = TRUE) # Sort as numeric values
}

# Retrieve incidences for age categories and sex
get_cancer_site_age_range <- function(df) {
  age_range <- df %>%
    filter(cancer_site != incidence_cancer_site_all_value) %>% # "All cancer types"
    filter(incidences_age_range != incidence_cancer_site_all_ages_value) %>% # "All ages"
    filter(sex != incidence_cancer_site_all_sex_value) %>% # "All"

    group_by(cancer_site, cancer_site_short, sex, year, incidences_age_range, incidences_age) %>%
    summarise() %>%
    ungroup() %>%

    group_by(cancer_site, cancer_site_short, sex, incidences_age_range) %>%
    summarise(total_incidences = sum(incidences_age)) %>%
    ungroup() %>%     
    
    return(age_range)
}

# Filter by sex, age and cancer site retrieving the top n entries
# This is used by the Cancer Risk Tool
get_top_incidences_age_range_sex <- function(df,
                                             top = 10,
                                             filter_sex = c("Male", "Females"),
                                             filter_age = NULL,
                                             filter_cancer_site = NULL) {
  `%==%` <- function(e1, e2) {
    if (is.null(e2)) {
      return(TRUE)
    } else {
      return(e1 %in% e2)
    }
  }
  df %>%
    select(cancer_site, incidences_age_range, sex, total_incidences) %>%
    filter(sex %==% filter_sex) %>%
    filter(incidences_age_range %==% filter_age) %>%
    filter(cancer_site %==% filter_cancer_site) %>%
    group_by(cancer_site, incidences_age_range, sex) %>%
    mutate(mean_cancer_site_incidences = mean(total_incidences)) %>%
    ungroup() %>%
    slice_max(mean_cancer_site_incidences, n = top) %>% # ?slice_max
    select(-mean_cancer_site_incidences)
}

# Plot Start ----

# Plot INCIDENCE 1
# Show trend of incidences over time
plot_incidences_by_year <- function(df,
                                    show_covid = TRUE,
                                    plot_title = cancer_incidences_by_year,
                                    plot_x = "",
                                    plot_y = incidence_incidences_label,
                                    filter_sex = incidence_all_sex_filter,
                                    plot_sex = incidence_sex_label) {
  plot <- df %>%
    mutate(label = if_else(year == max(year) |
      year == min(year),
    as.character(incidences_age), NA_character_
    )) %>%
    filter(sex %in% filter_sex) %>%
    ggplot(aes(x = year, y = incidences_age, color = sex)) +
    geom_line(linewidth = 1) +

    # Too messy when all male and female
    # geom_smooth(se = FALSE, method = lm, alpha = 0.3) +

    #    geom_label_repel(aes(label = label), # ?geom_label_repel
    # nudge_x = 0,
    #     nudge_y = Inf,
    #   na.rm = TRUE
    #    ) +
    # geom_hline(
    #   yintercept = Inf,
    #   #   colour = "red",
    #   alpha = 0.5,
    #   linetype = 1
    # ) +
    geom_point(size = 3) +
    scale_colour_cis_qualitative(cis_palette_sex) +
    scale_y_continuous(label = scales::label_comma()) +
    scale_x_continuous(breaks = seq(
      from = min(df$year),
      to = max(df$year),
      by = 2
    )) +
    theme(axis.ticks.x = ggplot2::element_line()) + # Add back ticks to line up points
    labs(
      title = plot_title,
      subtitle = paste(min(df$year), max(df$year), sep = "-"),
      x = paste0("\n", plot_x),
      y = paste0(plot_y, "\n"),
      caption = source_phs,
      colour = plot_sex
    )
  if (show_covid) {
    plot <- plot + geom_vline(
      xintercept = 2020, # The year COVID-19 started
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

# Plot INCIDENCE 2, incidences by sex - a box plot
plot_incidences_by_year_boxplot <- function(df,
                                            plot_x = "",
                                            plot_y = incidence_incidences_label,
                                            plot_fill = incidence_sex_label) {
  plot <- df %>%
    ggplot(aes(y = incidences_age, fill = sex)) +
    geom_boxplot() +
    scale_fill_cis_qualitative(cis_palette_sex) +
    scale_y_continuous(label = scales::label_comma()) +
    labs(
      title = "Yearly Incidences by Sex",
      x = paste0("\n", plot_x),
      y = paste0(plot_y, "\n"),
      caption = source_phs,
      fill = plot_fill
    )
  return(plot)
}

# Plot INCIDENCE 3, incidences_by_year_cancer_site
plot_incidences_by_year_cancer_site <- function(df, start_year, end_year) {
  df %>%
    ggplot(aes(x = year, y = incidences_age, fill = sex)) +
    geom_area(aes(colour = sex)) +
    facet_wrap(~cancer_site_short, ncol = 9) +
    scale_y_continuous(label = scales::label_comma()) +
    scale_fill_cis_qualitative(cis_palette_sex) +
    scale_colour_cis_qualitative(cis_palette_sex) +
    theme(
      strip.text = element_text(size = 9),
      axis.text.x = element_blank()
    ) +
    guides(colour = "none") +
    labs(
      x = paste0(
        "\n", incidence_year_label,
        " (", start_year, " - ", end_year, ")"
      ),
      y = paste0(incidence_incidences_label, "\n"),
      fill = incidence_sex_label,
      colour = ""
    )
}

# Plot INCIDENCE 4, all_cancer_site_age_range
plot_all_cancer_site_age_sex_range <- function(df, plot_x = incidence_age_ranges_label,
                                               plot_y = incidence_incidences_label,
                                               plot_title = incidence_cancer_site_age_sex_range_title,
                                               plot_subtitle = incidence_cancer_site_age_sex_range_subtitle) {
  age_range <- get_incidents_sorted_age_range(df)
  plot <- df %>%
    mutate(incidences_age_range = fct_relevel(
      incidences_age_range,
      age_range
    )) %>%
    ggplot() + # cis_colour_cancer.  aes(x = incidences_age_range, y = total_incidences)
    geom_col(aes(
      x = incidences_age_range, y = total_incidences,
      fill = sex, colour = sex
    )) +
    #    theme(legend.position = "bottom", axis.text.x = element_blank()) +
    facet_wrap(~cancer_site_short, ncol = 9) +
    scale_colour_cis_qualitative(cis_palette_sex) +
    scale_fill_cis_qualitative(cis_palette_sex) +
    scale_y_continuous(label = scales::label_comma()) +
    guides(colour = "none") +
    theme(
      strip.text = element_text(size = 9),
      axis.text.x = element_blank()
    ) +
    labs(
      title = plot_title,
      subtitle = plot_subtitle,
      caption = source_phs,
      fill = "",
      x = paste0(plot_x, ": Youngest (0-4) to Oldest (90+)"),
      y = plot_y
    )
  return(plot)
}

# Tables Start ----

# Table showing mapping of shortened abbreviated names to the full versions
table_shortened_cancer_site <- function(df,
                                        title = table_incidences_abbreviations) {
  table <- df %>%
    gt() %>%
    tab_header(title = title) %>%
    cols_label(
      cancer_site_short = html("Short Name"),
      cancer_site = html("Cancer Site")
    )
  return(table)
}

# Table showing highest and lowest incidences and which years
table_summary_incidences_sex <- function(
    df,
    title = "Summary statistics Incidences by Sex",
    lowest_year, highest_year) {
  df %>%
    gt() %>%
    tab_header(
      title = title,
      subtitle = glue::glue("Data between: {lowest_year} and {highest_year}")
    ) %>%
    cols_label(
      sex = html(incidence_result_label),
      total = html("Total"),
      mean = html("Mean"),
      median = html("Median"),
    ) %>%
    tab_source_note(source_note = source_phs) %>%
    fmt_number(columns = c(total, mean, median), decimals = 0)
}

# Table showing highest and lowest incidences and which years
table_incidences_min_max <- function(
    df, lowest_year, highest_year,
    title = table_incidences_years_high_low) {
  df %>%
    gt() %>%
    tab_header(
      title = title,
      subtitle = glue::glue("Data between: {lowest_year} and {highest_year}")
    ) %>%
    cols_label(
      result = html(incidence_result_label),
      incidences = html(incidence_incidences_label),
      year = html(incidence_year_label),
    ) %>%
    tab_source_note(source_note = source_phs) %>%
    fmt_number(columns = incidences, decimals = 0)
}

# Table showing highest and lowest incidences and which years
table_incidences_cancer_sites <- function(df, oldest_year,
                                          newest_year,
                                          title = table_incidences_cancer_sites_title) {
  df %>%
    gt() %>%
    tab_header(
      title = title,
      subtitle = glue::glue("{newest_year}")
    ) %>%
    cols_label(
      total_incidences = html("Total"),
      cancer_site = html("Cancer Site")
    ) %>%
    tab_source_note(source_note = source_phs) %>%
    fmt_number(columns = total_incidences, decimals = 0)
}

# Table showing highest and lowest incidences and which years
table_incidences_cancer_sites_between <- function(df, lowest_year,
                                                  highest_year,
                                                  table_title = table_incidences_cancer_sites_title) {
  table <- df %>%
    gt() %>%
    tab_header(
      title = table_title,
      subtitle = glue::glue("Between: {lowest_year} and {highest_year}")
    ) %>%
    cols_label(
      total = html("Total"),
      #  mean = html("Mean"),
      cancer_site = html("Cancer Site")
    ) %>%
    tab_source_note(source_note = source_phs) %>%
    fmt_number(columns = c(total), decimals = 0)
  return(table)
}

table_incidences_cancer_sites_age_range <- function(df,
                                                    table_title = "",
                                                    table_subtitle = "") {
  table <- df %>%
    gt() %>%
    tab_header(
      title = table_title,
      subtitle = table_subtitle
    ) %>%
    cols_label(
      cancer_site = html("Cancer Site"),
      incidences_age_range = html("Age Range"),
      sex = html("Sex"),
      total_incidences = html("Incidences")
    ) %>%
    tab_source_note(source_note = source_phs) %>%
    fmt_number(columns = c(total_incidences), decimals = 0)
  return(table)
}

# Modelling ----
# Model 1
build_model_year_incidences <- function(df) {
  # model <- lm(year ~ incidences_age, df)
  # "outcome ~ predictor" Incidences predicted by year
  model <- lm(incidences_age ~ year, df)
  auto <- autoplot(model, colour = "sex", data = df) +
    scale_colour_cis_qualitative() +
    labs(
      #  x = incidence_incidences_label, y = incidence_year_label,
      #   caption = source_phs, # gets added to all 4
      colour = incidence_sex_label
    )
  # diagnostics ?autoplot ?lm
  summary(model) # ?summary
  return(auto)
}
