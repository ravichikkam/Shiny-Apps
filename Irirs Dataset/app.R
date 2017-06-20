library(shiny)
library(ggplot2)
library(datasets)


ui <- fluidPage(

  tags$h1("Understanding Iris Dataset"),
  
  sidebarLayout(
    sidebarPanel(
      
      fileInput("file1", "Choose CSV File",
                accept = c(
                  "text/csv",
                  "text/comma-separated-values,text/plain",
                  ".csv")
      ),
      actionButton(inputId = "up",
                   label = "Upload"),
      
      tags$hr(),
      selectInput(inputId = "drop", 
                  label = "Select a month",
                  choices = colnames(iris)
      ),
      
      tags$hr(),
      actionButton(inputId = "go",
                   label = "Update")
      
    ),
    
    mainPanel(
      
      plotOutput(outputId = "hist"),
      verbatimTextOutput(outputId = "sum"),
      tableOutput(outputId = "dataset")
    )
  )
)

server <- function(input, output) {
  
  output$dataset <- renderTable({
    datafile <- input$file1
    read.csv(file = datafile$datapath)
  }) 
  data <- eventReactive(input$go, {input$drop})
  output$hist <- renderPlot({
    
    ggplot(data = iris, aes_string(x = data())) + geom_bar(fill = "blue")
    
  })
  
  output$sum <- renderPrint({
    summary(iris[,data()])
  })
  
}

shinyApp(ui = ui, server = server)
