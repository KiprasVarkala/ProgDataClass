<font size="5">Whether you are trying to structure a lesson, create a utility website, or want to showcase your professional portfolio, using Shiny may be an option worth considering. It is great for when you want to do simple projects and are new to coding, but it is not recommended for complicated and resource intensive designs.</font>

<font size="5">This tutorial will specifically show you how to setup a Shiny Dashboard within Shiny. However, there is a [website](https://shiny.rstudio.com/) dedicated to all things Shiny. The community in stackoverflow is also a very reliable resource when the Shiny tutorials are not helpful enough.</font>


              
# _Getting Started:_

<font size="5">-To begin, we have to open up the right work space.</font>

<font size="5">-To do that, you'll want to open RStudio > File > New File > Shiny Web App...</font>

<font size="5">-It should look something like this:</font>

![shinyWebbApp](shinyWebApp.png)

<font size="5">-Pick a representative name for the project and make sure you have the directory of your preference set.</font>

<font size="5">-The nice thing about Shiny, is that it is very user-friendly and automatically populates a default template for you. Go ahead and click *run app* in the top right hand corner if you would like to explore how the template looks in "app" form.</font>

<font size="5">-For this tutorial, we will be loading and using Shiny Dashboard instead. Therefore, we will be deleting everything and starting from scratch.</font>

<font size="5">-Before we crack our knuckles, it is important to understand the basic logic of how a Shiny app works. There are two main components:</font>

<font size="5">
<ul>
<li>The UI (User Interface)</li>
<li>The Server</li>
</ul>
</font>

![structure](structure2.png)

<font size="5">
<ul>
<li>The UI serves to tailor the "front-end" experience. Anything you code here will usually be visible. (E.g., A 'download' button). However, the UI does not focus so much on functionality as it does on appearance. If we were to make a 'download' button and try to then click it....nothing would happen</li>
<li>The Server serves to respond to the automatic or user-created requests and processes them accordingly. If we go back to our 'download' button example, once the user clicks the button, if the server is set to respond to the click, it will execute a function. In this case, initiating a download.</li>
</ul>
</font>

<font size="5">*Such is the basic song and dance of the internet as a whole. Regardless of the coding language you use.*</font>

# _Now for the fun part:_
# _Let's make a Shiny Dashboard!_

<font size="5">-Delete everything in your Shiny web app and paste this code instead.</font>

<font size="5">-Follow along with the comments to understand th basic structure of the Shiny Dashboard UI.</font>

<font size="5">-Once you have finished reading through the code, go ahead and run the app and see how it works!</font>

<font size="5">(Don't be afraid to mess around with the variables)</font>
```{r UI} 
#Load your libraries
library(shiny)
library(shinydashboard)
library(tidytuesdayR)

#Global variables. These variables can be referenced anywhere because they are outside of the UI and Server. In this case,
#we are loading up some open access data on nurses to play around with. For the sake of simplicity, we will only be using a subset of the data.

#Global
tuesdata <- tidytuesdayR::tt_load(2021, week = 41)

nurses <- na.omit(tuesdata$nurses)

nurses <- 
  nurses %>% 
  select(c(3, 5, 6, 7)) %>% 
  filter_at(vars(`Total Employed RN`, `Hourly Wage Avg`, `Hourly Wage Median`, `Annual Salary Avg`), all_vars(!is.na(.)))

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
#Ignore the Server side of things for now
server <- function(input, output) {
}
}

# Run the application 
shinyApp(ui = ui, server = server)
```
<font size="5">-Now that you have run your Shiny application, you probably noticed that the download button did not work at all. That is because we have not told the Server to do anything with that input so far.</font>

<font size="5">-Let's go ahead and swap out the server code for code that will actually recognize the user's needs</font>

<font size="5">-Like for the UI, go ahead and read through the code and follow along with the comments. Once finished, go ahead and run the app again and see what the download button does.</font>
```{r Server}
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
```

# _Congratulations! You have now successfully created a Shiny Dashboard AND a functioning application._

<font size="5">Shiny Dashboard is versatile in that you can create your own application from a variety of [templates](https://shiny.rstudio.com/gallery/widget-gallery.html) and [examples](https://shiny.rstudio.com/gallery/) that will allow for more streamlined presentation of data or information than if you would in a simple R-markdown file. You can even embed markdown files. This entire tutorial was made in markdown and imported into Shiny.</font>

<font size="5">nurses data set: https://github.com/rfordatascience/tidytuesday/tree/master/data/2021/2021-10-05</font>
