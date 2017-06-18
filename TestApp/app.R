library(shiny)
library(ggplot2)
library(datasets)


ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "drop", 
              label = "Select a month",
              choices = colnames(iris)
              )
    ),
    
    mainPanel(
     plotOutput(outputId = "hist"),
     verbatimTextOutput(outputId = "sum")
    )
  )
)

server <- function(input, output) {
  
  output$hist <- renderPlot({
    
    ggplot(data = iris, aes_string(x = input$drop)) + geom_bar(fill = "blue")
    
  })
  
  output$sum <- renderPrint({
    summary(iris[,input$drop])
  })
  
}

shinyApp(ui = ui, server = server)