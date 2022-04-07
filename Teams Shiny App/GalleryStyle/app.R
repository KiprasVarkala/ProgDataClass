#############################
#WORKING
#WORKING
#WORKING
#WORKING
#NOT
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
              h2("Import CSV File"),
              fileInput("file", "Choose CSV File",
                        accept = c(
                          "csv",
                          "text/csv",
                          "text/comma-separated-values,text/plain")),
              #actionButton("preview", "Preview Current Data Set"),
              fluidRow(
                mainPanel(
                  tableOutput("Import")
                )
              )
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
  
  # Return the requested dataset ----
  # Note that we use eventReactive() here, which depends on
  # input$update (the action button), so that the output is only
  # updated when the user clicks the button
  #file.Input <- eventReactive(input$preview,input$file, ignoreNULL = FALSE)
  
  # Generate a summary of the dataset ----
  #output$Import <- renderTable({
  #  fInput <- file.Input()
  #  head(fInput)
  
  output$Import <- renderTable(
    head(read.csv(input$file$datapath)
  )
  )
}

shinyApp(ui,server)
