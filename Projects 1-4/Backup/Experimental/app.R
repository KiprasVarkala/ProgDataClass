#############################
#WORKING
#WORKING
#WORKING
#WORKING Experimental
#############################

library(DT)
library(mosaic)
library(rio)
library(shiny)
library(shinydashboard)
library(tidytuesdayR)
library(ggplot2)
library(gapminder)
library(dplyr)
library(ggvis)
library(forcats)

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
                            value = "Insert your title here"),
                  selectInput("xvar", "Select a variable to investigate!", variables, selected = "Total Employed RN"),
                  # selectInput("yvar", "Y-axis variable", variables, selected = "Year"),
                  # actionButton(inputId = "plot",
                  #              label = "Plot!"),
                  ggvisOutput("scatterPlot")
                )
              )
      )
    )
  ))

server <- function(input,output) { 
  
  # output$plot1 <- renderPlot({
  #   ggplot(keep, aes(wt, mpg)) + geom_point() +
  #     geom_smooth(method = lm, fullrange = TRUE, color = "black") +
  #     geom_point(data = exclude, shape = 21, fill = NA, color = "black", alpha = 0.25) +
  #     coord_cartesian(xlim = c(1.5, 5.5), ylim = c(5,35))
  # })
  
  # selectedData <- reactive({
  #   nursesSub[, c(input$xvar, input$yvar)]
  # })
  
  # clusters <- reactive({
  #   kmeans(selectedData(), input$clusters)
  # })
  # 
#   output$scatterPlot <- renderPlot({
#     palette(c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3",
#               "#FF7F00", "#FFFF33", "#A65628", "#F781BF", "#999999"))
#     par(mar = c(5.1, 4.1, 0, 1))
#     plot(selectedData(),
#          col = clusters()$cluster,
#          pch = 20, cex = 3)
#     points(clusters()$centers, pch = 4, cex = 4, lwd = 4)
#   })
  
  vis <- reactive({
  
  # Lables for axes
  xvar_name <- names(variables)[variables == input$xvar]
  yvar_name <- names(variables)[variables == input$yvar]
  
  # Normally we could do something like props(x = ~BoxOffice, y = ~Reviews),
  # but since the inputs are strings, we need to do a little more work.
  xvar <- prop("x", as.symbol(input$xvar))
  # yvar <- prop("y", as.symbol(input$yvar))
  
  nursesSub %>%
    ggvis(x = xvar) %>%
    layer_histograms() %>%
    add_axis("x", title = input$title) %>%
    # add_axis("y", title = yvar_name) %>%
    set_options(width = 500, height = 500)

})
  
vis %>% bind_shiny("scatterPlot")
  
}

shinyApp(ui,server)

#Credits

#nurses data set: https://github.com/rfordatascience/tidytuesday/tree/master/data/2021/2021-10-05
