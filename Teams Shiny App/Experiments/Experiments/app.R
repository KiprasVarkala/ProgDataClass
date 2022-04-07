#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

ui <- fluidPage(
  textInput("a",""),
  actionButton("go", "")
)
server <-
  function(input,output){
    observeEvent(input$go,
                 print(input$a))
  }
shinyApp(ui, server)