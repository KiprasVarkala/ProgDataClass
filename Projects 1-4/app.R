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


tuesdata <- tidytuesdayR::tt_load(2021, week = 41)

nurses <- tuesdata$nurses

variables <- c(
  "State", 
  "Year", 
  "Total Employed RN",
  "Employed Standard Error (%)", 
  "Hourly Wage Avg", 
  "Hourly Wage Median", 
  "Annual Salary Avg", 
  "Annual Salary Median", 
  "Wage/Salary standard error (%)", 
  "Total Employed (National)_Aggregate", 
  "Total Employed (Healthcare, National)_Aggregate", 
  "Total Employed (Healthcare, State)_Aggregate", 
  "Yearly Total Employed (State)_Aggregate")

ui <- dashboardPage(
  skin = "green",
  dashboardHeader(title = "Projects"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("1. Shiny App", tabName = "proj1",  icon = icon("file-code")),
      menuItem("2. File Upload", tabName = "proj2", icon = icon("file-upload")),
      menuItem("3. Scatter-Plotter-9000", tabName = "proj3", icon = icon("image")),
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
              h2("Scatter-Plotter-9000", align = "center"),
              h3("(Shiny App)", align = "center"),
              # img(src='First-Aid.png', align = "right", width="400" height="300" alt="This is alternate text"),
              tags$hr(style=
                        "border-color: black;
                         border-width: 2px;"),
              fluidRow(
                mainPanel(
                  textInput(inputId = "title",
                            label = "Title:",
                            value = "The Relationship Between These Variables"),
                  selectInput("xvar", "X-axis variable", variables, selected = "Total Employed RN"),
                  selectInput("yvar", "Y-axis variable", variables, selected = "Year"),
                  # selectInput(inputId = "xVar",
                  #             label = "Choose a variable to plot on the X-axis",
                  #             choices = c("State", "Year", "Total Employed RN","Employed Standard Error (%)", "Hourly Wage Avg", "Hourly Wage Median", "Annual Salary Avg", "Annual Salary Median", "Wage/Salary standard error (%)", "Total Employed (National)_Aggregate", "Total Employed (Healthcare, National)_Aggregate", "Total Employed (Healthcare, State)_Aggregate", "Yearly Total Employed (State)_Aggregate")),
                  # selectInput(inputId = "yVar",
                  #             label = "Choose a variable to plot on the X-axis",
                  #             choices = c("State", "Year", "Total Employed RN","Employed Standard Error (%)", "Hourly Wage Avg", "Hourly Wage Median", "Annual Salary Avg", "Annual Salary Median", "Wage/Salary standard error (%)", "Total Employed (National)_Aggregate", "Total Employed (Healthcare, National)_Aggregate", "Total Employed (Healthcare, State)_Aggregate", "Yearly Total Employed (State)_Aggregate")),
                  actionButton(inputId = "plot",
                               label = "Plot!"),
                  # ggvisOutput("plot1")
                   renderPlot("scatterPlot", height = 350)
                #   # Output: Verbatim text for data summary ----
                #   verbatimTextOutput("summary"),
                #   
                #   # Output: HTML table with requested number of observations ----
                #   tableOutput("view")
                )
              )
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
  
  output$scatterPlot <- reactive({
    # Lables for axes
    xvar_name <- names(variables)[variables == input$xvar]
    yvar_name <- names(variables)[variables == input$yvar]
    
    # Normally we could do something like props(x = ~BoxOffice, y = ~Reviews),
    # but since the inputs are strings, we need to do a little more work.
    xvar <- prop("x", as.symbol(input$xvar))
    yvar <- prop("y", as.symbol(input$yvar))
  
      ggplot(nurses, aes(xvar, yvar)) + geom_point() +
               geom_smooth(method = lm, fullrange = TRUE, color = "black") +
               geom_point(color = "black", alpha = 0.25)
  })
      
  #     datasetInput <- reactive({
  #       switch(input$xVar,
  #              "State",
  #              "Year",
  #              "Total Employed RN",
  #              "Employed Standard Error (%)",
  #              "Hourly Wage Avg",
  #              "Hourly Wage Median",
  #              "Annual Salary Avg",
  #              "Annual Salary Median",
  #              "Wage/Salary standard error (%)",
  #              "Total Employed (National)_Aggregate",
  #              "Total Employed (Healthcare, National)_Aggregate",
  #              "Total Employed (Healthcare, State)_Aggregate",
  #              "Yearly Total Employed (State)_Aggregate"
  #       )
  #     })
  #     #
  #     # datasetInput <- reactive({
  #     #   switch(input$yVar,
  #     #          "State",
  #     #          "Year",
  #     #          "Total Employed RN",
  #     #          "Employed Standard Error (%)",
  #     #          "Hourly Wage Avg",
  #     #          "Hourly Wage Median",
  #     #          "Annual Salary Avg",
  #     #          "Annual Salary Median",
  #     #          "Wage/Salary standard error (%)",
  #     #          "Total Employed (National)_Aggregate",
  #     #          "Total Employed (Healthcare, National)_Aggregate",
  #     #          "Total Employed (Healthcare, State)_Aggregate",
  #     #          "Yearly Total Employed (State)_Aggregate"
  #     #   )
  #     # })
  # 
  # output$title <- renderText({
  #   input$title
  # })
  # 
  # output$summary <- renderPrint({
  #   dataset <- datasetInput()
  #   summary(dataset)
  # })
  # 
  # output$view <- renderTable({
  #   head(datasetInput(), n = input$obs)
  # })
  #   }
  # )
}

shinyApp(ui,server)

#Credits

#nurses data set: https://github.com/rfordatascience/tidytuesday/tree/master/data/2021/2021-10-05
