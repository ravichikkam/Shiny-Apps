library(shiny)
library(ggplot2)
library(datasets)


ui <- fluidPage(

  tags$h1("Understanding Iris Dataset"),
  
  sidebarLayout(
    sidebarPanel(
      
      #uiOutput("file1")
      fileInput("file1", "Choose CSV File",
                accept = c(
                  "text/csv",
                  "text/comma-separated-values,text/plain",
                  ".csv")
      ),
      actionButton(inputId = "up",
                   label = "Upload"),
      
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
  
  # output$dataset <- renderTable({
  #   datafile <- input$file1
  #   read.csv(file = datafile$datapath)
  # }) 
  output$drop <- renderUI({
    datafile <- input$file1
    if(is.null(datafile)){
      return(NULL)
    }
    data <- read.csv(file = datafile$datapath)
    selectInput("coloums", "Select a variable", choices = colnames(data))
  })
  cname <- eventReactive(input$go, {input$drop})
  
  output$hist <- renderPlot({
    datafile1 <- input$file1
    if(is.null(datafile1)){
      return(NULL)
    }
    data1 <- read.csv(file = datafile1$datapath)
    data1 <- na.omit(data1)
    ggplot(data = data1, aes_string(cname())) + geom_bar(fill = "blue")
    
  })
  
  output$sum <- renderPrint({
    datafile2 <- input$file1
    if(is.null(datafile2)){
      return(NULL)
    }
    data2 <- read.csv(file = datafile2$datapath)
    summary(data2[,cname()])
  })
  
}

shinyApp(ui = ui, server = server)
