library(shiny)
library(tidyverse)
library(class)
library(caret)

# Define UI for data upload app ----
ui <- fluidPage(
    
    # App title ----
    titlePanel("Import Combined beer/brewery dataset"),
    
    # Sidebar layout with input and output definitions ----
    sidebarLayout(
        
        # Sidebar panel for inputs ----
        sidebarPanel(
            
            #Input: select file
            fileInput("file1", "Choose CSV File",
                      multiple = TRUE,
                      accept = c("text/csv",
                                 "text/comma-separated-values,text/plain",
                                 ".csv")),
                    
            #Input: select hist or boxplots
            selectInput("select", label = h3("Choose Plot Type"),
                     choices = list("Histogram - ABV" = "abvhistogram", "Boxplot - ABV" = "abvboxplot","Histogram - IBU" = "ibuhistogram", "Boxplot - IBU" = "ibuboxplot"), 
                     selected = 1), 
                    hr(),
                    fluidRow(column(3, verbatimTextOutput("value")))
                    ),
        
            #Input: filter by state
     
        

        # Main panel for displaying outputs ----
        mainPanel(
            
            # Output: Data file ----
      
           plotOutput(outputId = "distplot")
       
        )
        
    )
)

# Define server logic to read selected file ----
server <- function(input, output) {
    
    output$contents <- renderTable({
        
        # input$file1 will be NULL initially. After the user selects
        # and uploads a file, head of that data file by default,
        # or all rows if selected, will be shown.
        
        req(input$file1)
        
        Beer2 <- read.csv(input$file1$datapath,
                          header = TRUE)
        
    })
    
    
    output$distplot <- renderPlot({
        
        if(input$select == "abvhistogram")
        {
        #Hist and boxplots
        ABVhist <- hist(Beer2$ABV, breaks = 20, main = "Distribution of Alcohol Content", xlab = "Alcohol By Volume")
 
        }
        
        if(input$select == "abvboxplot")
        {
        ABVbox <- boxplot(Beer2$ABV, main = "Distribution of Alcohol Content")

        }
        if(input$select == "ibuhistogram")
        {
            #Hist and boxplots
            IBUhist <- hist(Beer2$IBU, breaks = 20, main = "Distribution of Bitterness", xlab = "Bitterness Units")
            
        }
        
        if(input$select == "ibuboxplot")
        {
        IBUbox <- boxplot(Beer2$IBU, main = "Distribution of Bitterness")
            
        }
    })
}


shinyApp(ui, server)