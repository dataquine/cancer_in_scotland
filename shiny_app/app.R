#
# File: app.R
# Date: 2023-10-09
# Author: Lesley Duff
# Description:
#   Cancer in Scotland shiny app
#

library(ggplot2)
library(shiny)
library(viridis) # for colourblindness


source("global.R")

theme_set(theme_minimal())


# Define UI for random distribution app ----
ui <- fluidPage(

  # App title ----
  titlePanel(app_title),

  # Sidebar layout with input and output definitions ----
  sidebarLayout(

    # Sidebar panel for inputs ----
    sidebarPanel(
    ),

    # Main panel for displaying outputs ----
    mainPanel(

      # Output: Tabset w/ plot, summary, and table ----
      tabsetPanel(
        type = "tabs",
#        tabPanel(
#          tab_home_title,
#          h1(tab_home_title)
#        ),
        # Screening Bowel Cancer Tab ----
        tabPanel(
          tab_screening_title,
          h1(tab_screening_title),
          h2(bowel_cancer_title),
          h3(plot_bowel_cancer_uptake_title),
          plotOutput("plotScreeningBowelCancer"),
          hr(),
          DT::dataTableOutput("tableScreeningBowelCancer"),
          # Button
          downloadButton("downloadScreeningBowelCancer", download_title)
        ),
        tabPanel(
          tab_about_title,
          h1(tab_about_title),
          verbatimTextOutput("about")
        ),
      )
    )
  )
)

# Define server logic for random distribution app ----
server <- function(input, output) {
  # Reactive expression to generate the requested distribution ----
  # This is called whenever the inputs change. The output functions
  # defined below then use the value computed from this expression
  
  
  screening_bowel_cancer <- reactive({
    # screening_bowel_cancer_takeup
    screening_bowel_cancer_takeup_health_boards %>% 
      arrange(area)
  })

  # MINE =====
  # Generate an HTML table view of the data ----
  output$tableScreeningBowelCancer <- DT::renderDataTable({
    screening_bowel_cancer() %>%
      mutate(uptake_pct = format(round(uptake_pct, digits = 2), nsmall = 2)) %>%
      # Todo
      rename("uptake (%)"
        # eval(plot_bowel_cancer_uptake_percent_title)
        = uptake_pct
      )
  })


  output$plotScreeningBowelCancer <- renderPlot({
    orderedData <- screening_bowel_cancer() #%>%
      
      orderedData %>%
    #  arrange(desc(area)) %>% 
      ggplot(aes(x = area, y = uptake_pct)) +
      geom_col(aes(x = area, y = uptake_pct, fill = sex), position = "dodge") +
      coord_flip() +
      scale_fill_viridis(discrete = TRUE) +
      labs(
        x = plot_bowel_cancer_health_board_title,
        y = plot_bowel_cancer_percent_title,
        fill = plot_bowel_cancer_sex_title
      )
  })

  # Generate a summary of the data ----
  output$about <- renderPrint({
    summary(screening_bowel_cancer())
  })

  # Downloadable csv of selected dataset ----
  output$downloadScreeningBowelCancer <- downloadHandler(
    filename = function() {
      # paste(input$dataset, ".csv", sep = "")
      phs_screening_bowel_uptake_filename
      # paste("yadda", ".csv", sep = "")
    },
    content = function(file) {
      write.csv(screening_bowel_cancer(), file, row.names = FALSE)
    }
  )
}

# Create Shiny app ----
shinyApp(ui, server)
