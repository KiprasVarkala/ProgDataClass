#############################
#WORKING
#WORKING
#WORKING
#WORKING
#TEST
#############################

library(DT)
library(rio)
library(shiny)
library(shinydashboard)

ui <- dashboardPage(
    skin = "purple",
    dashboardHeader(title = "TAGA"),
    dashboardSidebar(
      sidebarMenu(
        menuItem("Import", tabName = "Import",  icon = icon("file-upload")),
        menuItem("Convert", tabName = "Convert", icon = icon("recycle")),
        menuItem("Export", tabName = "Export", icon = icon("file-download")),
        menuItem("FAQ & Feedback", tabName = "FAQ", icon = icon("question"))
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
    #header code credit: https://stackoverflow.com/questions/45176030/add-text-on-right-of-shinydashboard-header
    tabItems(
      tabItem(tabName = "Import",
              h2("Import CSV File", align = "center"),
              fileInput("file", "Choose CSV File",multiple = FALSE, accept = NULL,
                        width = NULL, buttonLabel = "Browse...",
                        placeholder = "No file selected"),
              actionButton("preview", "Preview Current Data Set"),
              fluidRow(
                mainPanel(
                  dataTableOutput("impOut")
                )
              )
      ),
      tabItem(tabName = "Convert",
              h2("Convert CSV File", align = "center"), h4("Choose your grading parameters", align = "center"),
             # fluidRow(
                #mainPanel(
                  selectInput("pointInput", label = h5("How many point bins would you like? (1-13)"), c(1:13)),
               #   par.Input <-lapply(1:13, function(x) {
                    #numericInput(paste0(1, x), paste0("Point", x ), value = 1, min = 1, max = 100)
                    #sliderInput("inSlider3", "Slider input 3:",
                      #          min = 1, max = 20, value = c(5, 15)),
                #    selectInput(paste0('a', x), paste0('SelectA', x),
                  #              choices = sample(LETTERS, 5))
                 # }),
               # )
          #    ),
           fluidRow(
             mainPanel(
               actionButton()
            )
            ),
            actionButton("convert", "Convert!"),
            actionButton("preview2", "Preview Converted Data Set")
      ),
      tabItem(tabName = "Export", align = "center",
              h2("Export CSV File"),
              actionButton("download", "Download converted file"),
              actionButton("hist", "Visualize your data")
      )
    )
    ))
   
server <- function(input,output,server) {
  # Return the requested dataset ----
  # Note that we use eventReactive() here, which depends on
  # input$update (the action button), so that the output is only
  # updated when the user clicks the button
  observeEvent(
    input$preview, 
    {
      data <- read.csv(input$file$datapath, fileEncoding = "UTF-16", sep = "\t", header = TRUE)
      output$impOut <- renderDataTable({
        datatable(data)
      })
    })
  renderPrint(
    {
  lapply(1:input$pointInput, function(x){
      wellPanel(
        numericInput(paste0(1, x), paste0("Point_", x ), label = h5("Minutes attended (less than or equal to)"), value = 1, min = 1, max = 100),
        numericInput(paste0(1, x), paste0("Point_", x ), label = h5("Amount of points awarded"), value = 1, min = 1, max = 100)
      )
  })
  })
}
shinyApp(ui,server)

#Credits

#html header: https://stackoverflow.com/questions/45176030/add-text-on-right-of-shinydashboard-header

#action button: https://stackoverflow.com/questions/55279042/displaying-input-file-by-user-in-r-shiny

#reading UTF-16 file encoding: https://stackoverflow.com/questions/50070113/r-3-5-read-csv-not-able-to-read-utf-16-csv-file
