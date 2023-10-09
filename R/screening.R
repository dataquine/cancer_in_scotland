#
# File: screening.R
# Date: 2023-10-09
# Author: Lesley Duff
# Description:
#   Helper functions to manipulate cancer screening information
#

screening_filter_persons_scotland <- "All persons"
screening_filter_persons_male <- "Males"
screening_filter_persons_female <- "Females"

screening_filter_area_scotland <- "Scotland"

# Default to all of Scotland only
get_screening_bowel_cancer_takeup <- function(df,
                                              filter_persons = c(screening_filter_persons_scotland),
                                              filter_area = c(screening_filter_area_scotland)) {
  bowel_cancer_takeup <- df %>%
    filter(persons %in% filter_persons) %>%
    filter(area %in% filter_area)
  return(bowel_cancer_takeup)
}

get_screening_bowel_cancer_takeup_kp1 <- function(df
    ){
  screening_bowel_cancer_takeup_kp1 <- get_screening_bowel_cancer_takeup(df,
    filter_persons = c(screening_filter_persons_scotland, 
                       screening_filter_persons_male,
                       screening_filter_persons_female)) %>% 
    select(-area) %>% 
    # all scotland so remove redundant column
    
    rename(sex = persons)
  return (screening_bowel_cancer_takeup_kp1)
}