library(shiny)
library(ggplot2)
library(datasets)


ui <- fluidPage(
  tags$h1("Understanding Iris Dataset"),
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "drop", 
              label = "Select a month",
              choices = colnames(iris)
              ),
      actionButton(inputId = "go",
                   label = "Update")
    ),
    
    mainPanel(
     plotOutput(outputId = "hist"),
     verbatimTextOutput(outputId = "sum")
    )
  )
)

server <- function(input, output) {
  
  data <- eventReactive(input$go, {input$drop})
  output$hist <- renderPlot({
    
    ggplot(data = iris, aes_string(x = data())) + geom_bar(fill = "blue")
    
  })
  
  output$sum <- renderPrint({
    summary(iris[,data()])
  })
  
}

shinyApp(ui = ui, server = server)