#
# File: incidence.R
# Date: 2023-10-13
# Author: Lesley Duff
# Description:
#   Helper functions to manipulate cancer incidence information
#

library(assertr)
library(ggfortify)
library(gt)

# library(ggrepel)

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

# cancer_incidence_model_year_instances_filepath <- "images/plot/model_year_instances.png"

# table_incidences_cancer_sites
table_incidences_cancer_sites_title <- "Cancer Sites in Scotland"
table_incidences_years_high_low <- "Years with highest/lowest cancer incidences"
table_incidences_abbreviateions <- "Abbreviations for Cancer Site names"

# These are variables in the dataframe
incidence_cancer_site_all_value <- "All cancer types"
incidence_cancer_site_all_sex_value <- "All"
incidence_cancer_site_all_ages_value <- "All ages"

incidence_cancer_site_icd10code_all <- "C00-C97, excluding C44"

incidence_all_sex_filter <- c("All", "Females", "Male")
incidence_sex_label <- "Sex"
incidence_incidences_label <- "Incidences" # Used for axis
incidence_year_label <- "Year" # Used for axis

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
    filter(cancer_site == "All cancer types") %>%
    # Only interested in all sexes
    # TODO GENDERS
    # filter(sex == "All") %>%
    # Only interested in all age ranges
    filter(incidences_age_range == "All ages") %>%
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
    #  filter(cancer_site != incidence_cancer_site_all_value) %>%  #cancer_site:"All cancer types"
    # Only interested in all sexes
    # TODO JKL Ovary,C56,Females,1997,Under 5,0,Under 5,0
    # filter(sex == incidence_cancer_site_all_sex_value) %>%
    #
    filter(
      ((cancer_site != incidence_cancer_site_all_value) & (sex == incidence_cancer_site_all_sex_value)) |
        ((cancer_site != incidence_cancer_site_all_value) & (sex == "Females") & (incidences_age_range == "All")) |
      ((cancer_site != incidence_cancer_site_all_value) & (sex == "Male") & (incidences_age_range == "All"))
    ) %>%
    #    filter((sex == incidence_cancer_site_all_sex_value) | # sex:"All"
    #              ((sex != incidence_cancer_site_value) && ())
    #
    #            ) %>%
    # All
    #  filter(cancer_site == "Prostate") %>%
    #   filter(year == 2021) %>%
    # filter((cancer_site != incidence_cancer_site_all_value)
    #     & (sex == "Male")) %>%
    # (cancer_site != incidence_cancer_site_all_value) & (sex == "Females")

    # &
    # (sex != incidence_cancer_site_all_sex_value)
    #     &
    #        ) %>%
    #    filter(
    #      (cancer_site != incidence_cancer_site_all_value)
    #          ) %>%

    # cancer_site == "All cancer types" |
    # (!str_detect(cancer_site_icd10code, "C44") &
    #    str_detect(cancer_site_icd10code, "C")
    # )

    # Only interested in all age ranges
    #  filter(incidences_age_range == incidence_cancer_site_all_ages_value) %>%
    group_by(
      year, cancer_site, cancer_site_short, sex,
      incidences_age_range, incidences_age
    ) %>%
    summarise(
      total_incidences = sum(incidences_age),
      avg_incidences = mean(incidences_age)
    ) %>%
    #  summarise(total_incidences = incidences_age) %>%
    # filter(year==1997) %>%
    ungroup() %>%
    select(
      year, cancer_site, cancer_site_short, sex, incidences_age,
      avg_incidences, total_incidences
    )
  return(incidences_by_cancer_site)
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
    scale_colour_cis_qualitative(palette_sex) +
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
      caption = source_phs,
      colour = plot_sex
    )
  if (show_covid) {
    plot <- plot + geom_vline(
      xintercept = 2020, # The year it started
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

# Plot INCIDENCE 2, Yearly incidences - a box plot
plot_incidences_by_year_boxplot <- function(df,
                                            plot_x = incidence_incidences_label,
                                            plot_fill = incidence_sex_label) {
  plot <- df %>%
    ggplot(aes(x = incidences_age, fill = sex)) +
    geom_boxplot(color = "black") +
    scale_fill_cis_qualitative(palette_sex) +
    scale_x_continuous(label = scales::label_comma()) +
    labs(
      x = paste0("\n", plot_x),
      fill = plot_fill
    )
  return(plot)
}

# Plot INCIDENCE 3, incidences_by_year_cancer_site
plot_incidences_by_year_cancer_site <- function(df, start_year, end_year) {
  df %>%
    ggplot(aes(x = year, y = incidences_age, fill = sex)) +
    # geom_line(colour = cis_colour_cancer) +
    geom_area(aes(colour = sex)) +
    facet_wrap(~cancer_site_short, ncol = 7) +
    scale_y_continuous(label = scales::label_comma()) +
    #     breaks = c(2000, 4000)) +
    scale_fill_cis_qualitative(palette_sex) +
    scale_colour_cis_qualitative(palette_sex) +
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

# Tables Start ----
# Table showing highest and lowest incidencdes and which years
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
      incidences = html(incidence_incidences_label),
      year = html(incidence_year_label),
    ) %>%
    tab_source_note(source_note = source_phs) %>%
    fmt_number(columns = incidences, decimals = 0)
}

# Modelling ----
# Model 1
build_model_year_incidences <- function(df) {
  model <- lm(year ~ incidences_age, df)
  auto <- autoplot(model, colour = "sex", data = incidences_by_year) +
    scale_colour_cis_qualitative(palette_sex) +
    labs(
      x = incidence_year_label, y = incidence_incidences_label,
      colour = incidence_sex_label
    )
  # diagnostics ?autoplot ?lm
  summary(model) # ?summary
  return(auto)
}
