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

# Default to all of Scotland only and all sexes
get_screening_bowel_cancer_takeup <- function(df,
                                              filter_sex = c(),
                                              filter_area = c(),
                                              remove_scotland = FALSE,
                                              alphabetical_sex = TRUE,
                                              alphabetical_area = TRUE) {
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

plot_screening_bowel_cancer_takeup_scotland <- function(df) {
  plot <- df %>%
    #   ggplot(df, aes(x = uptake_pct, y = Population, fill = sex)) +
    #      geom_bar(data = subset(df, Gender == "Female"), stat = "identity") +
    #      geom_bar(data = subset(df, Gender == "Male"), stat = "identity") +
    #      scale_y_continuous(labels = paste0(as.character(c(seq(2, 0, -1), seq(1, 2, 1))), "m")) +
    #      coord_flip()

    #
    #    ggplot(mapping = aes(x = uptake_pct, fill = sex)) +

    #    # female histogram
    #    geom_histogram(data = df %>%
    #                     filter(sex == "Females"),
    #                #   breaks = seq(0,85,5),
    #                   colour = "white") +

    # male histogram (values converted to negative)
    #   geom_histogram(data = df %>% filter(sex == "Males"),
    #               #    breaks = seq(0,85,5),
    #                   mapping = aes(y = ..count..*(-1)),
    #                   colour = "white") +
    #    coord_flip()+

    # # adjust counts-axis scale
    # scale_y_continuous(limits = c(-100, 100),
    #                   breaks = seq(-100,0,100),
    #                  labels = abs(seq(-100, 0, 100)))


    mutate(uptake_pct = round(uptake_pct, digits = 2)) %>%
    ggplot(aes(sex, uptake_pct)) +
    geom_col(na.rm = TRUE) +
    # geom_text(aes(label = uptake_pct), vjust = 1.5,  colour = "white")+
    geom_hline(
      colour = "red",
      alpha = 0.7,
      linetype = 3,
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
      title = "Bowel Cancer Screening uptake",
      subtitle = "Completed a home bowel screening test",
      y = "Uptake",
      x = "Sex"
    ) +
    theme(
      axis.title = element_blank(),
      panel.grid = element_blank()
    )

  # scale_fill_continuous(labels = scales::label_comma())
  return(plot)
}
