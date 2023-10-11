#
# File: clean_nrs_death_causes.R
# Date: 2023-10-09
# Author: Lesley Duff
# Description:
#   Clean National Records Scotland datasets for causes of death
#

library(ggplot2)
library(scales)

death_all_cause_value <- "All causes"
nrs_caption <- "Data: National Records of Scotland"

plot_death_cause_title <- "Death rates for all causes"
plot_death_cause_subtitle <- "Scotland. Age-standardised"
plot_death_cause_xaxis_title <- "Year"
plot_death_cause_yaxis_title <- "Rate (proporton)"

get_death_all_cause <- function(df) {
  death_all_cause <- df %>%
    filter(cause == death_all_cause_value)

  return(death_all_cause)
}

get_death_selected_cause <- function(df) {
  death_selected_cause <- df %>%
    filter(cause != death_all_cause_value)

  return(death_selected_cause)
}

plot_death_cause <- function(df, plot_title = plot_death_cause_title,
                             plot_subtitle = plot_death_cause_subtitle,
                             plot_xaxis_title = plot_death_cause_xaxis_title,
                             plot_yaxis_title = plot_death_cause_yaxis_title,
                             plot_year_start = 1994,
                             plot_year_end = 2022,
                             plot_year_by = 2) {
  plot <- df %>%
    mutate(cause = str_trunc(cause, 20)) %>%
    ggplot(aes(x = year, y = rate)) +
    geom_col(aes(fill = cause), na.rm = TRUE, position = "fill") +
    # geom_point(color = "darkorchid4", na.rm = TRUE) +
    #   geom_bar(aes(fill = cause), stat = "identity") +
    # geom_col(aes(fill = cause)) +
    # facet_wrap(~year) +
    # geom_line(aes(x = year, y = rate, colour = cause), group = 1, na.rm = TRUE) +
    scale_y_continuous(label = scales::label_comma(scale = 1)) +
    scale_x_continuous(breaks = seq(
      from = plot_year_start,
      to = plot_year_end,
      by = plot_year_by
    )) +
    labs(
      title = plot_title,
      subtitle = plot_subtitle,
      y = plot_yaxis_title,
      x = plot_xaxis_title,
      caption = nrs_caption
    ) +
    # theme_bw(base_size = 15)
    theme(legend.position = "bottom")
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
plot_death_rate_cancer <- function(df) {
  plot <- df %>%
    # Basic piechart with percentage labels
    ggplot(aes(x = "", y = percent, fill = category)) +
    geom_col(color = "white", width = 1) +
    geom_label(aes(label = percent_labels),
      position = position_stack(vjust = 0.5),
      show.legend = FALSE # hide the 'a' symbol
    ) +
    #   scale_fill_manual(values = c("red", "yellow")) +
    coord_polar(theta = "y") + # ?coord_polar
    theme(
      axis.text.x = element_blank(), # remove 25/50 etc
      axis.title = element_blank(), # remove percent
      panel.grid = element_blank() # remove gridlines
      )
  
    labs(
      title = "Death rate from cancer as percentage all causes",
      x = "",
      y = "Percent",
      fill = ""
    )
  return(plot)
}
