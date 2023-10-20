#
# File: waiting_times.R
# Date: 2023-10-18
# Author: Lesley Duff
# Description:
#   Helper functions to manipulate cancer waiting times information
#

library(scales)
library(ggplot2)

source(here::here("R/phs_data_info.R"))

# Plot number of referrals
# Waiting Times
cancer_waiting_times_number_referrals_plot_filepath <- 
  "images/plot/plot_cancer_waiting_times_number_referrals.png"

cancer_waiting_times_targets_met_plot_filepath <-
  "images/plot/plot_cancer_waiting_times_targets_met.png"

waiting_times_all_standards_totals_title <-
  "Cancer Waiting Times in Scotland"
waiting_times_all_standards_totals_subtitle <- "Number of Referrals: "
waiting_times_all_standards_totals_xaxis <- "Year"
waiting_times_all_standards_totals_yaxis <- "Referrals"
waiting_times_all_standards_totals_referral_type <- "Type of Referral"

plot_all_standards_totals_filtered <- function(df, plot_title = waiting_times_all_standards_totals_title,
                                               plot_subtitle = waiting_times_all_standards_totals_subtitle,
                                               plot_x = waiting_times_all_standards_totals_xaxis,
                                               plot_y = waiting_times_all_standards_totals_yaxis,
                                               plot_colour = waiting_times_all_standards_totals_referral_type,
                                               show_covid = TRUE) {
  year_oldest <- min(as.numeric(as.character(df$year_new)))
  year_newest <- max(as.numeric(as.character(df$year_new)))
  
  plot <- df %>%
    mutate(referrals_names = str_replace_all(referrals_names, "_", " "),
           referrals_names = str_replace_all(referrals_names, "total ", ""),
          referrals_names = str_replace_all(referrals_names, " referrals", "")
           ) %>%
    ggplot(aes(
      x = year_new, y = referrals_values,
      colour = referrals_names, group = referrals_names
    )) +
    geom_line(linewidth=2) +
    geom_point(size=3) +
    scale_y_continuous( label = scales::label_comma(), limits=c(0,NA)) + 
    theme(axis.ticks.x = ggplot2::element_line())+
    labs(
      title = plot_title,
      subtitle = paste0(plot_subtitle, year_oldest, "-", year_newest),
      x = paste0("\n", plot_x),
      y = paste0(plot_y, "\n"),
      caption = source_phs,
      colour = plot_colour
    ) +
    scale_colour_cis_qualitative() 

  return(plot)
}

plot_waitiing_times_years_percent_treated <- function(df,
                                                      target = 95,
                                                      plot_title = "Waiting Time Targets",
                                                      plot_subtitle = "",
                                                      plot_x = "Year",
                                                      plot_y = "% Treated within Target",
                                                      plot_fill = "Treament Target") {
  year_oldest <- min(as.numeric(as.character(df$year_new)))
  year_newest <- max(as.numeric(as.character(df$year_new)))
  
  plot <- df %>%
    mutate(
      colourgroup = case_when(
        (percent_values >= target) ~ cis_colour_officegreen,
        (percent_values < target) ~ cis_colour_darksgray,
        .default = "black"
      ),
      percent_names = str_replace_all(percent_names, "_", " "),
      percent_names = str_replace_all(percent_names, "pct ", "")
    ) %>%
    ggplot(aes(x = year_new, y = percent_values, colour = "white")) +
    geom_col(aes(fill = colourgroup), colour = "black") +
    facet_wrap(~percent_names) +
    scale_y_continuous( label = scales::label_percent(scale=1)) + 
    scale_fill_manual(
      labels = c("Met", "Missed"),
      values = c(
        cis_colour_officegreen, cis_colour_darksgray
      )
    ) +
    geom_hline(
      yintercept = 95, linetype = "dashed", linewidth = 1,
      colour = "red"
    ) + # ?geom_hline
    theme(
      axis.text.x = element_text(angle = 45, hjust = 1),
      axis.ticks.x = ggplot2::element_line()
    ) +
    labs(
      title = plot_title,
      subtitle = paste0(plot_subtitle, year_oldest, "-", year_newest),
      
      x = paste0("\n", plot_x),
      y = paste0(plot_y, "\n"),
      fill = plot_fill
    )
  return(plot)
}
