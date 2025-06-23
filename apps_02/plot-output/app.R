library(shiny)

ui <- fluidPage(
    plotOutput("plot1", height = "400px", width = "400px"),
    plotOutput("plot2")
)

server <- function(input, output, session) {
    output$plot1 <- renderPlot(plot(1:5), res = 96)
    output$plot2 <- renderPlot(plot(1:5), res = 96)
}

shinyApp(ui, server)
