#############################
#WORKING
#WORKING
#WORKING
#WORKING Project Start
#############################

library(DT)
library(rio)
library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  skin = "green",
  dashboardHeader(title = "Projects"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("1. Shiny App", tabName = "proj1",  icon = icon("file-code")),
      menuItem("2. File Upload", tabName = "proj2", icon = icon("file-upload")),
      menuItem("3. Visualization", tabName = "proj3", icon = icon("image")),
      menuItem("4. Data Analysis Report", tabName = "proj4", icon = icon("chart-bar"))
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
        $("header").find("nav").append(\'<span class="myClass"> Dashboard For All Prog-Data Class Projects </span>\');
      })
     ')),
    #header code credit: https://stackoverflow.com/questions/45176030/add-text-on-right-of-shinydashboard-header
    #header code credit: https://stackoverflow.com/questions/45176030/add-text-on-right-of-shinydashboard-header
    tabItems(
      tabItem(tabName = "proj1",
              h2("How to Compile your Work into One Simple App Using Shiny", align = "center"),
              h3("(Tutorial)", align = "center"),
              tags$hr(style=
                        "border-color: black;
                         border-width: 2px;")
      ),
      tabItem(tabName = "proj2",
              h2("How to Implement a File Upload Widget with a Preview Feature.", align = "center"),
              h3("(Tutorial)", align = "center"),
              tags$hr(style=
                        "border-color: black;
                         border-width: 2px;")
      ),
      tabItem(tabName = "proj3",
              h2("Visualization", align = "center"),
              h3("(Shiny App)", align = "center"),
              tags$hr(style=
                        "border-color: black;
                         border-width: 2px;")
      ),
      tabItem(tabName = "proj4",
              h2("Data Analysis Report", align = "center"),
              h3("(Data Analysis Report)", align = "center"),
              tags$hr(style=
                        "border-color: black;
                         border-width: 2px;"),
              h4("Data analysis report: 
              Explore and analyze a dataset of interest to you to derive useful or 
interesting insights. You must demonstrate the skills you are learning in the course (data 
wrangling, data visualization, modeling, web scraping, text mining, etc.) and present one or more 
key insights that can be learned from the data. Your project should demonstrate good habits with 
respect to reproducibility, clear coding style and logic, and effective visualization and 
communication.
You may choose (or construct) any dataset of interest to you. If you are involved in research, 
please feel free to use data from these projects. Otherwise, there are many datasets available 
online you can work with, or you can build a dataset from the web yourself. We will explore 
portfolio piece ideas and potential data sources throughout the semester. ")
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
      data <- read.csv(input$file$datapath, fileEncoding = "UTF-16", sep = "\t", header = FALSE)
      output$impOut <- renderDataTable({
        datatable(data)
      })
    })
}

shinyApp(ui,server)

#Credits

#html header: https://stackoverflow.com/questions/45176030/add-text-on-right-of-shinydashboard-header

#action button: https://stackoverflow.com/questions/55279042/displaying-input-file-by-user-in-r-shiny

#reading UTF-16 file encoding: https://stackoverflow.com/questions/50070113/r-3-5-read-csv-not-able-to-read-utf-16-csv-file