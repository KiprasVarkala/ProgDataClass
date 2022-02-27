### Teams Attendance Script

install.packages("shiny")
library(shiny)

# Replace this with your own function to graph the data
CrunchMyDataPlease <- function(df){
  library(ggplot2)
  
  
  histogram <- ggplot(data=df, aes(x=Sepal.Width))
  histogram + geom_histogram(binwidth=0.2, color="black", aes(fill=Species)) + 
    xlab("Sepal Width") +  ylab("Frequency") + ggtitle("Histogram of Sepal Width")
}


# Define UI for application
ui <- fluidPage(
  
  # Application title
  titlePanel("Graph me up"),
  
  # Sidebar with a tool to upload a csv file
  sidebarLayout(
    sidebarPanel(
      fileInput("file1", "Choose CSV File",
                accept = c("text/csv",
                           "text/comma-separated-values,text/plain",
                           ".csv"))
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot")
    )
  )
)

# Define server logic required
server <- function(input, output) {
  
  output$distPlot <- renderPlot({
    req(input$file1)  # Don't do anything until the file has been chosen
    df <- read.csv(input$file1$datapath)  # Read in the csv file selected
    GraphMyDataPlease(df)  # Make a graph of the data
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)