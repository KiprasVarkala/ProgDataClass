#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/

#############################################################################################

library(shiny)
library(shinydashboard)

## Only run examples in interactive R sessions
if (interactive()) {
  
  ui <- fluidPage(
    sidebarLayout(
      sidebarPanel(
        fileInput("file1", "Choose CSV File",
                  accept = c(
                    "text/csv",
                    "text/comma-separated-values,text/plain",
                    ".csv")
        ),
        tags$hr(),
        checkboxInput("header", "Header", TRUE)
      ),
      mainPanel(
        tableOutput("contents")
      )
    )
  )
  
  server <- function(input, output) {
    output$contents <- renderTable({
      # input$file1 will be NULL initially. After the user selects
      # and uploads a file, it will be a data frame with 'name',
      # 'size', 'type', and 'datapath' columns. The 'datapath'
      # column will contain the local filenames where the data can
      # be found.
      inFile <- input$file1
      
      if (is.null(inFile))
        return(NULL)
      
      read.csv(inFile$datapath, header = input$header)
    })
  }
  
  shinyApp(ui, server)
}

#UI#################
library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(title = "TAGA"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Import", tabName = "Import",  icon = icon("file-upload")),
      menuItem("Convert", tabName = "Convert"),
      menuItem("Export", tabName = "Export")
    )
  ),
  dashboardBody(
    tags$head(tags$style(HTML(
      '.myClass { 
        font-size: 20px;
        line-height: 50px;
        text-align: left;
        font-family: "Helvetica Neue",Helvetica,Arial,sans-serif;
        padding: 0 15px;
        overflow: hidden;
        color: white;
      }
    '))),
    tags$script(HTML('
      $(document).ready(function() {
        $("header").find("nav").append(\'<span class="myClass"> Teams Attendance Grading Assistant </span>\');
      })
     ')),
    #header code credit: https://stackoverflow.com/questions/45176030/add-text-on-right-of-shinydashboard-header
    tabItems(
      tabItem(tabName = "Import",
              h2("Import CSV File")
      ), fileInput("file", label = h3("File input")
      ),
      tabItem(tabName = "Convert",
              h2("Convert CSV File"),
              # Copy the line below to make a number input box into the UI.
              numericInput("num", label = h3("Numeric input"), value = 1),
              
              hr(),
              fluidRow(column(3, verbatimTextOutput("value")))
      ),
      tabItem(tabName = "Export",
              h2("Export CSV File"),
              h4("Output from renderPrint:"),
              textOutput("other_val_show"),
              h4("Download Button: "),
              downloadButton("downloadData", "Download CSV"))
    )
  )
)

#server#############

# You can access the value of the widget with input$file, e.g.
output$value <- renderPrint({
  str(input$file)
})

# Reactive value for selected dataset ----
datasetInput <- reactive({
  switch(input$dataset,
         "rock" = rock,
         "pressure" = pressure,
         "cars" = cars)
})

# Table of selected dataset ----
output$table <- renderTable({
  datasetInput()
})

# Downloadable csv of selected dataset ----
output$downloadData <- downloadHandler(
  filename = function() {
    paste(input$dataset, ".csv", sep = "")
  },
  content = function(file) {
    write.csv(datasetInput(), file, row.names = FALSE)
  }
)
#############################################################################
#############################################################################
#############################
#WORKING
#WORKING
#WORKING
#WORKING
#############################


library(shiny)
library(shinydashboard)

ui <- dashboardPage(skin = "purple",
                    dashboardHeader(title = "TAGA"),
                    dashboardSidebar(
                      sidebarMenu(
                        menuItem("Import", tabName = "Import",  icon = icon("file-upload")),
                        menuItem("Convert", tabName = "Convert", icon = icon("recycle")),
                        menuItem("Export", tabName = "Export", icon = icon("file-download"))
                      )
                    ),
                    dashboardBody(
                      tags$head(tags$style(HTML(
                        '.myClass { 
        font-size: 20px;
        line-height: 50px;
        text-align: left;
        font-family: "Bookman Old Style",Bookman Old Style,Arial,sans-serif;
        padding: 0 15px;
        overflow: hidden;
        color: white;
      }
    '))),
    tags$script(HTML('
      $(document).ready(function() {
        $("header").find("nav").append(\'<span class="myClass"> Teams Attendance Grading Assistant </span>\');
      })
     ')),
    #header code credit: https://stackoverflow.com/questions/45176030/add-text-on-right-of-shinydashboard-header
    tabItems(
      tabItem(tabName = "Import",
              h2("Import CSV File")
      ),
      tabItem(tabName = "Convert",
              h2("Convert CSV File")
      ),
      tabItem(tabName = "Export",
              h2("Export CSV File")
      )
    )
                    ))

server <- function(input,output,server) {
  
}

shinyApp(ui,server)