#
# File: clean_nrs_death_causes.R
# Date: 2023-10-09
# Author: Lesley Duff
# Description:
#   Clean National Records Scotland datasets for causes of death
#

library(ggplot2)
library(scales)

# Attribution to NRS for the data source
plot_source_nrs <- "Data Source: National Records of Scotland"

death_all_cause_simple_value <- "All causes"
death_cancer_cause_simple_value <- "Cancer"

# Plot: cancer death against death from all causes
plot_death_cause_simple_title <- "Death rate from cancer as percentage all causes"
plot_death_cause_simple_subtitle <- ""
plot_death_cause_simple_caption <- plot_source_nrs

# Plot: cancer death against all causes
plot_death_cause_simple_all_causes_title <- "Death rate from cancer - all causes"
plot_death_cause_simple_all_causes_subtitle <- "Scotland. Age-standardised"
plot_death_cause_simple_all_causes_caption <- plot_source_nrs
plot_death_cause_simple_all_causes_xaxis_title <- "Year"
plot_death_cause_simple_all_causes_yaxis_title <- "Death rate (proportion)"

plot_year_covid <- 2020

get_death_all_cause_simple <- function(df) {
  death_all_cause_simple <- df %>%
    filter(cause_simple == death_all_cause_simple_value)

  return(death_all_cause_simple)
}

get_death_selected_cause_simple <- function(df) {
  death_selected_cause_simple <- df %>%
    filter(cause_simple != death_all_cause_simple_value)

  return(death_selected_cause_simple)
}

plot_death_cause_simple <- function(df, plot_title = plot_death_cause_simple_all_causes_title,
                                    plot_subtitle = plot_death_cause_simple_all_causes_subtitle,
                                    plot_caption = plot_death_cause_simple_all_causes_caption,
                                    plot_xaxis_title = plot_death_cause_simple_all_causes_xaxis_title,
                                    plot_yaxis_title = plot_death_cause_simple_all_causes_yaxis_title,
                                    plot_year_start = 1994,
                                    plot_year_end = 2022,
                                    plot_year_by = 2) {
  plot <- df %>%
    mutate(
      highlight = case_when(
        cause_simple == death_cancer_cause_simple_value ~ "yes",
        TRUE ~ "no"
      ),
      alpha_cancer = case_when(
        cause_simple == death_cancer_cause_simple_value ~ TRUE,
        TRUE ~ FALSE
      )
    ) %>%
    ggplot(aes(x = year, y = rate, colour = highlight, alpha = alpha_cancer)) +
    geom_col(aes(fill = cause_simple), position = "fill") +
    scale_colour_manual(values = c("no" = "white", "yes" = "black"), 
                        guide = "none") +
    scale_alpha_manual(values = c("TRUE" = 1, "FALSE" = 0.9), guide = "none") +

    #  case_match(
    #    highlight == "yes" ~ geom_text(),
    #    .default = FALSE

    # )+
    #    if (highlight) {
    #   geom_text(aes(y = rate, label = highlight ,
    #                group = factor(cause_simple),
    #               #color = highlight
    #              )) +
    # }


    # Show a line where COVID-19 starter
    geom_vline(
      xintercept = plot_year_covid,
      colour = "red",
      alpha = 0.7,
      linetype = 3
    ) + # ?geom_vline
    # annotate(geom="text", x=plot_year_covid,
    #           y = 400,
    #         label="start of \nCOVID-19",
    #        #x=as.Date("2020-03-16"), y = 150, label="state of\nemergency",
    #       col = "dodgerblue4") +

    scale_y_continuous(label = scales::label_comma(scale = 1)) +
    scale_x_continuous(breaks = seq(
      from = plot_year_start,
      to = plot_year_end,
      by = plot_year_by
    )) +
    labs(
      title = plot_title,
      subtitle = plot_subtitle,
      caption = plot_caption,
      y = plot_yaxis_title,
      x = plot_xaxis_title,
      fill = ""
    ) +
    theme(
      panel.grid.major.y = ggplot2::element_blank(),
      axis.text.y = element_blank()
      #  axis.ticks.x = ggplot2::element_line()
      # ggplot2::element_blank(),
    )
  # theme_bw(base_size = 15)
  # theme(legend.position = "bottom")
  # View(plot_df)
  return(plot)
}

# Filter death cause table by cause_simple and year
get_death_by_year_cause_simple <- function(df, filter_cause_simple, filter_year) {
  death_by_year_cause_simple <- df %>%
    filter(
      cause_simple == filter_cause_simple,
      year == filter_year
    ) %>%
    pull(rate)
  return(death_by_year_cause_simple)
}

# Death rate from cancer pie chart ####
plot_death_rate_cancer <- function(df, plot_title = plot_death_cause_simple_title,
                                   plot_subtitle = plot_death_cause_simple_subtitle,
                                   plot_caption = plot_death_cause_simple_caption) {
  plot <- df %>%
    # Basic piechart with percentage labels
    ggplot(aes(x = "", y = percent, fill = category)) +
    #  geom_col(color = "white", width = 10) +
    geom_col() +
    geom_label(aes(label = percent_labels),
      position = position_stack(vjust = 0.5),
      show.legend = FALSE # hide the 'a' symbol
    ) +
    # TODO come back with custom palette for cancer/con-cancer
    #   scale_fill_manual(values = c("red", "yellow")) +
    coord_polar(theta = "y") + # ?coord_polar
    theme(
      axis.text.x = element_blank(), # remove 25/50 etc
      axis.title = element_blank(), # remove percent
      axis.ticks = ggplot2::element_blank(),
      panel.grid = element_blank() # remove gridlines
    ) +
    labs(
      title = plot_title,
      subtitle = plot_subtitle,
      caption = plot_caption,
      x = "",
      y = "Percent",
      fill = ""
    )
  return(plot)
}
