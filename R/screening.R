#
# File: screening.R
# Date: 2023-10-09
# Author: Lesley Duff
# Description:
#   Helper functions to manipulate cancer screening information
#

library(dplyr)
library(ggplot2)
library(scales)

screening_filter_sex_scotland <- "All persons"
screening_filter_sex_male <- "Males"
screening_filter_sex_female <- "Females"

screening_filter_area_scotland <- "Scotland"

screening_bowel_cancer_uptake_target = 60

# Plot
screening_bowel_cancer_uptake_plot_filepath = "images/plot/plot_screening_bowel_cancer_uptake.png"

screening_bowel_cancer_uptake_plot_title = "Bowel Cancer Screening uptake"
screening_bowel_cancer_uptake_plot_subtitle = "Completed a home bowel screening test May 2020 to April 2022"
screening_bowel_cancer_uptake_plot_x = "Uptake"
screening_bowel_cancer_uptake_plot_y ="Sex"

# Default to all of Scotland only and all sexes
get_screening_bowel_cancer_takeup <- function(df,
                                              filter_sex = c(),
                                              filter_area = c(),
                                              remove_scotland = FALSE,
                                              alphabetical_sex = TRUE,
                                              alphabetical_area = TRUE,
                                              order_by_pct = FALSE) {
  screening_bowel_cancer_takeup <- df

  if (length(filter_sex) > 0) {
    screening_bowel_cancer_takeup <- screening_bowel_cancer_takeup %>%
      filter(sex %in% filter_sex)
  }
  if (length(filter_area) > 0) {
    screening_bowel_cancer_takeup <- screening_bowel_cancer_takeup %>%
      filter(area %in% filter_area)
  }
  if (remove_scotland == TRUE) {
    screening_bowel_cancer_takeup <- screening_bowel_cancer_takeup %>%
      filter(!(area %in% screening_filter_area_scotland))
  }
  if (alphabetical_sex == TRUE) {
    screening_bowel_cancer_takeup <- screening_bowel_cancer_takeup %>%
      arrange(sex)
  }
  if (alphabetical_area == TRUE) {
    screening_bowel_cancer_takeup <- screening_bowel_cancer_takeup %>%
      arrange(area)
  }
  if (order_by_pct) {
    screening_bowel_cancer_takeup <- screening_bowel_cancer_takeup %>%
      arrange(uptake_pct)
  }
  # View(screening_bowel_cancer_takeup)
  return(screening_bowel_cancer_takeup)
}

get_screening_bowel_cancer_takeup_scotland <- function(df) {
  screening_bowel_cancer_takeup_scotland <- get_screening_bowel_cancer_takeup(
    df,
    remove_scotland = FALSE
  ) %>%
    # Only Show results for whole of Scotland
    filter(area == screening_filter_area_scotland)
  return(screening_bowel_cancer_takeup_scotland)
}

get_screening_bowel_cancer_takeup_kpi1 <- function(df) {
  screening_bowel_cancer_takeup_kpi1 <- get_screening_bowel_cancer_takeup(
    screening_bowel_cancer_takeup_all,
    # filter_sex = c("Females","Males"),
    filter_sex = c("All persons"),
    # filter_area = c("Grampian", "Fife"),
    remove_scotland = TRUE
  )

  #  screening_bowel_cancer_takeup_kp1 <- get_screening_bowel_cancer_takeup(df,
  #    filter_sex = c(
  #      screening_filter_sex_scotland,
  #      screening_filter_sex_male,
  #      screening_filter_sex_female
  #    )
  #  ) %>%
  # select(-area) # %>%
  # all scotland so remove redundant column

  return(screening_bowel_cancer_takeup_kpi1)
}

plot_screening_bowel_cancer_takeup_scotland <- function(df, 
plot_title = screening_bowel_cancer_uptake_plot_title,
plot_subtitle = screening_bowel_cancer_uptake_plot_subtitle,
plot_x = screening_bowel_cancer_uptake_plot_x,
plot_y = screening_bowel_cancer_uptake_plot_y) {
  plot <- df %>%
    mutate(uptake_pct = round(uptake_pct, digits = 2)) %>%
    ggplot(aes(sex, uptake_pct, fill=sex)) +
    geom_col(fill = cis_colour_cancer) +
    geom_hline(
      colour = "red",
      alpha = 0.7,
      linetype = 3,
      linewidth = 2,
      yintercept = screening_bowel_cancer_uptake_target
    )+
    geom_text(
      mapping = aes(label = paste(round(uptake_pct, 1),"%")),
      position = position_dodge(width = 0.7),
      vjust = 1.5,
      size = 5,
      fontface = "bold",
      colour = "white"
    )+
    scale_y_continuous(
      label = scales::label_percent(scale = 1),
      limits = c(0, 100)
    ) +
    labs(
      title = plot_title,
      subtitle = plot_subtitle,
      y = paste0(plot_x,"\n"),
      x = paste0("\n", plot_y),
      caption = source_phs
    ) +
    #scale_fill_cis_qualitative(cis_palette_sex)+
    guides(fill = "none") 
    theme(
      axis.title = element_blank(),
      panel.grid = element_blank(),
    )

  # scale_fill_continuous(labels = scales::label_comma())
  return(plot)
}
