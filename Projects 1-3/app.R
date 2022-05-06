#############################
#Complete!
#############################

library(DT)
library(mosaic)
library(rio)
library(shiny)
library(shinydashboard)
library(tidytuesdayR)
library(dplyr)
library(markdown)


#Global
tuesdata <- tidytuesdayR::tt_load(2021, week = 41)

nurses <- na.omit(tuesdata$nurses)

nurses <- 
  nurses %>% 
  select(c(3, 5, 6, 7)) %>% 
  filter_at(vars(`Total Employed RN`, `Hourly Wage Avg`, `Hourly Wage Median`, `Annual Salary Avg`), all_vars(!is.na(.)))

ui <- dashboardPage(
  skin = "green",
  dashboardHeader(title = "Projects"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("1. Shiny App", tabName = "proj1",  icon = icon("file-code")),
      menuItem("2. File Upload", tabName = "proj2", icon = icon("file-upload")),
      menuItem("3. Data Analysis Report", tabName = "proj3", icon = icon("chart-bar"))
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
    tabItems(
      tabItem(tabName = "proj1",
              h2("How to Compile your Work into One Simple App Using Shiny Dashboard", align = "center"),
              h3("(Tutorial)", align = "center"),
              tags$hr(style=
                        "border-color: black;
                         border-width: 2px;"),
              includeMarkdown("proj1_Shiny_Tutorial.md")
      ),
      tabItem(tabName = "proj2",
              h2("How to Implement a File Upload Widget with a Preview Feature.", align = "center"),
              h3("(Tutorial)", align = "center"),
              tags$hr(style=
                        "border-color: black;
                         border-width: 2px;"),
              includeMarkdown("proj2.1_Upload_Tutorial.md"),
              downloadButton("downloadData", "Download"),
              includeMarkdown("proj2.2_Upload_Tutorial.md"),
              fileInput("file", "Choose CSV File",multiple = FALSE, accept = NULL,
                        width = NULL, buttonLabel = "Browse...",
                        placeholder = "No file selected"),
              actionButton("preview", "Preview Current Data Set"),
              dataTableOutput("impOut"),
              includeMarkdown("proj2.3_Upload_Tutorial.md")
      ),
      tabItem(tabName = "proj3",
              h2("Data Analysis Report", align = "center"),
              h3("(Data Analysis Report)", align = "center"),
              tags$hr(style=
                        "border-color: black;
                         border-width: 2px;"),
              includeHTML("proj3_Data_Report.html")
      )
    )
  ))

server <- function(input,output) { 

  output$downloadData <- downloadHandler(
    filename = function() {
      paste("nurses", ".csv", sep="")
    },
    content = function(file) {
      write.csv(nurses, file)
    }
  )
  
  observeEvent(
    input$preview, 
    {
      fileDat <- read.csv(input$file$datapath, header = TRUE)
      output$impOut <- renderDataTable({
        datatable(fileDat)
      })
    })
 }

shinyApp(ui,server)

#Credits

#nurses data set: https://github.com/rfordatascience/tidytuesday/tree/master/data/2021/2021-10-05
#header code credit: https://stackoverflow.com/questions/45176030/add-text-on-right-of-shinydashboard-header
#header code credit: https://stackoverflow.com/questions/45176030/add-text-on-right-of-shinydashboard-header
