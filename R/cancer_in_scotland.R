#
# File: cancer_in_scotland.R
# Date: 2023-10-15
# Author: Lesley Duff
# Description:
#   Project-wide variables/functions
#

library(here)

enable_plot_saving <- FALSE

do_cis_plot <- function(cis_plot,
                    save_path = "",
                    save_plot = enable_plot_saving) {
  print(cis_plot)
  if (save_plot) {
    ggsave(
      here::here(save_path),
      cis_plot
    )
  }
}
