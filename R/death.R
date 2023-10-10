#
# File: clean_nrs_death_causes.R
# Date: 2023-10-09
# Author: Lesley Duff
# Description:
#   Clean National Records Scotland datasets for causes of death
#

library(ggplot2)

death_all_causes <- "All causes"

get_death_all_causes = function(df){
  death_all_causes <- df %>%
    filter(cause == death_all_causes)
  
  return (death_all_causes)
}

get_death_selected_causes = function(df){
  death_selected_causes <- df %>%
    filter(cause == death_all_causes)
  
  return (death_selected_causes)
}

#ndividual_causes <- death_cause %>%
#  filter(cause != death_all_causes)


plot_causes <- function(df) {
  df %>%
    ggplot(aes(x = year, y = rate)) +
    geom_point(color = "darkorchid4") +
    #   geom_bar(aes(fill = cause), stat = "identity") +
    #geom_col(aes(fill = cause)) +
    # facet_wrap(~year) +
    geom_line(aes(x = year, y = rate, colour=cause), group =1)+
    
    labs(
      title = "Age-standardised death rates",
      subtitle = " All causes and certain selected causes, Scotland, 1994 to 2022",
      y = "Rate",
      x = "Year",
      caption = "National Records of Scotland"
    ) +
    theme_bw(base_size = 15)
}
#all_causes

#individual_causes