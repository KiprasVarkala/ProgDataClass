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
      menuItem("1. Test", tabName = "proj1",  icon = icon("image")),
      menuItem("2. Test", tabName = "proj2", icon = icon("map")),
      menuItem("3. Test", tabName = "proj3", icon = icon("file-code")),
      menuItem("4. Test", tabName = "proj4", icon = icon("chart-bar"))
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
              h2("Project 1")
      ),
      tabItem(tabName = "proj2",
              h2("Project 2")
      ),
      tabItem(tabName = "proj3",
              h2("Project 3")
      ),
      tabItem(tabName = "proj4",
              h2("Project 4")
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