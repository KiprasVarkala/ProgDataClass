#Load your libraries
library(shiny)
library(shinydashboard)

#Global variables. These variables can be referenced anywhere because they are outside of the UI and Server. In this case,
#we are loading up some open access data on nurses to play around with. 
tuesdata <- tidytuesdayR::tt_load(2021, week = 41)

nurses <- na.omit(tuesdata$nurses)

ui <- dashboardPage( #The dashboardPage houses everything you will be coding on the UI front
  skin = "black", #theme color
  dashboardHeader(title = "Download App"), #Top left title. 
  dashboardSidebar( #Prescribing the name, ID, and icon of the sidebar selection.
    sidebarMenu(
      #tabName = is the ID that we prescribe so that the server knows how to identify what to manipulate. 
      menuItem("My App", tabName = "app1",  icon = icon("file-download")) 
     #menuItem("My 2nd App", tabName = "app2",  icon = icon("file-upload")) You can add as many sidebars as you like :)
    )
  ),
  
  dashboardBody( #The dashboardBody is like a mini-Server where you further define what is contained within each sidebar menu item.
  
  #This is not necessary, but allows for a title to be placed in the main blank space above the body using CSS.
    tags$head(tags$style(HTML( 
      '.myClass { 
        font-size: 20px;
        line-height: 50px;
        text-align: left;
        font-family: "Bookman Old Style",Bookman Old Style,Arial,sans-serif;
        padding: 0 15px;
        overflow: hidden;
        color: black;
      }
    '))),
    tags$script(HTML('
      $(document).ready(function() {
        $("header").find("nav").append(\'<span class="myClass"> Dashboard For All Of The Finer Things In Life </span>\');
      })
     ')),
  #Below is where we design the UI for each menu or tab item. Every menuItem() you create, a corresponding tabItem() must also
  #be created in the dashboardBody in order to populate anything once the menuItem is clicked on in the sidebar.
      tabItem(tabName = "app1", #set ID
              h2("My Very Own Download Button", align = "center"), #Set title and position
              tags$hr(style=
                        "border-color: black;
                         border-width: 2px;"), #Set a line to make things purty 
              #Here is the foretold 'download' button and Shiny just so happens to have a prebuilt function for that. 
              #The first argument in Shiny is almost always the ID and the second is the name or title that actually
              #appears on the UI side of things. 
              downloadButton("downloadData", "Download") 
      )
    )
  )
server <- function(input, output) {
#This function allows us to call for UI IDs based off of the input information provided by them AND send output back out
#to the UI.
#In this case, when we click the download button, we want the server to output a file for us.
#We chose to load in a data set about nurses. 
  
#Download button function
#Output$ allows us to call the output of whatever input is received through the associated ID in UI. 
   output$downloadData <- downloadHandler( #This function allows us to set the file name, appendix, and source arguments. 
    filename = function() {
      paste("nurses", ".csv", sep="")
    },
    content = function(file) {
      write.csv(nurses, file)
    }
  )
  
}

#Lastly, the shinyApp function runs all of the UI and Server code in tandem when we click *run app*.
# Run the application 
shinyApp(ui = ui, server = server)
