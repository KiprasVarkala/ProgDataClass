#############################
#WORKING
#WORKING
#WORKING
#WORKING WORKING WORKING
#############################

library(DT)
library(mosaic)
library(rio)
library(shiny)
library(shinydashboard)
library(tidytuesdayR)
library(ggplot2)
library(dplyr)
library(markdown)
library(ggvis)


#Global
tuesdata <- tidytuesdayR::tt_load(2021, week = 41)

nurses <- na.omit(tuesdata$nurses)

nursesSub <- 
  nurses %>% 
  select(c(3, 5, 6, 7)) %>% 
  filter_at(vars(`Total Employed RN`, `Hourly Wage Avg`, `Hourly Wage Median`, `Annual Salary Avg`), all_vars(!is.na(.)))

variables <- c(
  "Total Employed RN",
  "Hourly Wage Avg", 
  "Hourly Wage Median",
  "Annual Salary Avg" 
)


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
    #header code credit: https://stackoverflow.com/questions/45176030/add-text-on-right-of-shinydashboard-header
    #header code credit: https://stackoverflow.com/questions/45176030/add-text-on-right-of-shinydashboard-header
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
              downloadButton("downloadData", "Download"),
              fileInput("file", "Choose CSV File",multiple = FALSE, accept = NULL,
                        width = NULL, buttonLabel = "Browse...",
                        placeholder = "No file selected"),
              actionButton("preview", "Preview Current Data Set"),
              fluidRow(
                column(
                  dataTableOutput("impOut"), width = 4)
              )
      ),
      tabItem(tabName = "proj3",
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

server <- function(input,output) { 
  
  # observeEvent(
  #   input$plot,
  #   {
  #     xvar_name <- names(variables)[variables == input$xvar]
  #     yvar_name <- names(variables)[variables == input$yvar]
  #     output$scatterPlot <- renderPlot({
  #       ggplot(nurses, aes(x, y)) + geom_point() +
  #         geom_smooth(method = lm, fullrange = TRUE, color = "black") +
  #         geom_point(color = "black", alpha = 0.25)
  #     })
  #   }
  # )
  
  output$downloadData <- downloadHandler(
    filename = function() {
      paste("nurses", ".csv", sep="")
    },
    content = function(file) {
      write.csv(nursesSub, file)
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
  
  # output$scatterPlot <- reactive({
  #   # Lables for axes
  #   xvar_name <- names(variables)[variables == input$xvar]
  #   yvar_name <- names(variables)[variables == input$yvar]
  #   
  #   # Normally we could do something like props(x = ~BoxOffice, y = ~Reviews),
  #   # but since the inputs are strings, we need to do a little more work.
  #   xvar <- prop("x", as.symbol(input$xvar))
  #   yvar <- prop("y", as.symbol(input$yvar))
  # 
  #     ggplot(nurses, aes(xvar, yvar)) + geom_point() +
  #              geom_smooth(method = lm, fullrange = TRUE, color = "black") +
  #              geom_point(color = "black", alpha = 0.25)
  # })
      
      datasetInput <- reactive({
        switch(input$xVar,
               "Year",
               "Total Employed RN",
               "Hourly Wage Avg",
               "Annual Salary Avg"
        )
      })

      datasetInput <- reactive({
        switch(input$yVar,
               "Year",
               "Total Employed RN",
               "Hourly Wage Avg",
               "Annual Salary Avg"
        )
      })

      selectedData <- reactive({
        nursesSub[, c(input$xvar, input$yvar)]
      })
      
      observeEvent(
        input$preview, 
        {
      output$scatterPlot <- renderPlot({
        palette(c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3",
                  "#FF7F00", "#FFFF33", "#A65628", "#F781BF", "#999999"))
        
        par(mar = c(5.1, 4.1, 0, 1))
        plot(selectedData())
        points()
      })
        }
      )
#   output$title <- renderText({
#     input$title
#   })
# 
#   output$summary <- renderPrint({
#     dataset <- datasetInput()
#     summary(dataset)
#   })
# 
#   output$view <- renderTable({
#     head(datasetInput(), n = input$obs)
#   })
 #      vis <- reactive({
 #        
 #        # Lables for axes
 #        xvar_name <- names(variables)[variables == input$xvar]
 #        
 #        # Normally we could do something like props(x = ~BoxOffice, y = ~Reviews),
 #        # but since the inputs are strings, we need to do a little more work.
 #        xvar <- prop("x", as.symbol(input$xvar))
 #        # yvar <- prop("y", as.symbol(input$yvar))
 #        
 #        nursesSub %>%
 #          ggvis(x = xvar) %>%
 #          layer_histograms() %>%
 #          add_axis("x", title =  xvar_name) %>%
 #          # add_axis("y", title = yvar_name) %>%
 #          set_options(width = 500, height = 500)
 #        
 #      })
 #      
 #      vis %>% bind_shiny("scatterPlot")
 }

shinyApp(ui,server)

#Credits

#nurses data set: https://github.com/rfordatascience/tidytuesday/tree/master/data/2021/2021-10-05
