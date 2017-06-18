library(shiny)
library(ggplot2)
library(datasets)

ui <- fluidPage(
  selectInput(inputId = "drop", 
              label = "Select a month",
              choices = colnames(iris)
              ),
  
  mainPanel(
    plotOutput(outputId = "hist")
  )
)

server <- function(input, output) {
  output$hist <- renderPlot({
    
    ggplot(data = iris, aes_string(x = input$drop)) + geom_bar(fill = "blue")
    
  })
}

shinyApp(ui = ui, server = server)