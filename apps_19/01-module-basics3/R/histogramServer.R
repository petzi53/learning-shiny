histogramServer <- function(id) {
    moduleServer(id, function(input, output, session) {
        data <- reactive(mtcars[[input$var]])
        output$hist <- renderPlot({
            hist(data(), breaks = input$bins, main = input$var)
        }, res = 96)
    })
}
