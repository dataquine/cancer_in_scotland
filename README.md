# Cancer in Scotland

Final individual project of CodeClan DR22 Professional Data Analysis Course.

For this a fictional brief was created to simulate a request from the Scottish 
Government to take a high-level look at cancer statistics in Scotland.

## Project Brief
[Brief](documents/project_brief_cancer_in_scotland.pdf) (PDF).

## Analysis Report 
The main analysis report combines four different analysis reports together into one document for convenience.  
`analysis/0_analysis_report_cancer_in_scotland.html`

## Presentation 
>Lessons from death for life.

Remote presentation given at end of project to instructors and the rest of course cohort.  
Contains several of the plots from the analysis.  
[Cancer in Scotland](https://github.com/dataquine/cancer_in_scotland/blob/main/presentation/cancer_in_scotland_lesleyduff_codeclan_dr22_2023-10.pdf) (PDF).

## Cancer Risk Tool 
One project output is a prototype of an interactive tool to let the general public see cancer risk for different combinations of cancer type, age range and sex. 

This is leveraging the longitudinal dataset that covers over **two decades** of Scottish cancer incidence health data from 1997 and 2021.

The tool runs in R as an R Shiny Interactive Document.

To run the tool locally using R Studio:

1. clone this project
2. in R Studio open the file `cancer_risk_tool/index.Rmd`
3. click "Run Document"
4. Choose an "Age Range", "Sex", "Type of Cancer" and a "Number of Results"
You should then see a table of how many incidences have been recorded.

Here's a screenshot of how it should look.

![](analysis/images/screenshot_cancer_risk_tool.png "Demo of Cancer Risk Tool - Show Cancer Site by Age Range and Sex")

* **Data**   
All the data required to regenerate the analysis reports should be available if 
you clone this repository. Report data is in `data_clean`. If you need to recreate 
the project from scratch run the cleaning scripts in order in `cleaning_scripts`

This project contains data from:

* [National Records of Scotland](https://www.nrscotland.gov.uk/),  
© Crown Copyright 2023
* [Public Health Scotland](),  
Contains public sector information licensed 
under the [Open Government Licence v3.0](https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/).
