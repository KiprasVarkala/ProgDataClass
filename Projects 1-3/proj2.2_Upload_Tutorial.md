<font size="5">What about importing data in and checking that is imported successfully?</font>

<font size="5">If you are developing a Shiny application so that others can make use of it, more common is the situation where people will be uploading their own data instead of downloading data already provided. This type of functionality is much more tricky considering that you are not able to control for what data sets get inputed. You can only set up guarantees for what will work and what will not work through careful coding and written disclaimers to your user base.</font>

<font size="5">This tutorial will show you how to implement a file upload feature AND how to verify that your data was properly uploaded </font>

# _Let's Get Started!_

<font size="5">One of the biggest upsides to using Shiny is the pre-built functions that allow us to simply designate the arguments in order to get the application working properly.</font>

<font size="5">-We use the fileInput() function generate the UI-side of the application.</font>

<font size="5">-We can also use the 'accept = ' argument to restrict the types of files allowed for upload. This feature is useful if your subsequent applications are dependent on data being organized in a certain format.</font>

<font size="5">Below, we implement the fileInput() function</font>
```{r Upload UI}
tabItem(tabName = "app2",
              h2("File Upload Widget with a Preview Feature.", align = "center"),
              tags$hr(style=
                        "border-color: black;
                         border-width: 2px;"),
              fileInput("file", "Choose CSV File",multiple = FALSE, accept = NULL,
                        width = NULL, buttonLabel = "Browse...",
                        placeholder = "No file selected")
      )
```

<font size="5">The issue with just having a file upload feature is that there is no way of knowing that the file you upload was registered the way you wanted it to (aside from it being successfully accepted by the fileInput function)</font>

<font size="5">One of the ways we can work around this issues is by:</font>

<font size="5">
<ul>
<li>Creating and button to generate a preview table of the data</li>
<li>Generating the output table</li>
</ul>
</font>


<font size="5">-On the UI side, we create the button using the actionButton() function and giving it an ID and a relevant name.</font>

<font size="5">-We also create prime a data table using the dataTableOutput() function and giving it ID.</font>
```{r Preview UI}
tabItem(tabName = "app2",
              h2("File Upload Widget with a Preview Feature.", align = "center"),
              tags$hr(style=
                        "border-color: black;
                         border-width: 2px;"),
              fileInput("file", "Choose CSV File",multiple = FALSE, accept = NULL,
                        width = NULL, buttonLabel = "Browse...",
                        placeholder = "No file selected"),
              actionButton("preview", "Preview Current Data Set"),
              dataTableOutput("impOut")
              )
      )
```
<font size="5">The Server side of things is a little bit more tricky as we are creating a code chunk that is dependent on whether the action button is triggered or not.</font>
```{r Server}
 observeEvent( #We use this function to stay passive until our 'preview' button is activated.
 #Once the preview button is triggered, the code nested in the brackets is run.
    input$preview, 
    {
    #We use the input received from the upload feature to create a data set that is then rendered into a data table.
      fileDat <- read.csv(input$file$datapath, header = TRUE)
      #The dataTableOutput fucntion that we primed is now receiving information about the uploaded data and generating a data   table. 
      output$impOut <- renderDataTable({
        datatable(fileDat)
      })
    })
```

# _Here is what the final product should look like:_
