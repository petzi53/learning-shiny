library(shiny)

ui <- fluidPage(
    selectInput("x", "X variable", choices = names(iris)),
    selectInput("y", "Y variable", choices = names(iris)),
    plotOutput("plot")
)
server <- function(input, output, session) {
    output$plot <- renderPlot({
        ggplot2::ggplot(iris, ggplot2::aes(.data[[input$x]], .data[[input$y]])) +
            ggplot2::geom_point(position = ggforce::position_auto())
    }, res = 96)
}

shinyApp(ui, server)
