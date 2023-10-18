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

# Purple: Pancreatic cancer, testicular cancer
# It is meant to signify survivors of cancer, as well
# Seems like this would be a good shout for the main palette theme

# Monochromatic palette based on purple
cis_colour_purple1 <- "#caaeca" # 000000
cis_colour_purple2 <- "#ad81ad" # 000000
cis_colour_purple3 <- "#800080" # ffffff
cis_colour_purple4 <- "#690267" # ffffff
cis_colour_purple5 <- "#52024f" # ffffff

cis_colour_officegreen <- "#008000" # Office Green
cis_colour_congressblue <- "#004580" # Congress Blue
cis_colour_olive <- "#808000" # Olive
cis_colour_limeade <- "#458000" # Limeade
cis_colour_lemon <- "#FFFF99" # Lemon

cis_colour_gray <- "#7F7F7F" # Gray (Grey)
cis_colour_battleship_gray <- "#848482" # Battleship Gray
cis_colour_lightgray <- "#D3D3D3"
cis_colour_darksgray = "#A9A9A9"
cis_colour_lightslategray <- "#778899"
cis_colour_darkslategray <- "#2F4F4F"

cis_colour_cancer <- cis_colour_purple3
cis_colour_noncancer <- cis_colour_congressblue

cis_colour_male <- cis_colour_darkslategray #cis_colour_lemon
cis_colour_female <- cis_colour_lightslategray #cis_colour_lightslategray


cis_palette_general <- c(
  cis_colour_purple3,
  cis_colour_lemon,
  cis_colour_congressblue,
  cis_colour_officegreen,
  cis_colour_olive,
  cis_colour_limeade,
  cis_colour_battleship_gray
)
cis_palette_sex <- c('All' = cis_colour_purple3, 
                     'All persons' = cis_colour_purple3, 
                     'Female' = cis_colour_female, 
                     'Females' = cis_colour_female, 
                     'Male' = cis_colour_male,
                 'Males' = cis_colour_male)

# 004580 # Congress Blue
# 808000 # Olive
# 458000 # Limeade

# 008000 Office Green
# 7F7F7F Gray (Grey)
# 848482 Battleship Gray

# read logo
# logo <- image_read("cancer_in_scotland_logo.png")

colour_major_grid_lines <- "#cbcbcb"

# Qualitative ----
scale_colour_cis_qualitative <- function(palette = cis_palette_general) {
  scale_color_manual(values = palette)
}

scale_fill_cis_qualitative <- function(palette = cis_palette_general) {
  scale_fill_manual(values = palette)
}

# Qualitative ----
scale_fill_cis_sequential <- function(low_color = cis_colour_purple1,
                                      high_color = cis_colour_purple5) {
  scale_fill_gradient(
    low = low_color,
    high = high_color
  )
}

# Diverging ----
scale_fill_cis_diverging <- function(low_color = cis_colour_purple1,
                                     medium_color = cis_colour_purple3,
                                     high_color = cis_colour_purple5) {
  scale_fill_gradient2(
    low = low_color,
    mid = medium_color,
    high = high_color
  )
}


theme_cancer_in_scotland <- function(...) {
  # base_size = 12
  #  base_family = "Georgia"
  # base_line_size = base_size/23
  #  base_rect_size = base_size/24

  theme_minimal(...) %+replace%
    theme(
      # change stuff here
      # Legend format
      legend.position = "bottom",

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
