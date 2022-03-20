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

ui <- dashboardPage(
  fluidPage(
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
              h2("Import CSV File"),
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
                tableOutput("contents"),
                
                # Input: Specify the number of observations to view ----
                numericInput("obs", "Number of observations to view:", 10),
                
                # Include clarifying text ----
                helpText("Note: while the data view will show only the specified",
                         "number of observations, the summary will still be based",
                         "on the full dataset."),
                
                # Input: actionButton() to defer the rendering of output ----
                # until the user explicitly clicks the button (rather than
                # doing it immediately when inputs change). This is useful if
                # the computations required to render output are inordinately
                # time-consuming.
                actionButton("update", "Update View"),
                
                # Output: Header + table of distribution ----
                h4("Observations"),
                tableOutput("Contents")
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
)

server <- function(input,output,server){
  # Return the requested dataset ----
  # Note that we use eventReactive() here, which depends on
  # input$update (the action button), so that the output is only
  # updated when the user clicks the button
  datasetInput <- eventReactive(input$update, {
    switch(input$dataset,
           "rock" = rock,
           "pressure" = pressure,
           "cars" = cars)
  }, ignoreNULL = FALSE)
  
  # Show the first "n" observations ----
  # The use of isolate() is necessary because we don't want the table
  # to update whenever input$obs changes (only when the user clicks
  # the action button)
  output$view <- renderTable({
    head(datasetInput(), n = isolate(input$obs))
  })
  
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
  # You can access the value of the widget with input$num, e.g.
  # output$value <- renderPrint({ input$num })
  
  # Our dataset
 # data <- mtcars
  
#  output$downloadData <- downloadHandler(
#    filename = function() {
#      paste("data-", Sys.Date(), ".csv", sep="")
#    },
#    content = function(file) {
#      write.csv(data, file)
#    }
#  )
  
}

shinyApp(ui,server)