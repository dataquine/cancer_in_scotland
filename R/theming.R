#
# File: theming.R
# Date: 2023-10-11
# Author: Lesley Duff
# Description:
#   User interface colours, fonts, theming etc
#

# How about a colour palette from cancer ribbons?
# https://www.medicalnewstoday.com/articles/323448#all-cancers

# Palette
# Need a pair of colours to indicate Cancer/Non-Cancer
# Suggest lavendar and gray?

library(ggplot2)

# Define Cancer in Scotland Colors ----

cis_cancer <- ""
cis_noncancer <- ""
# ga_purple <- "#8359AB"
# ga_yellow <- "#FFDE39"
# ga_gray <- "#827C78"
# ga_blue <- "#49B8F1"
# ga_brown <- "#B88262"
# ga_pink <- "#DC458E"

# read logo
# logo <- image_read("cancer_in_scotland_logo.png")

colour_major_grid_lines <- "#cbcbcb"

theme_cancer_in_scotland <- function(...) {
 # base_size = 12
 #  base_family = "Georgia"
 # base_line_size = base_size/23
 #  base_rect_size = base_size/24   
  
  theme_minimal(...) %+replace% 
    theme(
      # change stuff here
      # Legend format
      legend.position = "top",

      # Grid lines
      # Removes all minor gridlines and adds major y gridlines.
      panel.grid.minor = ggplot2::element_blank(),
      panel.grid.major.y = ggplot2::element_line(color = colour_major_grid_lines),
      panel.grid.major.x = ggplot2::element_blank(),

      # Blank background
      #  Remove the standard grey ggplot background colour from the plot
      panel.background = ggplot2::element_blank(),
      complete = TRUE
    )
}