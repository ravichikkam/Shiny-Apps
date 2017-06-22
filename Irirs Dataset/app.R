library(shiny)
library(ggplot2)
library(datasets)


ui <- fluidPage(
  
  tags$h1("Understanding your Data"),
  
  sidebarLayout(
    sidebarPanel(
      
      #uiOutput("file1")
      fileInput("file1", "Choose CSV File",
                accept = c(
                  "text/csv",
                  "text/comma-separated-values,text/plain",
                  ".csv")
      ),

      tags$hr(),
      uiOutput("drop"),
      # selectInput(inputId = "drop", 
      #             label = "Select a month",
      #             choices = colnames(iris)
      #),
      
      tags$hr(),
      actionButton(inputId = "go",
                   label = "Update")
      
    ),
    
    mainPanel(
      
      plotOutput(outputId = "hist"),
      verbatimTextOutput(outputId = "sum")
      #tableOutput(outputId = "dataset")
    )
  )
)

server <- function(input, output) {
  
  data <- reactive({
    datafile <- input$file1
    if(is.null(datafile)){
      return(NULL)
    }
    dataset <- read.csv(datafile$datapath)
    dataset <- na.omit(dataset)
    return(dataset)
  }) 
  output$drop <- renderUI({
    
    selectInput("coloums", "Select a variable", choices = colnames(data()))
    
  })
  
  cname <- eventReactive(input$go, {input$coloums})
  
  
  output$hist <- renderPlot({
    
      ggplot(data = data(), aes_string(x = cname())) + geom_bar(fill = "blue")
    
  })
  
  output$sum <- renderPrint({
   
    summary(data()[,cname()])
    
  })
  
}

shinyApp(ui = ui, server = server)
